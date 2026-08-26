module Dev
  class BaseController < ApplicationController
    before_action :require_local_environment

    private

    def require_local_environment
      head :not_found unless Rails.env.development? || Rails.env.test?
    end

    def preview_params
      params.permit(*RecipientPreview::PARAM_KEYS)
    end
  end
end
