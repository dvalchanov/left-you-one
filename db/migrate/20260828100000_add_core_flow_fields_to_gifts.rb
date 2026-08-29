class AddCoreFlowFieldsToGifts < ActiveRecord::Migration[8.1]
  def change
    add_column :gifts, :opened_by_creator_at, :datetime
    add_column :gifts, :visual_configuration, :jsonb, null: false, default: {}
    add_column :gifts, :creation_key_digest, :string

    add_index :gifts, :creation_key_digest, unique: true
  end
end
