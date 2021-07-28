class ArticlesController < ApplicationController
  def index
    @articles = Article.all
    # @articles = Article.paginate(page: params[:page], per_page: 5)
  end

  def show
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
      @article.destroy
    end

    redirect_to root_path
  end

  def search
    query = params[:query]

    if query
      @articles = Article.search(query)
      @articles.each do |article|
        article.user = User.find(article.user_id)
      end
    end
  end

  private
  def article_params
    params.require(:article).permit(:title, :body)
  end
end
