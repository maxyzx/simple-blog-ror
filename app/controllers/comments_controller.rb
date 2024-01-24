
class CommentsController < ApplicationController
  before_action :validate_email_format, only: [:create_request]

  def create
    begin
      @article = Article.find(params[:article_id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Article not found." }, status: :not_found
      return
    end

    @comment = @article.comments.new(comment_params)
    if @comment.save
      redirect_to article_path(@article), status: :found
    else
      render json: { errors: @comment.errors.full_messages }, status: :bad_request
    end
  end
  
  def create_request
    required_params = params.require(:request).permit(:area, :menu, :hair_concerns, :images, :email)
    user = User.email_exists?(required_params[:email])
    if user
      render json: { error: 'Account already exists.' }, status: :bad_request
      return
    end

    request = Request.new(required_params.except(:email))
    request.user = User.new(email: required_params[:email])
    if request.save
      token = request.user.authentication_token.create.token
      ApplicationMailer.send_account_creation_email(required_params[:email], token).deliver_now
      render json: { success: 'Request has been sent. Please check your email for the account creation link.' }, status: :created
    else
      render json: { errors: request.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
    @comment.destroy
    redirect_to article_path(@article)
  end

  private
    def comment_params
      params.require(:comment).permit(:commenter, :body)
    end

    def validate_email_format
      unless valid_email?(params[:request][:email])
        render json: { error: 'Invalid email format.' }, status: :bad_request
      end
    end

    def valid_email?(email)
      # Assuming the valid_email? method is implemented elsewhere, as it's not provided in the patch
      # This is a placeholder implementation
      email =~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    end
end
