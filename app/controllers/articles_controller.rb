class ArticlesController < ApplicationController
  before_action :require_account
  before_action :set_article, only: [ :show, :edit, :update, :destroy ]

  def index
    @articles = Current.account.articles.recent
  end

  def show
  end

  def new
    @article = Current.account.articles.build
  end

  def create
    @article = Current.account.articles.build(article_params)
    @article.user = Current.user

    if @article.save
      redirect_to @article, notice: "Article was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @article.update(article_params)
      redirect_to @article, notice: "Article was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path, notice: "Article was successfully deleted."
  end

  private

  def set_article
    @article = Current.account.articles.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :body, :published)
  end
end
