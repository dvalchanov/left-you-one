module Dev
  class PrototypeVisualDefaultsController < BaseController
    def create
      values = GiftVisuals::PrototypeDefault.save!(
        params.permit(*GiftVisuals::PrototypeDefault::ATTRIBUTES)
      )
      render json: values
    end
  end
end
