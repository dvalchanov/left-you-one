module Dev
  class GiftsController < BaseController
    def destroy
      gift = Gift.find_by!(public_slug: params[:public_slug])
      return head :not_found unless creator_token_for(gift)
      return redirect_to(managed_gift_path(gift.public_slug), alert: "Only an unactivated test gift can be deleted.", status: :see_other) unless gift.discovered? && gift.transfers.empty?

      gift.destroy!
      redirect_to start_path, notice: "The unactivated test gift was deleted.", status: :see_other
    end
  end
end
