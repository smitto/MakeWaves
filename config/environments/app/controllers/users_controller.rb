# The User controller, serving as intermediary between the User model and view.
class UsersController < ApplicationController
	before_filter :authenticate_user!
	protect_from_forgery except: :shownum


  # require './lib/song_recommender.rb'

	# Displays the user's home page as described in the index.html.erb user view.
	def index
		@currentuser = current_user
		if params[:search]
	    @search_users = User.search(params[:search]).order("created_at DESC")
	  else
	    @search_users = User.all.order('created_at DESC')
	  end
	end

	# Displays the selected user's show page
	def show
		@currentuser = current_user
		@user = User.find(params[:id])
    @songs = Song.where(:user_id=>@user.id).order("created_at DESC")
		@song = @user.songs.new
		@playlists = Playlist.where(:user_id=>@user.id).order("created_at DESC")
		@current_user_playlists = Playlist.where(:user_id=>@currentuser.id).order("created_at DESC")
		@playlist = @user.playlists.new
		@favorite_playlist = @currentuser.playlists.where(favorite: true).first
	end

	# Displays the current user's dashboard
	# Retrieve user playlist information for dropdowns
	def dashboard
		@currentuser = current_user
    # Get songs that are similar to ones the user has already listened to
		recommender = SongRecommender.new
		predictions = recommender.predictions_for(item_set: @currentuser.song_history)
		@predicted_songs = []
		for p in predictions
			@predicted_songs.append(Song.find(p))
		end
		@songs = Song.where(:user_id=>@currentuser.id)
		@song = @currentuser.songs.new
		@playlists = Playlist.where(:user_id=>@currentuser.id).order("created_at DESC")
		@current_user_playlists = Playlist.where(:user_id=>@currentuser.id).order("created_at DESC")
		@playlist = @currentuser.playlists.new
		@favorite_playlist = @currentuser.playlists.where(favorite: true).first
	end

	# Appends current song to the user's Song History
  def add_to_history
    user_id = params[:user_id]
    song_id = params[:song_id].to_i
    user = User.find(user_id)
    user.song_history = user.song_history | [song_id]
    user.save
    result = 200

    respond_to do |format|
      format.json {render :json => {:result => result}}
    end
  end
  # helper_method :add_to_history

	private

	# Find song with given parameters
	def find_song
		@songs = Song.where(user_id: @user.id).order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
	end

	# Find user with given parameters
	def find_user
		if params[:id].nil?
			@user = current_user
		else
			@user = User.find(params[:id])
		end
	end

	# Retrieve all users the current user is following
	def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

	# Retrieve all users following the current user
  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

	# Display all users the current user is following
	def show_followers
		render :partial=>"layouts/cardcollection"
	end

	# Display all users following the current user
	def show_following
		render :partial=>"layouts/cardcollection"
	end

	# Retrieve all users with given parameters
	def search
		q = params[:user][:name]
		@users = User.find(:all, :conditions => ["name LIKE %?%", q])
	end

end
