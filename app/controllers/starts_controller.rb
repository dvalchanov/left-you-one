class StartsController < ApplicationController
  layout "flow"

  def show
    session[:gift_discovery] ||= {
      "creation_key" => SecureRandom.urlsafe_base64(24, false),
      "creator_token" => CapabilityToken.issue.raw
    }
    @creation_key = session.dig(:gift_discovery, "creation_key")
    @themes = GiftTemplate::THEMES + [ GiftTemplates::Select::SURPRISE ]
  end
end
