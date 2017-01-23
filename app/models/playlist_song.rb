# An instance of a song in a playlist, specifying the song and playlist objects.
# @attr [Playlist] playlist the playlist belonging to the PlaylistSong object
# @attr [Song] song the song belonging to the PlaylistSong object

class PlaylistSong < ActiveRecord::Base
  # @attr [Playlist] playlist the playlist belonging to the PlaylistSong object
  belongs_to :playlist
  # @attr [Song] song the song belonging to the PlaylistSong object
  belongs_to :song
end
