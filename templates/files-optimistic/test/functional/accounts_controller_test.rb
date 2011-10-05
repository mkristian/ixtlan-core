require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
  setup do
    @account = accounts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:accounts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create account" do
    assert_difference('Account.count') do
      post :create, :account => @account.attributes
    end

    assert_redirected_to account_path(assigns(:account))
  end

  test "should show account" do
    get :show, :id => @account.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @account.to_param
    assert_response :success
  end

  test "should update account" do
    put :update, :id => @account.to_param, :account => @account.attributes.merge({ 'updated_at' => '2011-07-11 13:21:15.000' })
    assert_redirected_to account_path(assigns(:account))
  end

  test "should destroy account" do
    assert_difference('Account.count', -1) do
      delete :destroy, :id => @account.to_param, :account => { 'updated_at' => '2011-07-11 13:21:15.000' }
    end

    assert_redirected_to accounts_path
  end
end
