class RemoveUniqueConstraintFromSkips < ActiveRecord::Migration
  def change
  	remove_index :skips, :skipper_id
  	remove_index :skips, :skipped_id
  end
end
