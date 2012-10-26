require 'test_helper'

class KeywordTermsControllerTest < ActionController::TestCase
  setup do
    @keyword_term = keyword_terms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:keyword_terms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create keyword_term" do
    assert_difference('KeywordTerm.count') do
      post :create, keyword_term: {  }
    end

    assert_redirected_to keyword_term_path(assigns(:keyword_term))
  end

  test "should show keyword_term" do
    get :show, id: @keyword_term
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @keyword_term
    assert_response :success
  end

  test "should update keyword_term" do
    put :update, id: @keyword_term, keyword_term: {  }
    assert_redirected_to keyword_term_path(assigns(:keyword_term))
  end

  test "should destroy keyword_term" do
    assert_difference('KeywordTerm.count', -1) do
      delete :destroy, id: @keyword_term
    end

    assert_redirected_to keyword_terms_path
  end
end
