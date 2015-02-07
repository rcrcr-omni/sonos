class RemoveIndexes < ActiveRecord::Migration
  def change
    remove_index :skips, [:skipper_id, :skipped_id]

    add_index :skips, :skipper_id
    add_index :skips, :skipped_id
    add_index :skips, [:skipper_id, :skipped_id]
  end
end
