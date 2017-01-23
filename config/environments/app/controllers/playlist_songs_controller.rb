class PlaylistSongsController < ApplicationController

  # Lists the Playlist Songs for the current user's Playlists
  def index
    @currentuser = current_user
    @playlist = Playlist.find(params[:playlist_id])
    redirect_to user_playlist_path(@currentuser, @playlist)
  end

  # Makes new Playlist Song without saving
  def new
    @currentuser = current_user
    @playlists = @currentuser.playlists
    @song = Song.find(params[:song_id])
    render :new
  end

  # Creates a Playlist Song to the appropriate Playlist.
  # Checks if it is adding to a Favorites playlist and increases the Song likes field
  def create
    @currentuser = current_user
    song = Song.find(params[:song_id])
    playlist = Playlist.find(params[:playlist_id])
    @song = song
    @favorite_playlist = @currentuser.playlists.where(favorite: true).first
    unless @currentuser.playlists.empty? || PlaylistSong.exists?(playlist_id: playlist.id, song_id: song.id)
      playlist_song = PlaylistSong.new(playlist_id: playlist.id, song_id: song.id)
      if playlist.favorite?
        song.num_favorites = song.num_favorites + 1
        song.save
      end
      playlist_song.save
    end
    redirect_to :back
  end

  # Deletes a Playlist Song from the appropriate Playlist.
  # Checks if it is deleting from a Favorites playlist and decreases the Song likes field
  def destroy
    @currentuser = current_user
    song = Song.find(params[:song_id])
    playlist = Playlist.find(params[:playlist_id])
    @favorite_playlist = @currentuser.playlists.where(favorite: true).first
    if PlaylistSong.exists?(playlist_id: playlist.id, song_id: song.id)
      playlist_song = PlaylistSong.where(playlist_id: playlist.id).where(song_id: song.id).first
      if playlist.favorite?
        song.num_favorites = song.num_favorites - 1
        song.save
      end
      playlist_song.destroy
    end
    redirect_to :back
  end

end
