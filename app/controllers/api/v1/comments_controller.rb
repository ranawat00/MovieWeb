class Api::V1::CommentsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create,:destroy,:update]

  def index
    @comments = Comment.all

    if @comments.present?
      render json: @comments, status: :ok
    else
      render json: { message: ' comments not found' }, status: :not_found
    end
  end


  def show
    @comment = Comment.find_by(id:params[:id])
    if @comment.present?
    render json: @comment, status: :ok
    else
      render json: { error: 'Comment not found' }, status: :not_found
    end
  end

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      render json: {comment:@comment, message:'comment successfully created'}, status: :created
    else
      render json: {errors: @comment.errors.full_messages , message: 'comment not created'}, status: :unprocessable_entity
    end
  end

  def update 
    @comment = Comment.find_by(id: params[:id])
    if @comment
      if @comment.update(comment_params)
        render json: { comment: @comment, message: 'comment successfully updated' }, status: :ok
      else
        render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: 'comment not found' }, status: :not_found
    end
  end
  

  def destroy
    @comment = Comment.find_by(id: params[:id])
    if @comment
      if @comment.destroy
        render json: { message: 'comment successfully deleted' }, status: :ok
      else 
        render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: "comment not found" }, status: :not_found
    end
  end
  



  private

  def comment_params
    params.require(:comment).permit(:user_id, :comment_title, :comment_body, :comment_movie_id)
  end
end
