module Dev
  class RecipientLabsController < BaseController
    layout "recipient_lab"

    def show
      @catalog = GiftVisuals::Catalog.current
      @preview = RecipientPreview.build(preview_params)
      @templates = RecipientPreview.templates
      @prototype_default = GiftVisuals::PrototypeDefault.current
      @return_to = params[:return_to].to_s if params[:return_to].to_s.match?(%r{\A/gifts/[A-Za-z0-9_-]+/manage\z})
    end
  end
end
