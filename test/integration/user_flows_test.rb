require 'test_helper'


class UserFlowsTest < ActionDispatch::IntegrationTest

  test "successful login of confirmed user" do
      post user_session_path, 'user[email]' => "rkelly@bounce.com", 'user[password]' =>  "password"
      assert_redirected_to "/"
  end

  test "user redirected to home page if not logged in" do
    get user_session_path
    assert_redirected_to root_url
  end

  test "redirected if user logs in with incorrect info" do
    post user_session_path, 'user[email]' => "rkelly@bounce.com", 'user[password]' =>  "wrongpassword"
    assert path ==  user_session_path
  end

end