require "yaml"

class RecipientPreview
  STATES = %w[arrival opening revealed with_you existing_journey].freeze
  PARAM_KEYS = %w[
    template sender recipient note holder_count places days visual_family finish
    background composition sealed_treatment motion grain overlay text_tone state
    reduced_motion mobile long_text anonymous_sender viewer price
  ].freeze
  VIEWERS = %w[recipient sender discoverer public_waiting].freeze
  LAB_VIEWERS = %w[recipient sender].freeze
  DEFAULT_SENDER = "Dimitar"
  DEFAULT_RECIPIENT = "Anna"
  DEFAULT_PRICE = "$2"
  DEFAULT_NOTE = "I saw this and immediately thought of tomorrow. You’ve got this."
  DEFAULT_PLACES = "Sofia, Vienna, Berlin"
  LONG_MAIN_TEXT = "A quiet hour in which the unfinished thing is allowed to remain unfinished, and you are allowed to be a person before you become useful again."
  LONG_CONTEXT_TEXT = "For the afternoon that arrived carrying six small emergencies and one question nobody else can answer."
  LONG_RITUAL_TEXT = "Put it somewhere close. Let the next useful thing wait until the kettle has finished and the room sounds like itself again."
  LONG_NOTE = "I remembered the way you make space for everybody else, even on the days when there isn’t much left. This is a little space with your name on it. No reply needed."

  attr_reader :template, :visual, :sender_name, :recipient_name, :private_note,
    :holder_count, :places, :days_travelling, :sealed_treatment, :state, :viewer, :price, :gift

  def self.build(params = nil, catalog: GiftVisuals::Catalog.current, **attributes)
    source = (params || {}).to_h.merge(attributes)
    new(source.stringify_keys.slice(*PARAM_KEYS), catalog:)
  end

  def self.for_gift(
    gift:,
    transfer: nil,
    state:,
    viewer: "recipient",
    sender: transfer&.sender_display_name,
    recipient: transfer&.intended_recipient_name,
    note: transfer&.private_note,
    price: DEFAULT_PRICE,
    reveal_available: true,
    catalog: GiftVisuals::Catalog.current
  )
    stops = gift.journey_stops.order(:sequence).to_a
    places = stops.filter_map do |stop|
      [ stop.city, stop.country_code ].compact_blank.join(", ").presence
    end
    recipient_value = recipient.presence || I18n.t("recipient.someone")
    parameters = gift.visual_configuration.to_h.merge(
      "sender" => sender,
      "recipient" => recipient_value,
      "note" => note,
      "holder_count" => [ stops.size, 1 ].max,
      "places" => places.join(","),
      "days" => [ (Time.current.to_date - gift.discovered_at.to_date).to_i, 0 ].max,
      "state" => state,
      "viewer" => viewer,
      "anonymous_sender" => sender.blank? ? "1" : nil,
      "price" => price
    )

    new(
      parameters,
      catalog:,
      template: gift.gift_template,
      gift:,
      allow_blank_note: true,
      recipient_named: recipient.present?,
      synthetic_journey: false,
      reveal_available:
    )
  end

  def self.templates
    database_templates = GiftTemplate.active.order(:source_key).to_a
    return database_templates if database_templates.any?

    YAML.safe_load_file(Rails.root.join("db/gift_templates.yml"), aliases: false)
      .fetch("gift_templates")
      .select { |attributes| attributes.fetch("active", true) }
      .map { |attributes| GiftTemplate.new(attributes) }
  end

  def initialize(
    params,
    catalog:,
    template: nil,
    gift: nil,
    allow_blank_note: false,
    recipient_named: true,
    synthetic_journey: true,
    reveal_available: true
  )
    @params = params.stringify_keys
    @catalog = catalog
    @template = template || select_template
    @gift = gift
    @recipient_named = recipient_named
    @synthetic_journey = synthetic_journey
    @reveal_available = reveal_available
    @anonymous_sender = truthy?(@params["anonymous_sender"])
    @long_text = truthy?(@params["long_text"])
    @reduced_motion = truthy?(@params["reduced_motion"])
    @mobile = truthy?(@params["mobile"])
    @sender_name = anonymous_sender? ? nil : clean_text(@params["sender"], DEFAULT_SENDER, 80)
    @recipient_name = clean_text(@params["recipient"], DEFAULT_RECIPIENT, 80)
    note_fallback = allow_blank_note ? nil : (long_text? ? LONG_NOTE : DEFAULT_NOTE)
    @private_note = clean_note(@params["note"], note_fallback)
    @holder_count = bounded_integer(@params["holder_count"], default: 7, range: 1..99)
    @places = clean_places(@params["places"])
    @days_travelling = bounded_integer(@params["days"], default: 19, range: 0..9_999)
    @state = STATES.include?(@params["state"]) ? @params["state"] : "arrival"
    @viewer = VIEWERS.include?(@params["viewer"]) ? @params["viewer"] : "recipient"
    @price = clean_text(@params["price"], DEFAULT_PRICE, 12)
    @visual = catalog.resolve(template: @template, overrides: @params)
    @sealed_treatment = catalog.allowed("sealed_treatments", @params["sealed_treatment"], "veil")
  end

  def sender_preview?
    viewer == "sender"
  end

  def sender_discovery?
    viewer == "discoverer"
  end

  def public_waiting?
    viewer == "public_waiting"
  end

  def reveal_available?
    @reveal_available
  end

  def sender_frame_line
    I18n.t("sender.preview_frame", recipient: recipient_name)
  end

  def stage_label
    return I18n.t("public_gift.waiting_stage_label") if public_waiting?
    return I18n.t("sender.discovery_stage_label") if sender_discovery?
    return I18n.t("sender.preview_stage_label", recipient: recipient_name) if sender_preview?

    I18n.t("recipient.stage_label")
  end

  def sender_reflection_eyebrow
    I18n.t("sender.reflection_eyebrow")
  end

  def sender_reflection_line
    I18n.t("sender.reflection_line", recipient: recipient_name)
  end

  def sender_reflection_context
    I18n.t("sender.reflection_context", recipient: recipient_name)
  end

  def sender_commitment_line
    I18n.t("sender.commitment", recipient: recipient_name, price: price)
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
    return gift.display_serial_number if gift

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
    return I18n.t("public_gift.waiting_title") if public_waiting?
    return I18n.t("sender.discovery_arrival") if sender_discovery?

    if sender_name.present?
      I18n.t("recipient.arrival.named_sender", sender: sender_name)
    else
      I18n.t("recipient.arrival.anonymous_sender")
    end
  end

  def recipient_line
    return I18n.t("public_gift.waiting_eyebrow") if public_waiting?
    return I18n.t("sender.discovery_promise") if sender_discovery?
    return I18n.t("recipient.arrival.unnamed_recipient") unless @recipient_named

    I18n.t("recipient.arrival.named_recipient", recipient: recipient_name)
  end

  def arrival_context
    return I18n.t("public_gift.waiting_context") if public_waiting?
    return I18n.t("sender.discovery_context") if sender_discovery?

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
    return I18n.t("sender.discovery_origin") if sender_discovery?

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
      viewer:,
      price:,
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
    source = value.to_s.presence
    return [] if source.blank? && !@synthetic_journey

    source ||= DEFAULT_PLACES
    source.split(",").filter_map do |place|
      clean = place.strip.gsub(/\s+/, " ").truncate(40, omission: "…")
      clean if clean.present?
    end.first(6).presence || DEFAULT_PLACES.split(", ")
  end

  def clean_note(value, fallback)
    normalized = value.to_s.strip.gsub(/\r\n?/, "\n").gsub(/[^\S\n]+/, " ").gsub(/\n{3,}/, "\n\n")
    normalized = fallback if normalized.blank?
    normalized&.truncate(600, omission: "…")
  end

  def bounded_integer(value, default:, range:)
    Integer(value || default, exception: false).to_i.clamp(range)
  end

  def truthy?(value)
    # Coerce to a real boolean: cast returns nil for nil, which would render as an
    # empty attribute — and Stimulus reads an empty Boolean value as true.
    !!ActiveModel::Type::Boolean.new.cast(value)
  end
end
