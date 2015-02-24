require 'test_helper'

class ArticlesControllerTest < ActionController::TestCase

  def setup
    @article = articles(:one)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Article.count' do
      post :create, article: { title: "aaa", content: "bbb"}
    end
    assert_redirected_to login_url
  end

  test "should redirect edit when not logged in" do
    get :edit, id: @article
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch :update, id: @article, article: { title: "bbb", content: "modify" }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Article.count' do
      delete :destroy, id: @article
    end
    assert_redirected_to login_url
  end

end
