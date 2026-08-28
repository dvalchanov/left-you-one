require "yaml"

module GiftVisuals
  class Catalog
    Visual = Data.define(
      :family_key,
      :family_name,
      :background_key,
      :background_name,
      :asset,
      :focal_position,
      :text_tone,
      :composition,
      :overlay,
      :motion,
      :grain,
      :accent,
      :finish
    )

    SECTIONS = %w[
      families backgrounds compositions sealed_treatments motions grains
      overlays text_tones finishes
    ].freeze

    def self.current
      return new if Rails.env.development?

      @current ||= new
    end

    def initialize(path: Rails.root.join("config/gift_visuals.yml"))
      @data = YAML.safe_load_file(path, aliases: false).deep_stringify_keys.freeze
    end

    def choices(section)
      section = section.to_s
      raise ArgumentError, "unknown visual section" unless SECTIONS.include?(section)

      data.fetch(section).map do |key, definition|
        definition.merge("key" => key)
      end
    end

    def default_background_for(family_key)
      family(family_key).fetch("default_background")
    end

    def background_family(background_key)
      data.fetch("backgrounds").fetch(background_key.to_s).fetch("family")
    end

    def resolve(template:, overrides: {})
      overrides = overrides.stringify_keys
      family_key = resolve_family(overrides["visual_family"], template.visual_family)
      background_key = resolve_background(overrides["background"], template.background_key, family_key)
      background = data.fetch("backgrounds").fetch(background_key)

      Visual.new(
        family_key:,
        family_name: family(family_key).fetch("name"),
        background_key:,
        background_name: background.fetch("name"),
        asset: background.fetch("asset"),
        focal_position: background.fetch("focal_position"),
        text_tone: allowed("text_tones", overrides["text_tone"], background["text_tone"]),
        composition: allowed("compositions", overrides["composition"], background["composition"]),
        overlay: allowed("overlays", overrides["overlay"], background["overlay"]),
        motion: allowed("motions", overrides["motion"], background["motion"]),
        grain: allowed("grains", overrides["grain"], background["grain"]),
        accent: background.fetch("accent", "warm"),
        finish: allowed("finishes", overrides["finish"], template.finish, default("finish"))
      )
    end

    def allowed(section, *candidates)
      options = data.fetch(section)
      candidates.compact.map(&:to_s).find { |candidate| options.key?(candidate) } || default_for_section(section)
    end

    private

    attr_reader :data

    def default(key)
      data.fetch("defaults").fetch(key)
    end

    def default_for_section(section)
      default(section.singularize)
    end

    def family(key)
      data.fetch("families").fetch(key)
    end

    def resolve_family(override, template_family)
      families = data.fetch("families")
      aliases = data.fetch("family_aliases")
      candidates = [ override, template_family, aliases[template_family.to_s], default("family") ].compact.map(&:to_s)

      candidates.find { |candidate| families.key?(candidate) } || default("family")
    end

    def resolve_background(override, template_background, family_key)
      backgrounds = data.fetch("backgrounds")
      candidates = [ override, template_background, default_background_for(family_key), default("background") ].compact.map(&:to_s)

      candidates.find { |candidate| backgrounds.key?(candidate) } || default("background")
    end
  end
end
