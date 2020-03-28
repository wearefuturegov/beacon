# This migration comes from acts_as_taggable_on_engine (originally 2)
class AddMissingUniqueIndices < ActiveRecord::Migration[6.0]
  disable_ddl_transaction!

  def self.up
    add_index ActsAsTaggableOn.tags_table, :name, unique: true, algorithm: :concurrently

    remove_index ActsAsTaggableOn.taggings_table,
                 :tag_id if index_exists?(ActsAsTaggableOn.taggings_table, :tag_id)
    remove_index ActsAsTaggableOn.taggings_table, name: 'taggings_taggable_context_idx'
    add_index ActsAsTaggableOn.taggings_table,
              [:tag_id, :taggable_id, :taggable_type, :context, :tagger_id, :tagger_type],
              unique: true,
              name: 'taggings_idx',
              algorithm: :concurrently
  end

  def self.down
    remove_index ActsAsTaggableOn.tags_table, :name

    remove_index ActsAsTaggableOn.taggings_table, name: 'taggings_idx'

    add_index ActsAsTaggableOn.taggings_table,
              :tag_id,
              algorithm: :concurrently unless index_exists?(ActsAsTaggableOn.taggings_table, :tag_id)
    add_index ActsAsTaggableOn.taggings_table,
              [:taggable_id, :taggable_type, :context],
              name: 'taggings_taggable_context_idx',
              algorithm: :concurrently
  end
end
