class CreateAccountlessGiftDomain < ActiveRecord::Migration[8.1]
  def change
    create_table :gift_templates do |t|
      t.string :source_key, null: false
      t.string :theme, null: false
      t.text :main_text, null: false
      t.text :context_text
      t.text :ritual_text
      t.string :visual_family
      t.string :finish
      t.string :background_key
      t.bigint :design_seed
      t.boolean :active, null: false, default: true
      t.timestamps
    end

    add_index :gift_templates, :source_key, unique: true
    add_check_constraint :gift_templates,
      "theme IN ('courage', 'calm', 'momentum', 'connection', 'luck', 'wonder', 'strange')",
      name: "gift_templates_theme_check"

    create_table :gifts do |t|
      t.references :gift_template, null: false, foreign_key: true
      t.bigserial :serial_number, null: false
      t.string :public_slug, null: false
      t.string :state, null: false, default: "discovered"
      t.bigint :render_seed, null: false
      t.string :origin_name
      t.string :creator_manage_token_digest
      t.string :current_holder_token_digest
      t.integer :holder_generation, null: false, default: 0
      t.datetime :discovered_at, null: false
      t.datetime :activated_at
      t.datetime :opened_by_recipient_at
      t.timestamps
    end

    add_index :gifts, :serial_number, unique: true
    add_index :gifts, :public_slug, unique: true
    add_index :gifts, :creator_manage_token_digest, unique: true
    add_index :gifts, :current_holder_token_digest, unique: true
    add_check_constraint :gifts,
      "state IN ('discovered', 'waiting_for_claim', 'held')",
      name: "gifts_state_check"
    add_check_constraint :gifts,
      "holder_generation >= 0",
      name: "gifts_holder_generation_check"

    create_table :transfers do |t|
      t.references :gift, null: false, foreign_key: true
      t.string :claim_token_digest, null: false
      t.string :state, null: false, default: "pending"
      t.string :sender_display_name
      t.string :intended_recipient_name
      t.text :private_note
      t.integer :source_holder_generation, null: false, default: 0
      t.datetime :claimed_at
      t.datetime :cancelled_at
      t.timestamps
    end

    add_index :transfers, :claim_token_digest, unique: true
    add_index :transfers, :gift_id,
      unique: true,
      where: "state = 'pending'",
      name: "index_transfers_on_one_pending_per_gift"
    add_check_constraint :transfers,
      "state IN ('pending', 'claimed', 'cancelled')",
      name: "transfers_state_check"
    add_check_constraint :transfers,
      "source_holder_generation >= 0",
      name: "transfers_source_holder_generation_check"

    create_table :journey_stops do |t|
      t.references :gift, null: false, foreign_key: true
      t.references :transfer, foreign_key: true, index: false
      t.integer :sequence, null: false
      t.boolean :anonymous, null: false, default: true
      t.string :display_name
      t.string :city
      t.string :country_code
      t.datetime :arrived_at, null: false
      t.datetime :departed_at
      t.timestamps
    end

    add_index :journey_stops, [ :gift_id, :sequence ], unique: true
    add_index :journey_stops, :transfer_id,
      unique: true,
      where: "transfer_id IS NOT NULL"
    add_check_constraint :journey_stops,
      "sequence > 0",
      name: "journey_stops_sequence_check"
  end
end
