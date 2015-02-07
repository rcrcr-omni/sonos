class BuildSkipTable < ActiveRecord::Migration
  def change
  	create_table :skips do |t|
      t.integer :skipper_id
      t.integer :skipped_id

      t.timestamps
    end
    add_index :skips, :skipper_id
    add_index :skips, :skipped_id
    add_index :skips, [:skipper_id, :skipped_id], unique: true
  end
end
