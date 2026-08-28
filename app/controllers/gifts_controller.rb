class GiftsController < ApplicationController
  def create
    discovery = session[:gift_discovery].to_h.stringify_keys
    unless discovery["creation_key"].present? && ActiveSupport::SecurityUtils.secure_compare(
      discovery["creation_key"], params[:creation_key].to_s
    )
      return redirect_to(start_path, alert: I18n.t("flow.errors.expired_start"), status: :see_other)
    end

    template = GiftTemplates::Select.call(theme: params[:theme])
    result = Gifts::Discover.call(
      gift_template: template,
      creation_key: discovery.fetch("creation_key"),
      creator_manage_token: discovery.fetch("creator_token")
    )
    session.delete(:gift_discovery)

    redirect_to creator_capability_path(result.creator_manage_token), status: :see_other
  rescue GiftTemplates::Select::InvalidTheme, GiftTemplates::Select::NoneAvailable
    redirect_to start_path, alert: I18n.t("flow.errors.no_gift"), status: :see_other
  end
end
