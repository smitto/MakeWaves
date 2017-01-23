# The User class representing listeners and inherited by Artists and Charities.
#
# @attr [int] id the id of the user
# @attr [String] userName the user's displayed name
# @attr [String] email the user's registered email address
# @attr [File] photo the user's account photo
# @attr [String] decription the user's description paragraph
# @attr [List] followingList the list of user ID's this user is following
# @attr [List] followerList the list of user ID's following this user
# @attr [List] causeList the list of cause ID's this user is following
# @attr [List] playlistList the list of playlist IDs this user has created
# @attr [List] recentlyPlayed a queue of the 10 songs most recently played by this user
class User < ActiveRecord::Base
  # Make sure to serialize song_history which is an array
  serialize :song_history, Array

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  after_create :create_favorites
  has_many :songs
  has_many :playlists
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  has_attached_file :thumbnail,
    :styles => { :large => "1000x1000#", :medium => "550x550#" },
    :default_url => "default_image.jpg"
  validates_attachment_content_type :thumbnail, :content_type => /\Aimage\/.*\Z/

  # Default roles available.
  # Let the first declared role be the default.
  #enum role: [:listener, :charity, :artist]

  # Follows a user.
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Unfollows a user.
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end

  # Returns a user's status feed.
  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Song.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end

  def self.search(query)
    where("title like ?", "%#{query}%")
  end

  def user_thumbnail(user)
    if user.thumbnail.present?
      image_tag(user.thumbnail, border: 0)
    else
      image_tag('assets/images/default_image.jpg', border: 0)
    end
  end



private

  def create_favorites
    @user = self
    playlist = Playlist.create(:title => "Favorites", :user_id => @user.id, :favorite => true)
  end

end
