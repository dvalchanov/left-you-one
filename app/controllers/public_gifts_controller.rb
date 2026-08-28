class PublicGiftsController < ApplicationController
  layout "recipient_preview"

  before_action :load_gift

  def show
    @holder_access = holder_access_for(@gift)
    @holder = @holder_access.present?
    @creator = creator_token_for(@gift).present?
    set_private_response_headers if @holder || @creator

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
        note: @holder ? transfer&.private_note : nil
      )
      @holder_url = holder_capability_url(@holder_access["token"]) if @holder
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

  def holder_identity
    access = holder_access_for(@gift)
    return head :not_found if access.empty?

    JourneyStops::UpdateIdentity.call(
      gift: @gift,
      holder_token: access["token"],
      holder_generation: access["holder_generation"],
      anonymous: params[:anonymous],
      display_name: params[:display_name],
      city: params[:city],
      country_code: params[:country_code]
    )
    redirect_to public_gift_path(@gift.public_slug), notice: I18n.t("flow.holder.identity_saved"), status: :see_other
  rescue ActiveRecord::RecordInvalid => error
    redirect_to public_gift_path(@gift.public_slug), alert: error.record.errors.full_messages.to_sentence, status: :see_other
  end

  private

  def load_gift
    @gift = Gift.find_by!(public_slug: params[:public_slug])
  end
end
