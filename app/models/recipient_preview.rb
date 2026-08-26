require "yaml"

class RecipientPreview
  STATES = %w[arrival opening revealed with_you existing_journey].freeze
  PARAM_KEYS = %w[
    template sender recipient note holder_count places days visual_family finish
    background composition sealed_treatment motion grain overlay text_tone state
    reduced_motion mobile long_text anonymous_sender
  ].freeze
  DEFAULT_SENDER = "Dimitar"
  DEFAULT_RECIPIENT = "Anna"
  DEFAULT_NOTE = "I saw this and immediately thought of tomorrow. You’ve got this."
  DEFAULT_PLACES = "Sofia, Vienna, Berlin"
  LONG_MAIN_TEXT = "A quiet hour in which the unfinished thing is allowed to remain unfinished, and you are allowed to be a person before you become useful again."
  LONG_CONTEXT_TEXT = "For the afternoon that arrived carrying six small emergencies and one question nobody else can answer."
  LONG_RITUAL_TEXT = "Put it somewhere close. Let the next useful thing wait until the kettle has finished and the room sounds like itself again."
  LONG_NOTE = "I remembered the way you make space for everybody else, even on the days when there isn’t much left. This is a little space with your name on it. No reply needed."

  attr_reader :template, :visual, :sender_name, :recipient_name, :private_note,
    :holder_count, :places, :days_travelling, :sealed_treatment, :state

  def self.build(params = nil, catalog: GiftVisuals::Catalog.current, **attributes)
    source = (params || {}).to_h.merge(attributes)
    new(source.stringify_keys.slice(*PARAM_KEYS), catalog:)
  end

  def self.templates
    database_templates = GiftTemplate.active.order(:source_key).to_a
    return database_templates if database_templates.any?

    YAML.safe_load_file(Rails.root.join("db/gift_templates.yml"), aliases: false)
      .fetch("gift_templates")
      .select { |attributes| attributes.fetch("active", true) }
      .map { |attributes| GiftTemplate.new(attributes) }
  end

  def initialize(params, catalog:)
    @params = params.stringify_keys
    @catalog = catalog
    @template = select_template
    @anonymous_sender = truthy?(@params["anonymous_sender"])
    @long_text = truthy?(@params["long_text"])
    @reduced_motion = truthy?(@params["reduced_motion"])
    @mobile = truthy?(@params["mobile"])
    @sender_name = anonymous_sender? ? nil : clean_text(@params["sender"], DEFAULT_SENDER, 80)
    @recipient_name = clean_text(@params["recipient"], DEFAULT_RECIPIENT, 80)
    @private_note = clean_note(@params["note"], long_text? ? LONG_NOTE : DEFAULT_NOTE)
    @holder_count = bounded_integer(@params["holder_count"], default: 7, range: 1..99)
    @places = clean_places(@params["places"])
    @days_travelling = bounded_integer(@params["days"], default: 19, range: 0..9_999)
    @state = STATES.include?(@params["state"]) ? @params["state"] : "arrival"
    @visual = catalog.resolve(template:, overrides: @params)
    @sealed_treatment = catalog.allowed("sealed_treatments", @params["sealed_treatment"], "veil")
  end

  def main_text
    long_text? ? LONG_MAIN_TEXT : template.main_text
  end

  def context_text
    long_text? ? LONG_CONTEXT_TEXT : template.context_text
  end

  def ritual_text
    long_text? ? LONG_RITUAL_TEXT : template.ritual_text
  end

  def display_serial_number
    format("#%06d", (template.design_seed || 8421) + 8_000)
  end

  def anonymous_sender?
    @anonymous_sender
  end

  def long_text?
    @long_text
  end

  def reduced_motion?
    @reduced_motion
  end

  def mobile?
    @mobile
  end

  def revealed?
    %w[revealed with_you existing_journey].include?(state)
  end

  def possessed?
    %w[with_you existing_journey].include?(state)
  end

  def existing_journey?
    state == "existing_journey"
  end

  def arrival_line
    if sender_name.present?
      I18n.t("recipient.arrival.named_sender", sender: sender_name)
    else
      I18n.t("recipient.arrival.anonymous_sender")
    end
  end

  def recipient_line
    I18n.t("recipient.arrival.named_recipient", recipient: recipient_name)
  end

  def arrival_context
    if sender_name.present?
      I18n.t("recipient.arrival.context_named", sender: sender_name)
    else
      I18n.t("recipient.arrival.context_anonymous")
    end
  end

  def note_label
    if sender_name.present?
      I18n.t("recipient.note.from_sender", sender: sender_name)
    else
      I18n.t("recipient.note.from_anonymous")
    end
  end

  def origin_line
    I18n.t("journey.origin", sender: sender_name.presence || I18n.t("recipient.someone"))
  end

  def journey_intro
    I18n.t(
      "recipient.journey.began",
      sender: sender_name.presence || I18n.t("recipient.someone"),
      days: days_travelling
    )
  end

  def holder_position
    I18n.t("recipient.journey.holder_position", position: holder_count.ordinalize)
  end

  def journey_route
    places.join(" → ")
  end

  def journey_summary
    I18n.t(
      "recipient.journey.summary",
      people: holder_count,
      countries: places.size,
      days: days_travelling
    )
  end

  def query_params
    {
      template: template.source_key,
      sender: sender_name,
      recipient: recipient_name,
      note: private_note,
      holder_count:,
      places: places.join(", "),
      days: days_travelling,
      visual_family: visual.family_key,
      finish: visual.finish,
      background: visual.background_key,
      composition: visual.composition,
      sealed_treatment:,
      motion: visual.motion,
      grain: visual.grain,
      overlay: visual.overlay,
      text_tone: visual.text_tone,
      state:,
      reduced_motion: reduced_motion? ? "1" : nil,
      mobile: mobile? ? "1" : nil,
      long_text: long_text? ? "1" : nil,
      anonymous_sender: anonymous_sender? ? "1" : nil
    }.compact
  end

  private

  attr_reader :params, :catalog

  def select_template
    templates = self.class.templates
    templates.find { |candidate| candidate.source_key == params["template"] } || templates.first
  end

  def clean_text(value, fallback, limit)
    normalized = value.to_s.strip.gsub(/\s+/, " ")
    normalized = fallback if normalized.blank?
    normalized.truncate(limit, omission: "…")
  end

  def clean_places(value)
    source = value.to_s.presence || DEFAULT_PLACES
    source.split(",").filter_map do |place|
      clean = place.strip.gsub(/\s+/, " ").truncate(40, omission: "…")
      clean if clean.present?
    end.first(6).presence || DEFAULT_PLACES.split(", ")
  end

  def clean_note(value, fallback)
    normalized = value.to_s.strip.gsub(/\r\n?/, "\n").gsub(/[^\S\n]+/, " ").gsub(/\n{3,}/, "\n\n")
    normalized = fallback if normalized.blank?
    normalized.truncate(600, omission: "…")
  end

  def bounded_integer(value, default:, range:)
    Integer(value || default, exception: false).to_i.clamp(range)
  end

  def truthy?(value)
    ActiveModel::Type::Boolean.new.cast(value)
  end
end
