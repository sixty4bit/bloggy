require "test_helper"

class ArticleTest < ActiveSupport::TestCase
  test "requires title" do
    article = Article.new(body: "Test body", account: accounts(:acme), user: users(:john))
    assert_not article.valid?
    assert_includes article.errors[:title], "can't be blank"
  end

  test "requires body" do
    article = Article.new(title: "Test Title", account: accounts(:acme), user: users(:john))
    assert_not article.valid?
    assert_includes article.errors[:body], "can't be blank"
  end

  test "published scope returns published articles" do
    assert_includes Article.published, articles(:first_post)
    assert_not_includes Article.published, articles(:draft_post)
  end

  test "drafts scope returns unpublished articles" do
    assert_includes Article.drafts, articles(:draft_post)
    assert_not_includes Article.drafts, articles(:first_post)
  end

  test "publish! sets published to true and published_at" do
    article = articles(:draft_post)
    assert_not article.published?

    article.publish!

    assert article.published?
    assert_not_nil article.published_at
  end

  test "unpublish! sets published to false and clears published_at" do
    article = articles(:first_post)
    assert article.published?

    article.unpublish!

    assert_not article.published?
    assert_nil article.published_at
  end
end
