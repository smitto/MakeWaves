require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  # test "the truth" do
  #   assert true
  # end

  test "dashboard should get redirected if not signed in" do
    get :dashboard
    assert_redirected_to "/users/sign_in"
  end

  test "index should get redirected if not signed in" do
    get :index
    assert_redirected_to "/users/sign_in"
  end

  test "show should get redirected if not signed in" do
    # Pass in dummy id
    get :show, id: ""
    assert_redirected_to "/users/sign_in"
  end

  # test "should go to dashboard if signed in" do
  #   sign_in users(:rkelly)
  #   get :dashboard
  #   assert_response :success
  # end

  test "index works if logged in" do
    sign_in users(:rkelly)
    get :index, :user=>users(:rkelly)
    assert_response :success
  end

  test "show works if logged in" do
    sign_in users(:rkelly)
    get :show, id: users(:rkelly).id
    assert_response :success
  end
end
