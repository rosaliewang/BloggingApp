require 'test_helper'

class ArticleTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    @article = @user.articles.build(title: "This is title", content: "This is content",
                          user_id: @user.id)
  end

  test "should be valid" do
    assert @article.valid?
  end

  test "user id should be present" do
    @article.user_id = nil
    assert_not @article.valid?
  end

  test "title should be present" do
    @article.title = nil
    assert_not @article.valid?
  end

  test "title should not be empty" do
    @article.title = "      "
    assert_not @article.valid?
  end

  test "content should be present" do
    @article.title = "foo"
    @article.content = "     "
    assert_not @article.valid?
  end

  test "order should be most recent first" do
    assert_equal Article.first, articles(:most_recent)
  end









end
