class ManagedGiftsController < ApplicationController
  layout "flow"

  before_action :set_private_response_headers
  before_action :load_gift
  before_action :require_creator

  def show
    @creator_token = creator_token_for(@gift)
    @price = helpers.prototype_price

    if @gift.discovered?
      prepare_discovered_scene
    elsif @gift.waiting_for_claim?
      prepare_waiting_scene
    else
      prepare_claimed_scene
    end
  end

  def recipient
    unless @gift.discovered? || @gift.waiting_for_claim?
      return redirect_to(managed_gift_path(@gift.public_slug), alert: I18n.t("flow.errors.already_claimed"), status: :see_other)
    end

    sender = normalized(params[:sender_display_name], 200)
    recipient = normalized(params[:intended_recipient_name], 200)
    if sender.blank?
      return redirect_to(
        managed_gift_path(@gift.public_slug, scene: "recipient"),
        alert: I18n.t("flow.errors.sender_required"),
        status: :see_other
      )
    end
    if recipient.blank?
      return redirect_to(
        managed_gift_path(@gift.public_slug, scene: "recipient"),
        alert: I18n.t("flow.errors.recipient_required"),
        status: :see_other
      )
    end

    write_gift_draft(
      @gift,
      {
        sender_display_name: sender,
        intended_recipient_name: recipient,
        private_note: normalized_note(params[:private_note]),
        claim_token: CapabilityToken.issue.raw
      }
    )
    redirect_to managed_gift_path(@gift.public_slug, scene: "commitment"), status: :see_other
  end

  def activate
    draft = gift_draft_for(@gift)
    return redirect_to(managed_gift_path(@gift.public_slug, scene: "recipient"), status: :see_other) if draft.empty?

    result = Gifts::ActivateForRecipient.call(
      gift: @gift,
      creator_token: creator_token_for(@gift),
      sender_display_name: draft["sender_display_name"],
      intended_recipient_name: draft["intended_recipient_name"],
      private_note: draft["private_note"],
      claim_token: draft["claim_token"]
    )
    write_pending_claim_access(@gift, result.transfer, result.claim_token)
    clear_gift_draft
    redirect_to managed_gift_path(@gift.public_slug), status: :see_other
  rescue Gifts::ActivateForRecipient::InvalidTransition
    redirect_to managed_gift_path(@gift.public_slug), alert: I18n.t("flow.errors.already_claimed"), status: :see_other
  end

  def cancel
    Gifts::CancelPendingTransfer.call(gift: @gift, creator_token: creator_token_for(@gift))
    clear_pending_claim_access
    clear_gift_draft
    redirect_to managed_gift_path(@gift.public_slug), notice: I18n.t("flow.sender.cancelled"), status: :see_other
  rescue Gifts::CancelPendingTransfer::InvalidTransition
    redirect_to managed_gift_path(@gift.public_slug), status: :see_other
  end

  def recipient_preview
    transfer = @gift.pending_transfer || @gift.transfers.claimed.order(:created_at).last
    return head :not_found unless transfer

    @presentation = RecipientPreview.for_gift(gift: @gift, transfer:, state: "arrival")
    render layout: "recipient_preview"
  end

  private

  def load_gift
    @gift = Gift.find_by!(public_slug: params[:public_slug])
  end

  def require_creator
    head :not_found unless creator_token_for(@gift)
  end

  def prepare_discovered_scene
    draft = gift_draft_for(@gift)
    case params[:scene]
    when "recipient"
      @scene = :recipient
      @draft = draft
    when "commitment"
      return redirect_to(managed_gift_path(@gift.public_slug, scene: "recipient"), status: :see_other) if draft.empty?

      @scene = :commitment
      @presentation = RecipientPreview.for_gift(
        gift: @gift,
        state: "with_you",
        viewer: "sender",
        sender: draft["sender_display_name"],
        recipient: draft["intended_recipient_name"],
        note: draft["private_note"],
        price: @price
      )
    else
      @scene = :discovery
      @presentation = RecipientPreview.for_gift(gift: @gift, state: "with_you", viewer: "discoverer")
    end
  end

  def prepare_waiting_scene
    @scene = :waiting
    @transfer = @gift.pending_transfer
    @presentation = RecipientPreview.for_gift(gift: @gift, transfer: @transfer, state: "revealed", viewer: "sender")
    access = pending_claim_access_for(@gift)
    @claim_url = open_claim_url(access["token"]) if access.present?
  end

  def prepare_claimed_scene
    @scene = :claimed
    @transfer = @gift.transfers.claimed.order(:claimed_at).last
    @presentation = RecipientPreview.for_gift(gift: @gift, transfer: @transfer, state: "revealed", viewer: "sender")
  end

  def normalized(value, limit)
    value.to_s.strip.gsub(/\s+/, " ").presence&.truncate(limit, omission: "…")
  end

  def normalized_note(value)
    value.to_s.strip.gsub(/\r\n?/, "\n").gsub(/[^\S\n]+/, " ").gsub(/\n{3,}/, "\n\n").presence&.truncate(5_000, omission: "…")
  end
end
