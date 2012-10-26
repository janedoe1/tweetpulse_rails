require 'test_helper'

class UserTermsControllerTest < ActionController::TestCase
  setup do
    @user_term = user_terms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_terms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_term" do
    assert_difference('UserTerm.count') do
      post :create, user_term: {  }
    end

    assert_redirected_to user_term_path(assigns(:user_term))
  end

  test "should show user_term" do
    get :show, id: @user_term
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_term
    assert_response :success
  end

  test "should update user_term" do
    put :update, id: @user_term, user_term: {  }
    assert_redirected_to user_term_path(assigns(:user_term))
  end

  test "should destroy user_term" do
    assert_difference('UserTerm.count', -1) do
      delete :destroy, id: @user_term
    end

    assert_redirected_to user_terms_path
  end
end
