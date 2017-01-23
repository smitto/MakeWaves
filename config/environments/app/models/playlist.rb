class Playlist < ActiveRecord::Base
  belongs_to :user
  has_many :playlist_songs
  has_many :songs, through: :playlist_songs

  has_attached_file :thumbnail,
    :styles => { :large => "1000x1000#", :medium => "550x550#" },
    :default_url => "default_playlist_2.png"
  validates_attachment_content_type :thumbnail, :content_type => /\Aimage\/.*\Z/
end
