# The relationship model, holding a follower and followed User object.
# @attr [User] follower the user that is following in the relationship
# @attr [User] followed the user that being followed in the relationship

class Relationship < ActiveRecord::Base
  # @attr [User] follower the user that is following in the relationship
  belongs_to :follower, class_name: "User"
  # @attr [User] followed the user that being followed in the relationship
  belongs_to :followed, class_name: "User"
end
