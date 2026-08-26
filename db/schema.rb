# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_08_26_130000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "gift_templates", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "background_key"
    t.text "context_text"
    t.datetime "created_at", null: false
    t.bigint "design_seed"
    t.string "finish"
    t.text "main_text", null: false
    t.text "ritual_text"
    t.string "source_key", null: false
    t.string "theme", null: false
    t.datetime "updated_at", null: false
    t.string "visual_family"
    t.index ["source_key"], name: "index_gift_templates_on_source_key", unique: true
    t.check_constraint "theme::text = ANY (ARRAY['courage'::character varying, 'calm'::character varying, 'momentum'::character varying, 'connection'::character varying, 'luck'::character varying, 'wonder'::character varying, 'strange'::character varying]::text[])", name: "gift_templates_theme_check"
  end

  create_table "gifts", force: :cascade do |t|
    t.datetime "activated_at"
    t.datetime "created_at", null: false
    t.string "creator_manage_token_digest"
    t.string "current_holder_token_digest"
    t.datetime "discovered_at", null: false
    t.bigint "gift_template_id", null: false
    t.integer "holder_generation", default: 0, null: false
    t.datetime "opened_by_recipient_at"
    t.string "origin_name"
    t.string "public_slug", null: false
    t.bigint "render_seed", null: false
    t.bigserial "serial_number", null: false
    t.string "state", default: "discovered", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_manage_token_digest"], name: "index_gifts_on_creator_manage_token_digest", unique: true
    t.index ["current_holder_token_digest"], name: "index_gifts_on_current_holder_token_digest", unique: true
    t.index ["gift_template_id"], name: "index_gifts_on_gift_template_id"
    t.index ["public_slug"], name: "index_gifts_on_public_slug", unique: true
    t.index ["serial_number"], name: "index_gifts_on_serial_number", unique: true
    t.check_constraint "holder_generation >= 0", name: "gifts_holder_generation_check"
    t.check_constraint "state::text = ANY (ARRAY['discovered'::character varying, 'waiting_for_claim'::character varying, 'held'::character varying]::text[])", name: "gifts_state_check"
  end

  create_table "journey_stops", force: :cascade do |t|
    t.boolean "anonymous", default: true, null: false
    t.datetime "arrived_at", null: false
    t.string "city"
    t.string "country_code"
    t.datetime "created_at", null: false
    t.datetime "departed_at"
    t.string "display_name"
    t.bigint "gift_id", null: false
    t.integer "sequence", null: false
    t.bigint "transfer_id"
    t.datetime "updated_at", null: false
    t.index ["gift_id", "sequence"], name: "index_journey_stops_on_gift_id_and_sequence", unique: true
    t.index ["gift_id"], name: "index_journey_stops_on_gift_id"
    t.index ["transfer_id"], name: "index_journey_stops_on_transfer_id", unique: true, where: "(transfer_id IS NOT NULL)"
    t.check_constraint "sequence > 0", name: "journey_stops_sequence_check"
  end

  create_table "transfers", force: :cascade do |t|
    t.datetime "cancelled_at"
    t.string "claim_token_digest", null: false
    t.datetime "claimed_at"
    t.datetime "created_at", null: false
    t.bigint "gift_id", null: false
    t.string "intended_recipient_name"
    t.text "private_note"
    t.string "sender_display_name"
    t.integer "source_holder_generation", default: 0, null: false
    t.string "state", default: "pending", null: false
    t.datetime "updated_at", null: false
    t.index ["claim_token_digest"], name: "index_transfers_on_claim_token_digest", unique: true
    t.index ["gift_id"], name: "index_transfers_on_gift_id"
    t.index ["gift_id"], name: "index_transfers_on_one_pending_per_gift", unique: true, where: "((state)::text = 'pending'::text)"
    t.check_constraint "source_holder_generation >= 0", name: "transfers_source_holder_generation_check"
    t.check_constraint "state::text = ANY (ARRAY['pending'::character varying, 'claimed'::character varying, 'cancelled'::character varying]::text[])", name: "transfers_state_check"
  end

  add_foreign_key "gifts", "gift_templates"
  add_foreign_key "journey_stops", "gifts"
  add_foreign_key "journey_stops", "transfers"
  add_foreign_key "transfers", "gifts"
end
