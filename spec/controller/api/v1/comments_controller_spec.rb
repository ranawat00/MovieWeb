require 'rails_helper'
require 'faker'

RSpec.describe Api::V1::CommentsController, type: :controller do
  describe 'GET #index' do
    context 'when comments are present' do
      let!(:user1) { User.create(firstname: 'gaurav', lastname: 'ranawat', username: Faker::Name.name, email: Faker::Internet.email, password: 'Gaurav123') }
      let!(:user2) { User.create(firstname: 'akshay', lastname: 'kumar', username: Faker::Name.name, email: Faker::Internet.email, password: 'akshay123') }
      let!(:comment1) { Comment.create(user_id: user1.id, comment_title: 'frontend developer', comment_body: 'Html css js react js', comment_movie_id: 3) }
      let!(:comment2) { Comment.create(user_id: user2.id, comment_title: 'backend developer', comment_body: 'java python ruby rails Sql', comment_movie_id: 5) }

      it 'returns http success' do
        get :index
        expect(response).to have_http_status(:ok)
      end

      it 'returns all comments as JSON' do
        get :index
        expect(response).to have_http_status(:ok)

        comments_response = JSON.parse(response.body)
        expect(comments_response.count).to eq(2)
        expect(comments_response[0]['comment_title']).to eq(comment1.comment_title)
        expect(comments_response[1]['comment_title']).to eq(comment2.comment_title)
      end
    end

    context 'when no comments are present' do
      it 'returns http not found' do
        get :index
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an empty list of comments as JSON' do
        get :index
        expect(response).to have_http_status(:not_found)

        comments_response = JSON.parse(response.body)
        expect(comments_response).to eq({ "message" => " comments not found" })
      end
    end
  end


  describe 'GET #show' do
    context 'when comment is present' do
      let!(:user1) { User.create(firstname: 'gaurav', lastname: 'ranawat', username: Faker::Name.name, email: Faker::Internet.email, password: 'Gaurav123') }
      let!(:user2) { User.create(firstname: 'akshay', lastname: 'kumar', username: Faker::Name.name, email: Faker::Internet.email, password: 'akshay123') }
      let!(:comment1) { Comment.create(user_id: user1.id, comment_title: 'frontend developer', comment_body: 'Html css js react js', comment_movie_id: 3) }
      let!(:comment2) { Comment.create(user_id: user2.id, comment_title: 'backend developer', comment_body: 'java python ruby rails Sql', comment_movie_id: 5) }
      it 'returns https successful' do
        get :show, params: { id: comment1.id }
        expect(response).to have_http_status(:ok)
      end
      it'returns the comment as JSON' do
        get :show, params: { id: comment1.id }
        expect(response).to have_http_status(:ok)

        comment_response = JSON.parse(response.body)
        expect(comment_response['comment_title']).to eq(comment1.comment_title)
        expect(comment_response['comment_body']).to eq(comment1.comment_body)
        expect(comment_response['comment_movie_id']).to eq(comment1.comment_movie_id)
      end
    end
 


    context 'when the comment is not dound' do
      it 'returns http not found' do
        get :index, params: {id: 3}
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an empty list of comments as JSON' do
        get :index
        expect(response).to have_http_status(:not_found)

        comments_response = JSON.parse(response.body)
        expect(comments_response).to eq({ "message" => " comments not found" })
      end
    end
  end

end
