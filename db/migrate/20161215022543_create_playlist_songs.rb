class CreatePlaylistSongs < ActiveRecord::Migration
  def change
    create_table :playlist_songs do |t|
      t.references :playlist, index: true
      t.references :song, index: true

      t.timestamps null: false
    end
    add_foreign_key :playlist_songs, :playlists
    add_foreign_key :playlist_songs, :songs
  end
end
