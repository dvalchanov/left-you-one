module JourneyStops
  class UpdateIdentity
    class Unauthorized < StandardError; end
    class InvalidTransition < StandardError; end

    def self.call(gift:, holder_token:, holder_generation:, anonymous:, display_name:, city:, country_code:)
      new(
        gift:,
        holder_token:,
        holder_generation:,
        anonymous:,
        display_name:,
        city:,
        country_code:
      ).call
    end

    def initialize(gift:, holder_token:, holder_generation:, anonymous:, display_name:, city:, country_code:)
      @gift = gift
      @holder_token = holder_token
      @holder_generation = holder_generation.to_i
      @anonymous = ActiveModel::Type::Boolean.new.cast(anonymous)
      @display_name = normalize(display_name)
      @city = normalize(city)
      @country_code = country_code.to_s.strip.upcase.presence
    end

    def call
      Gift.transaction do
        gift.lock!
        authorize!
        stop = gift.current_journey_stop
        raise InvalidTransition unless stop

        anonymous_value = anonymous || [ display_name, city, country_code ].all?(&:blank?)
        stop.update!(
          anonymous: anonymous_value,
          display_name: anonymous_value ? nil : display_name,
          city: anonymous_value ? nil : city,
          country_code: anonymous_value ? nil : country_code
        )
        stop
      end
    end

    private

    attr_reader :gift, :holder_token, :holder_generation, :anonymous, :display_name, :city, :country_code

    def authorize!
      valid = gift.held? &&
        gift.holder_generation == holder_generation &&
        CapabilityToken.matches?(holder_token, gift.current_holder_token_digest)
      raise Unauthorized unless valid
    end

    def normalize(value)
      value.to_s.strip.gsub(/\s+/, " ").presence&.truncate(200, omission: "…")
    end
  end
end
