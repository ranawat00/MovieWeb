class Api::V1::CommentsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create,:destroy,:update]
  class Api::V1::CommentsController < ApplicationController
    def index
      @comments = Comment.all
  
      if @comments.present?
        render json: @comments, status: :ok
      else
        render json: { message: ' comments not found' }, status: :not_found
      end
    end
  end
  

  def show
    @comment = Comment.find(params[:id])
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
      render json: {errors: @comment.errors.full_messages , message: 'comment not creaded'}, status: :unprocessable_entity
    end
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update(comment_params)
      render json: {comment:@comment, message:'comment successfully updated'}, status: :updated
    else
      render json: {errors: @comment.errors.full_messages , message: 'comment not updated'}, status: :unprocessable_entity
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy
      render json: { comment:@comment,message: 'comments successfully deleted' }, status: :ok
    else
      render json: {errors: @comment.errors.full_messages , message: 'comment not deleted'}, status: :unprocessable_entity
    end
  end



  private

  def comment_params
    params.permit(:user_id, :comment_title, :comment_body, :comment_movie_id)
  end

end
