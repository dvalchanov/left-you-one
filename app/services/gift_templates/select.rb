module GiftTemplates
  class Select
    SURPRISE = "surprise".freeze

    class InvalidTheme < StandardError; end
    class NoneAvailable < StandardError; end

    def self.call(theme:, random: Random)
      new(theme:, random:).call
    end

    def initialize(theme:, random:)
      @theme = theme.to_s
      @random = random
    end

    def call
      raise InvalidTheme, theme unless allowed_themes.include?(theme)

      templates = GiftTemplate.active
      templates = templates.where(theme:) unless theme == SURPRISE
      choices = templates.order(:id).to_a
      raise NoneAvailable, theme if choices.empty?

      choices.fetch(random.rand(choices.length))
    end

    private

    attr_reader :theme, :random

    def allowed_themes
      GiftTemplate::THEMES + [ SURPRISE ]
    end
  end
end
