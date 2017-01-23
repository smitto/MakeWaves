# The song model, with a User, list of playlists, thumbnail, and mp3 file.
# @attr [User] user the user that the song belongs to
# @attr [List] the list of playlists the song belongs to
# @attr [File] thumbnail the song thumbnail
# @attr [File] mp3 the song's mp3 file

class Song < ActiveRecord::Base
  # @attr [User] user the user that the song belongs to
  belongs_to :user
  has_many :playlist_songs
  # @attr [List] the list of playlists the song belongs to
  has_many :playlists, through: :playlist_songs

  # @attr [File] thumbnail the song thumbnail
  has_attached_file :song_thumbnail, :styles => { :large => "1000x1000#", :medium => "550x550#" }
  validates_attachment_content_type :song_thumbnail, :content_type => /\Aimage\/.*\Z/

  # @attr [File] mp3 the song's mp3 file
  has_attached_file :mp3
  validates_attachment :mp3, :content_type => { :content_type => ["audio/mpeg", "audio/mp3", "audio/x-mpeg", "audio/x-mp3", "audio/mpeg3", "audio/x-mpeg3", "audio/mpg", "audio/x-mpg", "audio/x-mpegaudio"] }, :file_name => { :matches => [/mp3\Z/] }
end
