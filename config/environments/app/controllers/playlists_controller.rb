class PlaylistsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :find_user
#  before_action :find_playlist, only: [:show, :edit, :update, :destroy]

  # Lists all Playlists for current user
  def index
    @user = current_user
    @songs = Song.where(:user_id=>@user.id).order("created_at DESC").paginate(:page => params[:page], :per_page => 5)
		@song = @user.songs.new
    @playlists = Playlist.where(:user_id=>@user.id).order("created_at DESC").paginate(:page => params[:page], :per_page => 5)
    @playlist = @user.playlists.new
  end

  # Makes a new playlist
  def new
    @user = current_user
    @playlist = @user.playlists.new
  end

  # Creates new Playlist for current user
  def create
    @user = current_user
    @playlist = @user.playlists.new playlist_params
    if @playlist.save
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end

  # Displays the view for the Playlist and its Playlist Songs
  def show
    @user = current_user
    @playlist = Playlist.find(params[:id])
    @playlists = Playlist.where(:user_id=>@user.id).order("created_at DESC").paginate(:page => params[:page], :per_page => 5)
    @songs = @playlist.songs
  end

  private

  # Permits the passing parameters to be title and thumbnail
  def playlist_params
    params.require(:playlist).permit(:title, :thumbnail)
  end

  # Finds the user from the path for the user show (in the URL)
  def find_user
    @user = User.find(params[:user_id])
  end

  # Finds the playlist from the path for the user show (in the URL)
  def find_playlist
    @playlist = Playlist.find(params[:id])
  end
end
