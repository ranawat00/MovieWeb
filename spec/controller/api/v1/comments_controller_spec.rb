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


  describe 'POST #create' do
    let!(:user1) { User.create(firstname: 'gaurav', lastname: 'ranawat', username: Faker::Name.name, email: Faker::Internet.email, password: 'Gaurav123') }
    let!(:user2) { User.create(firstname: 'akshay', lastname: 'kumar', username: Faker::Name.name, email: Faker::Internet.email, password: 'akshay123') }
    context'with valid params' do
      let(:valid_comment_params) do
        {
          user_id: user1.id,
          comment_title: 'frontend developer',
          comment_body: 'Html css js react js',
          comment_movie_id: '3'
        }
      end

      it 'create a new Comment' do
        
        post :create, params: {comment:valid_comment_params }
        expect(response).to have_http_status(:created)

        comment_response = JSON.parse(response.body)
        expect(comment_response['message']).to eq('comment successfully created')
        expect(comment_response['comment']['user_id']).to eq(user1.id)
        expect(comment_response['comment']['comment_title']).to eq('frontend developer')
        expect(comment_response['comment']['comment_body']).to eq('Html css js react js')
        expect(comment_response['comment']['comment_movie_id']).to eq('3')
      end
    end

    context 'with invalid params' do
      let(:invalid_comment_params) do 
        {
          user_id: user1.id,
          comment_title: '',
          comment_body: 'Html css js react js',
          comment_movie_id: '3'
        }
      end
      it 'does not create a new Comment' do
        post :create, params: {comment:invalid_comment_params }
        expect(response).to have_http_status(:unprocessable_entity)

        comment_response = JSON.parse(response.body)
        expect(comment_response['message']).to eq('comment not created')
      end
    end
  end



  describe 'PATCH #update' do
    let!(:user1) { User.create(firstname: 'gaurav', lastname: 'ranawat', username: Faker::Name.name, email: Faker::Internet.email, password: 'Gaurav123') }
    let!(:user2) { User.create(firstname: 'akshay', lastname: 'kumar', username: Faker::Name.name, email: Faker::Internet.email, password: 'akshay123') }
    let!(:comment1) { Comment.create(user_id: user1.id, comment_title: 'frontend developer', comment_body: 'Html css js react js', comment_movie_id: 3) }
    let!(:comment2) { Comment.create(user_id: user2.id, comment_title: 'backend developer', comment_body: 'java python ruby rails Sql', comment_movie_id: 5) }

    context 'with valid params' do
      let(:valid_comment_params) do
        {
          user_id: user1.id,
          comment_title: 'fullstack developer',
          comment_body: 'Html css js react js',
          comment_movie_id: '3'
        
        }
      end

      it 'update the comment' do
        patch :update, params: { id: comment1.id, comment: valid_comment_params }
        expect(response).to have_http_status(:ok)
        comment_response = JSON.parse(response.body)
        expect(comment_response['message']).to eq('comment successfully updated')
      end 
    end

    context 'with invalid params' do
      let(:invalid_comment_params) do
        {
          user_id: user1.id,
          comment_title: '',
          comment_body: 'Html css js react js',
          comment_movie_id: '3'
        }
      end

      it 'comment present but params is invalid ' do
        patch :update, params: { id: comment1.id, comment: invalid_comment_params }
        expect(response).to have_http_status(:unprocessable_entity)
        error_response = JSON.parse(response.body)
        expect(error_response).to include('errors')
        expect(error_response['errors']).to eq(["Comment title can't be blank"])
      end 
    end



    context 'comment id is not present' do
      it'returns http not found' do
        patch :update, params: { id: "" }
        expect(response).to have_http_status(:not_found)
        error_response = JSON.parse(response.body)
        expect(error_response).to include('errors')
        expect(error_response['errors']).to eq('comment not found')
      end
    end
  end


  describe 'DELETE #destroy' do
    let!(:user1) { User.create(firstname: 'gaurav', lastname: 'ranawat', username: Faker::Name.name, email: Faker::Internet.email, password: 'Gaurav123') }
    let!(:user2) { User.create(firstname: 'akshay', lastname: 'kumar', username: Faker::Name.name, email: Faker::Internet.email, password: 'akshay123') }
    let!(:comment1) { Comment.create(user_id: user1.id, comment_title: 'frontend developer', comment_body: 'Html css js react js', comment_movie_id: 3) }
    let!(:comment2) { Comment.create(user_id: user2.id, comment_title: 'backend developer', comment_body: 'java python ruby rails Sql', comment_movie_id: 5) }
    context 'when comment is present' do
      it 'http resposne is successful' do
        delete :destroy, params: { id: comment1.id }
        expect(response).to have_http_status(:ok)
      end
      it 'delete the comment' do
        delete :destroy, params: { id: comment1.id }
        expect(response).to have_http_status(:ok)
        comment_response = JSON.parse(response.body)
        expect(comment_response['message']).to eq('comment successfully deleted')
      end
    end

    context 'when the comment is not found' do
      it 'http resposne is not found' do
        delete :destroy, params: { id: "" }
        expect(response).to have_http_status(:not_found)
        error_response = JSON.parse(response.body)
        expect(error_response).to include('errors')
        expect(error_response['errors']).to eq('comment not found')
      end
      
    end

  end

end
