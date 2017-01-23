require 'test_helper'

class SongsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  # test "the truth" do
  #   assert true
  # end
  test "new should get redirected if not signed in" do
    get :new, :user_id=>1
    assert_redirected_to "/users/sign_in"
  end

  test "edit should get redirected if not signed in" do
    get :edit, :user_id=>1, :id=> 1
    assert_redirected_to "/users/sign_in"
  end

  # test "new should not get redirected if signed in" do
  #   sign_in users(:rkelly)
  #   get :show, :user_id=>users(:rkelly).id, :id=> songs(:ignition).id
  #   assert_response :success
  # end
end
