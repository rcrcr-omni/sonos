class AddSpotifyIdToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :spotify_id, :string
  end
end
