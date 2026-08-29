class LandingPagesController < ApplicationController
  layout "landing"

  def show
    @steps = I18n.t("landing.how.steps").values
    @paths = I18n.t("landing.paths.examples").values
  end
end
