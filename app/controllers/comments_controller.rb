class CommentsController < ApplicationController

  # Removed http_basic_authenticate_with since no authentication is required to create a comment as per the requirement

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
end
