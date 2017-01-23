# The User class, with role specifying Listeners, Artists, and Charities.
#
# @attr [int] id the id of the user
# @attr [String] title the user's displayed name
# @attr [String] email the user's registered email address
# @attr [String] decription the user's description paragraph (only set for charities)
# @attr [List] song_history the history of song IDs this user has listened to, for predictions
# @attr [List] songs the list of songs belonging to this user
# @attr [List] following the list of user ID's this user is following
# @attr [List] followers the list of user ID's following this user
# @attr [File] thumbnail the user's account thumbnail photo

class User < ActiveRecord::Base
  # Make sure to serialize song_history which is an array
  # @attr [List] song_history the history of song IDs this user has listened to, for predictions
  serialize :song_history, Array

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable


  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  after_create :create_favorites

  # @attr [List] songs the list of songs belonging to this user
  has_many :songs

  # @attr [List]
  has_many :playlists
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy


  # @attr [List] following the list of user ID's this user is following
  has_many :following, through: :active_relationships, source: :followed
  # @attr [List] followers the list of user ID's following this user
  has_many :followers, through: :passive_relationships, source: :follower

  # @attr [File] thumbnail the user's account thumbnail photo
  has_attached_file :thumbnail,
    :styles => { :large => "1000x1000#", :medium => "550x550#" },
    :default_url => "default_image.jpg"
  validates_attachment_content_type :thumbnail, :content_type => /\Aimage\/.*\Z/


  # Sets the current user to follow another user, receiving their song uploads on their feed.
  # @param other_user [User] the user to be followed
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Unfollows a given user, removing them from the sidebar and no longer receiving their feed.
  # @param other_user [User] the user to be unfollowed
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user.
  # @param other_user [User] the user to check if we are following
  # @return [boolean] whether the given user is being followed
  def following?(other_user)
    following.include?(other_user)
  end

  # Returns the user's status feed, all songs uploaded by other users they follow.
  # @return [List]
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Song.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end

  # Searches for users with a name similar to the entered query
  # @param query [String] the entered user search
  # @return [List] the list of users with titles similar to the query
  def self.search(query)
    where("title like ?", "%#{query}%")
  end

  # Retrieves the thumbnail of the user, with a default if the user doesn't have a thumbnail file.
  # @param user [User] the user we're retrieving the thumbnail for
  # @return [File] the thumbnail of the requested user
  def user_thumbnail(user)
    if user.thumbnail.present?
      image_tag(user.thumbnail, border: 0)
    else
      image_tag('assets/images/default_image.jpg', border: 0)
    end
  end



private

  # Automatically generates a favorites playlist when the user signs up.
  # @return [Playlist] the generated favorites playlist
  def create_favorites
    @user = self
    playlist = Playlist.create(:title => "Favorites", :user_id => @user.id, :favorite => true)
  end

end
