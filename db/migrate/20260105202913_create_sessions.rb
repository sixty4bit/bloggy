class CreateSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :sessions, id: :uuid do |t|
      t.references :identity, type: :uuid, null: false, foreign_key: true
      t.string :ip_address
      t.string :user_agent, limit: 500

      t.timestamps
    end
  end
end
