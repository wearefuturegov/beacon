# This migration comes from acts_as_taggable_on_engine (originally 6)
class AddMissingIndexesOnTaggings < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def change
    add_index :taggings,
              :tag_id,
              algorithm: :concurrently unless index_exists? :taggings, :tag_id
    add_index :taggings,
              :taggable_id,
              algorithm: :concurrently unless index_exists? :taggings, :taggable_id
    add_index :taggings,
              :taggable_type,
              algorithm: :concurrently unless index_exists? :taggings, :taggable_type
    add_index :taggings,
              :tagger_id,
              algorithm: :concurrently unless index_exists? :taggings, :tagger_id
    add_index :taggings,
              :context,
              algorithm: :concurrently unless index_exists? :taggings, :context

    unless index_exists? :taggings, [:tagger_id, :tagger_type]
      add_index :taggings,
                [:tagger_id, :tagger_type],
                algorithm: :concurrently
    end

    unless index_exists? :taggings, [:taggable_id, :taggable_type, :tagger_id, :context], name: 'taggings_idy'
      safety_assured do
        add_index :taggings,
                  [:taggable_id, :taggable_type, :tagger_id, :context],
                  name: 'taggings_idy',
                  algorithm: :concurrently
      end
    end
  end
end
