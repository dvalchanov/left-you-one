module LeftYouOne
  class Configuration
    attr_reader :prototype_mode, :display_price_cents, :display_currency

    def initialize(env: ENV, rails_env: Rails.env)
      @prototype_mode = boolean(env["PROTOTYPE_MODE"], default: rails_env.development?)
      @display_price_cents = integer(env.fetch("DISPLAY_PRICE_CENTS", 200), minimum: 0)
      @display_currency = env.fetch("DISPLAY_CURRENCY", "USD").upcase

      raise ArgumentError, "DISPLAY_CURRENCY must be a three-letter currency code" unless display_currency.match?(/\A[A-Z]{3}\z/)
    end

    private

    def boolean(value, default:)
      return default if value.nil?
      return true if %w[1 true yes on].include?(value.to_s.downcase)
      return false if %w[0 false no off].include?(value.to_s.downcase)

      raise ArgumentError, "PROTOTYPE_MODE must be true or false"
    end

    def integer(value, minimum:)
      Integer(value.to_s, 10).tap do |number|
        raise ArgumentError, "DISPLAY_PRICE_CENTS must be at least #{minimum}" if number < minimum
      end
    rescue ArgumentError => error
      raise error if error.message.start_with?("DISPLAY_PRICE_CENTS")

      raise ArgumentError, "DISPLAY_PRICE_CENTS must be an integer"
    end
  end

  def self.config
    @config ||= Configuration.new
  end
end

LeftYouOne.config
