class DropTagsAndTaggings < ActiveRecord::Migration[6.0]
  def change
    drop_table :taggings
    drop_table :tags
  end
end
