class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users, id: :uuid do |t|
      t.references :account, type: :uuid, null: false, foreign_key: true
      t.references :identity, type: :uuid, foreign_key: true
      t.string :name, null: false
      t.string :role, null: false, default: "member"
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :users, [ :account_id, :identity_id ], unique: true
    add_index :users, [ :account_id, :role ]
  end
end
