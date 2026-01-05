class CreateIdentities < ActiveRecord::Migration[8.0]
  def change
    create_table :identities, id: :uuid do |t|
      t.string :email_address, null: false
      t.boolean :staff, default: false, null: false

      t.timestamps
    end

    add_index :identities, :email_address, unique: true
  end
end
