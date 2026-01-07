require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:john)
    @article = articles(:first_post)
    sign_in_as(@user)
  end

  test "should get index" do
    get articles_url
    assert_response :success
  end

  test "should get new" do
    get new_article_url
    assert_response :success
  end

  test "should create article" do
    assert_difference("Article.count") do
      post articles_url, params: {
        article: { title: "New Article", body: "Article body content", published: false }
      }
    end

    assert_redirected_to article_url(Article.last)
  end

  test "should show article" do
    get article_url(@article)
    assert_response :success
  end

  test "should get edit" do
    get edit_article_url(@article)
    assert_response :success
  end

  test "should update article" do
    patch article_url(@article), params: {
      article: { title: "Updated Title" }
    }
    assert_redirected_to article_url(@article)
    @article.reload
    assert_equal "Updated Title", @article.title
  end

  test "should destroy article" do
    assert_difference("Article.count", -1) do
      delete article_url(@article)
    end

    assert_redirected_to articles_url
  end

  test "requires authentication" do
    cookies.delete(:session_token)
    get articles_url
    assert_redirected_to new_session_url
  end
end
