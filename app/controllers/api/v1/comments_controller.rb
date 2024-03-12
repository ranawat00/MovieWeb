class Api::V1::CommentsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create,:destroy,:update]




  def index
    @comments = Comment.all
    render json: @comments, status: :ok
  end

  def show
    @comment = Comment.find(params[:id])
    if @comment
    render json: @comment, status: :ok
    else
      render json: { error: 'Comment not found' }, status: :not_found
    end
  end

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update(comment_params)
      render json: @comment, status: :ok
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy
      render json: { message: 'comments successfully deleted' }, status: :ok
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end



  private

  def comment_params
    params.permit(:user_id, :comment_title, :comment_body, :comment_movie_id)
  end

end
