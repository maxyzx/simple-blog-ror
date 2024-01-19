class ArticlesController < ApplicationController

  http_basic_authenticate_with name: "yash", password: "yash", except: [:index, :show]

  def index
    @articles = Article.all
  end

  def show
    begin
      @article = Article.find(params[:id])
      render json: { status: 200, article: @article }, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { status: 404, error: "Article with the specified ID was not found." }, status: :not_found
    rescue ActiveRecord::StatementInvalid
      render json: { status: 400, error: "Article ID must be a valid integer." }, status: :bad_request
    end
  end

  def new
    @article = Article.new
  end

  def edit
    @article = Article.find(params[:id])
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to @article
    else
      render 'new'
    end
  end

  def update
    @article = Article.find(params[:id])

    if @article.update(article_params)
      redirect_to @article
    else
      render 'edit'
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to articles_path
  end

  private
    def article_params
      params.require(:article).permit(:title, :text)
    end
end
