class AddPauseAndPlayCountToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :play_count, :integer, :default => 0
  	add_column :users, :pause_count, :integer, :default => 0
  end
end
