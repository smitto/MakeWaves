# The playlist model, holding songs and a thumbnail.
# @attr [User] the user the playlist object belongs to
# @attr [List] playlist_songs the list of songs belonging to the playlist object
# @attr [File] thumbnail the attached photo for the playlist

class Playlist < ActiveRecord::Base
  # @attr [User] the user the playlist object belongs to
  belongs_to :user
  # @attr [List] playlist_songs the list of songs belonging to the playlist object
  has_many :playlist_songs
  has_many :songs, through: :playlist_songs

  # @attr [File] thumbnail the attached photo for the playlist
  has_attached_file :thumbnail,
    :styles => { :large => "1000x1000#", :medium => "550x550#" },
    :default_url => "default_playlist_2.png"
  validates_attachment_content_type :thumbnail, :content_type => /\Aimage\/.*\Z/
end
