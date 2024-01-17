
class ArticlesController < ApplicationController

  http_basic_authenticate_with name: "yash", password: "yash", except: [:index, :show]

  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
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

  def create_request
    # Step 1: Validate required fields
    required_params = params.require(:request).permit(:area, :gender, :date_of_birth, :display_name, :menu, :hair_concerns, images: [])
    validate_images(required_params[:images])

    # Step 2: Validate lengths
    validates_length_of :display_name, maximum: 20
    validates_length_of :hair_concerns, maximum: 2000

    # Step 3: Create the request
    new_request = Request.create!(required_params.merge(status: 'new'))

    # Step 4: Render the response
    render json: { request_id: new_request.id, status: 'created' }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  private

  def validate_images(images)
    # Custom validation logic for images
    # Check count, file format, and size
  end

  def article_params
    params.require(:article).permit(:title, :text)
  end
end
