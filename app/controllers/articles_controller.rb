require 'json'
class ArticlesController < ApplicationController
  include ArticlesHelper
  def index
    @articles = fetch_articles_redis
  end

  def show
    # get_article_from_redis(params[:id])
    @article = Article.find(params[:id])
  end

  def new
    if logged_in?
      @article = Article.new
    else
      render "sessions/new"
    end

  end

  def create
    @article = Article.new(article_params)
    if logged_in?
      @article.user = current_user
      if @article.save
        save_to_redis(@article)
        flash[:notice] = "Article was successfully created"
        redirect_to @article
      else
        render :new
      end
    else
      render "sessions/new"
    end

  end

  def edit
    if logged_in?
      @article = Article.find(params[:id])
    else
      render "sessions/new"
    end

  end

  def update
    @article = Article.find(params[:id])
    if logged_in? && @article.user.eql?(current_user)
      if(@article.update(article_params))
        save_to_redis(@article)
        redirect_to @article
      else
        render :edit
      end
    else
      if logged_in?
        redirect_to @article
      else
        render "session/new"
      end
    end
  end

  def destroy
    @article = Article.find(params[:id])
    if(logged_in? && @article.user.eql?(current_user) )
      delete_from_redis(params[:id])
      @article.destroy
    end
    redirect_to root_path
  end

  def search
    query = params[:query]

    if query
      @articles = JSON.parse(Article.search(query).to_json)
    end
    @articles = @articles.map{|article| article["_source"]}
  end

  private
  def article_params
    params.require(:article).permit(:title, :body)
  end
end
