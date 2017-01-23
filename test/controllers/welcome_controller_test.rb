require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase#ActionDispatch::IntegrationTest #ActionController::TestCase
  test "should get index" do
#    get welcome_index_url 
 #   assert_response :success
    get :index
    assert_response :success
  end 
end
