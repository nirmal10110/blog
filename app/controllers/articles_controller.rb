require 'json'

class ArticlesController < ApplicationController
  include ArticlesHelper
  @@admin_access_email = ["admin@gmail.com"]
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
    @article = Article.find(params[:id])
    if logged_in? && (@article.user.eql?(current_user) || @@admin_access_email.include?(current_user.email.downcase) )
      @article = Article.find(params[:id])
    else
      flash[:danger] = "You cant update other's articles"
      redirect_to articles_path
    end
  end

  def update
    @article = Article.find(params[:id])
    if logged_in? && (@article.user.eql?(current_user) || @@admin_access_email.include?(current_user.email.downcase) )
      if(@article.update(article_params))
        save_to_redis(@article)
        redirect_to @article
      else
        flash[:danger] = "There was a problem while updating the Article Please retry"
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
    if logged_in? && (@article.user.eql?(current_user) ||@@admin_access_email.include?(current_user.email.downcase))
      delete_from_redis(params[:id])
      @article.destroy
    end
    flash[:danger] = "You cant delete other's articles"
    redirect_to articles_path
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
