class AddAttachmentThumbnailToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.attachment :thumbnail
    end
  end

  def self.down
    remove_attachment :users, :thumbnail
  end
end
