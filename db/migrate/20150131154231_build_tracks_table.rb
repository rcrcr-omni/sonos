class BuildTracksTable < ActiveRecord::Migration
  def change
  	create_table :tracks do |t|
      t.string :name
      t.string :artist
      t.string :album 
      t.string :uri
      t.integer :user_id
      t.integer :playlist_id

      t.timestamps
    end
  end
end
