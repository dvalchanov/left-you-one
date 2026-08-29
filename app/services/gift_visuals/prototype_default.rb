require "fileutils"
require "tempfile"
require "yaml"

module GiftVisuals
  class PrototypeDefault
    ATTRIBUTES = %w[
      visual_family background finish composition sealed_treatment motion grain
      overlay text_tone
    ].freeze

    def self.default_path
      Rails.root.join("config/prototype_visual_default.yml")
    end

    def self.current(path: default_path, catalog: Catalog.current)
      new(path:, catalog:).current
    end

    def self.save!(attributes, path: default_path, catalog: Catalog.current)
      new(path:, catalog:).save!(attributes)
    end

    def self.snapshot_for(template, path: default_path, catalog: Catalog.current)
      new(path:, catalog:).snapshot_for(template)
    end

    def initialize(path:, catalog:)
      @path = Pathname(path)
      @catalog = catalog
    end

    def current
      raw = YAML.safe_load_file(path, aliases: false).fetch("prototype_default", {})
      sanitize(raw)
    rescue Errno::ENOENT, Psych::SyntaxError, TypeError
      sanitize({})
    end

    def save!(attributes)
      values = sanitize(attributes)
      FileUtils.mkdir_p(path.dirname)

      Tempfile.create([ path.basename.to_s, ".tmp" ], path.dirname) do |file|
        file.write({ "prototype_default" => values }.to_yaml)
        file.flush
        file.fsync
        File.rename(file.path, path)
      end

      values
    end

    def snapshot_for(template)
      defaults = current
      visual = catalog.resolve(template:, overrides: defaults)

      visual.to_h.stringify_keys.slice(
        "family_key", "background_key", "asset", "focal_position", "text_tone",
        "composition", "overlay", "motion", "grain", "accent", "finish"
      ).merge(
        "visual_family" => visual.family_key,
        "background" => visual.background_key,
        "sealed_treatment" => catalog.allowed("sealed_treatments", defaults["sealed_treatment"])
      )
    end

    private

    attr_reader :path, :catalog

    def sanitize(attributes)
      values = attributes.to_h.stringify_keys.slice(*ATTRIBUTES)
      family = catalog.allowed("families", values["visual_family"])
      background = catalog.allowed("backgrounds", values["background"], catalog.default_background_for(family))
      background = catalog.default_background_for(family) unless catalog.background_family(background) == family

      {
        "visual_family" => family,
        "background" => background,
        "finish" => catalog.allowed("finishes", values["finish"]),
        "composition" => catalog.allowed("compositions", values["composition"]),
        "sealed_treatment" => catalog.allowed("sealed_treatments", values["sealed_treatment"]),
        "motion" => catalog.allowed("motions", values["motion"]),
        "grain" => catalog.allowed("grains", values["grain"]),
        "overlay" => catalog.allowed("overlays", values["overlay"]),
        "text_tone" => catalog.allowed("text_tones", values["text_tone"])
      }
    end
  end
end
