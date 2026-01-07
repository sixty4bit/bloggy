class CreateArticles < ActiveRecord::Migration[8.0]
  def change
    create_table :articles, id: :uuid do |t|
      t.references :account, type: :uuid, null: false, foreign_key: true
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.string :title, null: false
      t.text :body, null: false
      t.boolean :published, default: false, null: false
      t.datetime :published_at

      t.timestamps
    end

    add_index :articles, [ :account_id, :published ]
    add_index :articles, [ :account_id, :created_at ]
  end
end
