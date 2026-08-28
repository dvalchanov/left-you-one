class CreatorCapabilitiesController < ApplicationController
  before_action :set_private_response_headers

  def show
    token = params[:token].to_s
    gift = Gift.find_by(creator_manage_token_digest: CapabilityToken.digest(token))
    return head :not_found unless gift && CapabilityToken.matches?(token, gift.creator_manage_token_digest)

    write_creator_access(gift, token)
    redirect_to managed_gift_path(gift.public_slug), status: :see_other
  end
end
