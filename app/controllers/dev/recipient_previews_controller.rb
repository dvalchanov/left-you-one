module Dev
  class RecipientPreviewsController < BaseController
    layout "recipient_preview"

    def show
      @preview = RecipientPreview.build(preview_params)
    end
  end
end
