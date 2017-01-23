class Song < ActiveRecord::Base
  belongs_to :user
  has_many :playlist_songs
  has_many :playlists, through: :playlist_songs

  has_attached_file :song_thumbnail, :styles => { :large => "1000x1000#", :medium => "550x550#" }
  validates_attachment_content_type :song_thumbnail, :content_type => /\Aimage\/.*\Z/

  has_attached_file :mp3
  validates_attachment :mp3, :content_type => { :content_type => ["audio/mpeg", "audio/mp3", "audio/x-mpeg", "audio/x-mp3", "audio/mpeg3", "audio/x-mpeg3", "audio/mpg", "audio/x-mpg", "audio/x-mpegaudio"] }, :file_name => { :matches => [/mp3\Z/] }
end
