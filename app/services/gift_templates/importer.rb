require "yaml"

module GiftTemplates
  class Importer
    ATTRIBUTES = %w[
      theme main_text context_text ritual_text visual_family finish
      background_key design_seed active
    ].freeze

    def self.call(path: Rails.root.join("db/gift_templates.yml"))
      new(path:).call
    end

    def initialize(path:)
      @path = Pathname(path)
    end

    def call
      entries = YAML.safe_load_file(path, aliases: false).fetch("gift_templates")
      raise ArgumentError, "gift_templates must be a list" unless entries.is_a?(Array)

      GiftTemplate.transaction do
        entries.map { |entry| import(entry.stringify_keys) }
      end
    end

    private

    attr_reader :path

    def import(entry)
      source_key = entry.fetch("source_key")
      template = GiftTemplate.find_or_initialize_by(source_key:)
      template.update!(entry.slice(*ATTRIBUTES))
      template
    end
  end
end
