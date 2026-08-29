class PublicGiftsController < ApplicationController
  layout "recipient_preview"

  before_action :load_gift

  def show
    @holder = holder_access_for(@gift).present?
    set_private_response_headers if @holder || creator_token_for(@gift).present?

    if @gift.held?
      transfer = @gift.transfers.claimed.order(:claimed_at).last
      state = if @holder && params[:opening] == "1"
        "opening"
      elsif @holder
        @gift.journey_stops.size > 1 ? "existing_journey" : "with_you"
      else
        "revealed"
      end
      @presentation = RecipientPreview.for_gift(
        gift: @gift,
        transfer:,
        state:,
        recipient: @holder ? transfer&.intended_recipient_name : nil,
        note: @holder ? transfer&.private_note : nil
      )
    else
      @presentation = RecipientPreview.for_gift(
        gift: @gift,
        state: "arrival",
        viewer: "public_waiting",
        sender: nil,
        recipient: nil,
        note: nil,
        reveal_available: false
      )
    end
  end

  def journey
    @holder = holder_access_for(@gift).present?
    @creator = creator_token_for(@gift).present?
    return head :not_found unless @gift.held? && (@holder || @creator)

    set_private_response_headers
    @journey_stops = @gift.journey_stops.includes(:transfer).order(:sequence)
    if @holder
      @return_path = public_gift_path(@gift.public_slug)
      @return_label = I18n.t("flow.journey.back_to_gift")
    else
      @return_path = managed_gift_path(@gift.public_slug)
      @return_label = I18n.t("flow.journey.back_to_sender")
    end
  end

  private

  def load_gift
    @gift = Gift.find_by!(public_slug: params[:public_slug])
  end
end
