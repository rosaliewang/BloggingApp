class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.text :title
      t.text :content
      t.references :user, index: true

      t.timestamps
    end
    add_index :articles, [:user_id, :created_at, :updated_at]
  end
end
