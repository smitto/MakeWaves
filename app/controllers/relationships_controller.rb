# Controller for creating and deleting following relationships between two users.
class RelationshipsController < ApplicationController

  # Creates a Relationship
  # @return [Relationship] the newly generated Relationship object
  def create
    user = User.find(params[:followed_id])
    current_user.follow(user)
    redirect_to user
  end

  # Deletes a Relationship
  def destroy
    user = Relationship.find(params[:id]).followed
    current_user.unfollow(user)
    redirect_to user
  end
end
