class RecipientClaimsController < ApplicationController
  layout "recipient_preview"

  before_action :set_private_response_headers

  def show
    @raw_token = params[:token].to_s
    @transfer = transfer_for(@raw_token)
    return render(:not_found, status: :not_found) unless @transfer

    if @transfer.pending? && @transfer.gift.waiting_for_claim?
      @presentation = RecipientPreview.for_gift(
        gift: @transfer.gift,
        transfer: @transfer,
        state: "arrival",
        reveal_available: false
      )
    else
      @gift = @transfer.gift
      render :already_claimed
    end
  end

  def create
    result = Transfers::Claim.call(raw_token: params[:token])
    if result.success?
      write_holder_access(result.gift, result.holder_token)
      redirect_to public_gift_path(result.gift.public_slug, opening: "1"), status: :see_other
    elsif result.gift
      redirect_to public_gift_path(result.gift.public_slug, from_claim: "1"), status: :see_other
    else
      render :not_found, status: :not_found
    end
  end

  private

  def transfer_for(raw_token)
    transfer = Transfer.find_by(claim_token_digest: CapabilityToken.digest(raw_token))
    transfer if transfer && CapabilityToken.matches?(raw_token, transfer.claim_token_digest)
  end
end
