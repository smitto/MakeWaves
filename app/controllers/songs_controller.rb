# Controller for creating, deleting, and displaying songs.
class SongsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  # before_filter :require_permission
  before_action :find_user
  before_action :find_song, only: [:show, :edit, :update, :destroy]

  # Generates a new song object
  # @return [Song] the new song object
  def new
    @song = @user.songs.new
    render :partial=>'new'
  end

  # Creates a new song and adds it to the recommendation matrix
  # @return [Song] the newly created song
  def create
    @song = @user.songs.new song_params
    if @song.save
      # Record song's preoprties to predictor
      recommender = SongRecommender.new
      recommender.add_to_matrix!(:topics, @song.genre_tag, @song.id)

      redirect_to user_path(@user)
    else
      redirect_to user_path(@user)
    end
  end

  # Retrieves Songs for Display On Dashboard
  # @return [List] the list of songs to be displayed in the given user's dashboard
  def dashboard
    @songs = Song.where(user_id: @user).order("created_at DESC").limit(6).reject { |s| s.id == @song.id}
  end

	# Retrieves Songs for Display In User Playlists and Tags
  # @return [List] the list of songs to be displayed on the given user's profile
  def show
    @songs = Song.where(user_id: @user).order("created_at DESC").limit(6).reject { |s| s.id == @song.id}
  end

  # Edits Song attributes
  def edit
  end

  # Updates Song attributes
  # @return [Song] the updated song with edited attributes (not implemented)
  def update
    if @song.update song_params
      redirect_to user_song_path(@user, @song), notice: "Song was successfully updated!"
    else
      render 'edit'
    end
  end

  # Deletes the song object
  def destroy
    @song.destroy
    redirect_to root_path
  end

  private

  # Permits specified parameters through form
  def song_params
    params.require(:song).permit(:title, :song_thumbnail_file_name, :song_thumbnail_file_size, :song_thumbnail_content_type, :song_thumbnail_updated_at, :mp3, :genre_tag, :charity_tag, :artist)
  end

  # Finds the User from the User Show path
  # @return [User] the user with the current id to show
  def find_user
    @user = User.find(params[:user_id])
  end

  # Finds the Song from the Song Show path
  # @return [Song] the song with the intended id
  def find_song
    @song = Song.find(params[:id])
  end

end
