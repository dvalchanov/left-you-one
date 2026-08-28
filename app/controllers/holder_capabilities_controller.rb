class HolderCapabilitiesController < ApplicationController
  before_action :set_private_response_headers

  def show
    token = params[:token].to_s
    gift = Gift.find_by(current_holder_token_digest: CapabilityToken.digest(token))
    return head :not_found unless gift&.held? && CapabilityToken.matches?(token, gift.current_holder_token_digest)

    write_holder_access(gift, token)
    redirect_to public_gift_path(gift.public_slug), status: :see_other
  end
end
