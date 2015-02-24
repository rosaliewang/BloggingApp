class AddPublishToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :publish, :boolean, default: true
  end
end
