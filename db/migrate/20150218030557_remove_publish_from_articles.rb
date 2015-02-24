class RemovePublishFromArticles < ActiveRecord::Migration
  def change
    remove_column :articles, :publish, :boolean
  end
end
