require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)

    assert_equal "DENY", response.headers["X-FRAME-OPTIONS"]
  end

  test "should get new" do
    UsersController.class_eval do
      cache_headers :my, false
      def my
        only_browser_can_cache(true)
      end
      def current_user
        Object.new
      end
    end
    get :new
    assert_response :success
    assert_not_nil response.headers["Expires"]
    assert_equal "private, max-age=0, no-store", response.headers["Cache-Control"]
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, :user => @user.attributes
    end

    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    UsersController.class_eval do
      cache_headers :private, false
      def current_user
        Object.new
      end
    end

    get :show, :id => @user.to_param
    assert_response :success

    assert_not_nil response.headers["Pragma"]
    assert_not_nil response.headers["Expires"]
    assert_equal "no-cache, must-revalidate", response.headers["Cache-Control"]
  end

  test "should get edit" do
    UsersController.class_eval do
      cache_headers :protected
      def current_user
        nil
      end
    end
    get :edit, :id => @user.to_param
    assert_response :success
    assert_nil response.headers["Pragma"]
    assert_nil response.headers["Expires"]
  end

  test "should update user" do
    put :update, :id => @user.to_param, :user => @user.attributes
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, :id => @user.to_param
    end

    assert_redirected_to users_path
  end
end
