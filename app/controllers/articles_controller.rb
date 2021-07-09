class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    # session[:pageviews_remaining] ||= 3
    # puts session[:pageviews_remaining]
    # puts cookies
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    session[:pageviews_remaining] ||= 3
    if session[:pageviews_remaining] > 1
      session[:pageviews_remaining] -= 1
      article = Article.find(params[:id])
      render json: article
    else
      session[:pageviews_remaining] -= 1
      render json: { error: "Maximum pageview limit reached" }, status: :unauthorized
    end
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end
