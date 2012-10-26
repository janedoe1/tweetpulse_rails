require 'test_helper'

class HashtagTermsControllerTest < ActionController::TestCase
  setup do
    @hashtag_term = hashtag_terms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:hashtag_terms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create hashtag_term" do
    assert_difference('HashtagTerm.count') do
      post :create, hashtag_term: {  }
    end

    assert_redirected_to hashtag_term_path(assigns(:hashtag_term))
  end

  test "should show hashtag_term" do
    get :show, id: @hashtag_term
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @hashtag_term
    assert_response :success
  end

  test "should update hashtag_term" do
    put :update, id: @hashtag_term, hashtag_term: {  }
    assert_redirected_to hashtag_term_path(assigns(:hashtag_term))
  end

  test "should destroy hashtag_term" do
    assert_difference('HashtagTerm.count', -1) do
      delete :destroy, id: @hashtag_term
    end

    assert_redirected_to hashtag_terms_path
  end
end
