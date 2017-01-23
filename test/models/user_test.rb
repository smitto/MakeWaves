require 'test_helper'

class UserTest < ActionDispatch::IntegrationTest#ActiveSupport::TestCase

  test 'valid user' do
    user = User.new(role: 'User', email: 'test@email.com', password: 'password')
    assert user.valid?
  end 

  test 'user invalid without email' do
    user = User.new(role: 'User', password: 'password')
    refute user.valid?, 'user is invalid without an email'
    assert_not_nil user.errors[:email]
  end

  test 'invalid without password' do
    user = User.new(role: 'User', email: 'test@email.com')
    refute user.valid?, 'user is valid without a passowrd'
    assert_not_nil user.errors[:name], 'no validation error for password present'
  end

  test "artist successfully signs up" do
    @rkelly = users(:rkelly)
    # post user_registration_path, 'users[role]' => "User", 'users[email]' => "test@email.com", 'users[title]' => 'Artist' ,'users[password]' =>  @rkelly.encrypted_password, 'users[password_confirmation]' =>  @rkelly.encrypted_password, 'users[thumbnail]' => '', 'users[description]' => ''
    post user_registration_path,
      { user: {
                  role: "User",
                  email: "test@email.com",
                  title: "Artist",
                  password: "password",
                  password_confirmation: "password",
                  thumbnail: "",
                  description: ""
        }
      } 
    get authenticated_root_path
    assert_equal 200, status
    assert_equal "/", path
  end

  # Feature does not exist yet
  # test "can change account info" do
  #   @rkelly = users(:rkelly)
  #   # post user_registration_path, 'users[role]' => "User", 'users[email]' => "test@email.com", 'users[title]' => 'Artist' ,'users[password]' =>  @rkelly.encrypted_password, 'users[password_confirmation]' =>  @rkelly.encrypted_password, 'users[thumbnail]' => '', 'users[description]' => ''
  #   post user_registration_path,
  #     { user: {
  #                 role: "User",
  #                 email: "test@email.com",
  #                 title: "Artist",
  #                 password: "password",
  #                 password_confirmation: "password",
  #                 thumbnail: "",
  #                 description: ""
  #       }
  #     } 

  #   put edit_user_registration_path,
  #     { user: {
  #                 role: "User",
  #                 email: "test@email.com",
  #                 title: "Artist",
  #                 password: "password",
  #                 password_confirmation: "password",
  #                 thumbnail: "",
  #                 description: ""
  #       }
  #     } 
  #   get authenticated_root_path
  #   assert_equal 200, status
  #   assert_equal "/", path
  # end


  test "can follow other user" do
    @rkelly = users(:rkelly)
    @follow = users(:rkell)

    @rkelly.follow(@follow)
    assert @rkelly.following?(@follow)    
  end

  test "can unfollow user" do
    @rkelly = users(:rkelly)
    @follow = users(:rkell)

    @rkelly.follow(@follow)
    assert @rkelly.following?(@follow)

    @rkelly.unfollow(@follow)
    assert_not @rkelly.following?(@follow)
  end

  test "can search" do
    assert_equal(2, User.search("Kelly").length)
  end

  test "search is empty when no user" do
    assert_equal(0, User.search("Kelasdfafdly").length)
  end

end
