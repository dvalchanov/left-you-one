module Dev
  class RecipientLabsController < BaseController
    layout "recipient_lab"

    def show
      @catalog = GiftVisuals::Catalog.current
      @preview = RecipientPreview.build(preview_params)
      @templates = RecipientPreview.templates
    end
  end
end
