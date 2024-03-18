require 'rails_helper'
require 'faker'

RSpec.describe Api::V1::UsersController, type: :controller do

  describe 'GET #index' do
    context 'when users are present' do
      let!(:user1) { User.create(firstname: 'gaurav', lastname: 'ranawat', username: Faker::Internet.unique.username, email: Faker::Internet.unique.email, password: 'Gaurav123') }
      let!(:user2) { User.create(firstname: 'akshay', lastname: 'kumar', username: Faker::Internet.unique.username, email: Faker::Internet.unique.email, password: 'Akshay123') }
      
      it 'returns a successful response' do
        get :index
        expect(response).to have_http_status(:ok)
      end
  
      it 'returns a list of users as JSON' do
        get :index
        expect(response).to have_http_status(:ok)
        users_response = JSON.parse(response.body)
        
        expect(users_response.map { |user| user['username'] }).to include(user1.username, user2.username)
        expect(users_response.map { |user| user['email'] }).to include(user1.email, user2.email)
      end
    end
  
    context 'when no users are present' do
      before do
        User.destroy_all
      end
      it 'returns a not found response' do
        get :index
        expect(response).to have_http_status(:not_found)
  
        error_response = JSON.parse(response.body)
        expect(error_response).to include('errors')
        expect(error_response['errors']).to eq('No users found')
      end
    end
  end




  describe 'GET #show' do
    context 'when user is present' do
      let!(:user1) { User.create(firstname: 'gaurav', lastname: 'ranawat', username: Faker::Internet.unique.username, email: Faker::Internet.unique.email, password: 'Gaurav123') }
      let!(:user2) { User.create(firstname: 'akshay', lastname: 'kumar', username: Faker::Internet.unique.username, email: Faker::Internet.unique.email, password: 'akshay123') }
      it 'returns a user as JSON' do
        get :show, params: { id: user1.id }
        expect(response).to have_http_status(:ok)

        user_response = JSON.parse(response.body)
        expect(user_response['username']).to eq(user1.username)
        expect(user_response['email']).to eq(user1.email)
        expect(user_response['id']).to eq(user1.id)
      end
    end

    context 'when user is not present' do
     
      it 'returns an error message as JSON' do
        get :show, params: { id: "" } 
        expect(response).to have_http_status(:not_found)

        error_response = JSON.parse(response.body)
        expect(error_response).to include('errors')
        expect(error_response['errors']).to eq('User not found')
      end
    end
  end


  describe 'POST #create' do
    context 'with valid params' do
      let(:valid_user_params) do {
        firstname: 'gaurav',
        lastname: 'ranawat',
        username: 'Gaurav123',
        email: 'gauravranawat7900@gmail.com',
        password: '123456',
        password_confirmation: '123456'

        }
     end

      it 'create a new user' do
        post :create, params: {user: valid_user_params}
        expect(response).to have_http_status(:created)
        user_response = JSON.parse(response.body)
        expect(user_response).to include('token')
        expect(user_response['user_details']).to include('id', 'firstname', 'lastname', 'username', 'email')
        
      end
    end

    context 'with invalid params' do
      let(:invalid_user_params) do {
        firstname: '',
        lastname: 'ranawat',
        username: 'Gaurav123',
        email: 'gauravranawat7900@gmail.com',
        password: '123456',
        password_confirmation: '123456'
    
        }
      end

      it 'does not create a new user' do
        post :create,params: {user:invalid_user_params}
        expect(response).to have_http_status(:unprocessable_entity)
        error_response = JSON.parse(response.body)
        expect(error_response).to include('errors')
        expect(error_response['errors']).to eq(["Firstname can't be blank"])
      end
    end
  end


  describe 'PATCH #update' do
    context 'when user is present' do
      let!(:user1) { User.create(firstname: 'gaurav', lastname: 'ranawat', username: Faker::Internet.unique.username, email: Faker::Internet.unique.email, password: 'Gaurav123') }
      let!(:user2) { User.create(firstname: 'akshay', lastname: 'kumar', username: Faker::Internet.unique.username, email: Faker::Internet.unique.email, password: 'akshay123') }
      let(:valid_user_params) do 
        {
          firstname: 'Rahul',
          lastname: 'ranawat',
          username: 'Gaurav123',
          email: 'gauravranawat7900@gmail.com',
          password: '123456',
          password_confirmation: '123456'

        }
      end

      it 'returns a user as JSON' do
        patch :update, params: { id: user1.id ,user:valid_user_params}
        expect(response).to have_http_status(:ok)

        users_response = JSON.parse(response.body)
        expect(users_response ['user']['username']).to eq('Gaurav123')
        expect(users_response['user']['email']).to eq('gauravranawat7900@gmail.com')
        expect(users_response['user']['id']).to eq(user1.id)
      end
  
      it 'updates the user' do
        patch :update, params: { id: user1.id, user: valid_user_params }
        expect(response).to have_http_status(:ok)
      
        updated_user = User.find(user1.id)
        expect(updated_user.firstname).to eq('Rahul')
        expect(updated_user.email).to eq('gauravranawat7900@gmail.com')
      end

      context 'with invalid params' do
        let(:invalid_user_params) do 

          {
          firstname: '',
          lastname: 'ranawat',
          username: 'Gaurav123',
          email: 'gauravranawat7900@gmail.com',
          password: '123456',
          password_confirmation: '123456'
      
          }
        end
        it 'does not update the user when the invalid params' do
          
          patch :update,params: {id:user1.id,user:invalid_user_params}
          expect(response).to have_http_status(:unprocessable_entity)
          error_response = JSON.parse(response.body)
          expect(error_response).to include('errors')
          expect(error_response['errors']).to eq(["Firstname can't be blank"])
        end
      end
    end


    context 'when user is not present' do
      it 'returns an error message as JSON' do
        patch :update, params: { id: "" } 
        expect(response).to have_http_status(:not_found)

        error_response = JSON.parse(response.body)
        expect(error_response).to include('errors')
        expect(error_response['errors']).to eq('User not found')
      end
    end

  end


  describe 'DELETE #destroy' do
  
    context 'when user is present' do 
      let!(:user1) { User.create(firstname: 'gaurav', lastname: 'ranawat',username: Faker::Internet.unique.username, email: Faker::Internet.unique.email, password: 'Gaurav123') }
      let!(:user2) { User.create(firstname: 'akshay', lastname: 'kumar', username: Faker::Internet.unique.username, email: Faker::Internet.unique.email, password: 'akshay123') }
      it 'return a success response' do
        delete :destroy, params: { id: user1.id }
        expect(response).to have_http_status(:ok)
      end

      it 'deletes the user' do
        delete :destroy, params: {id:user2.id}
        json_response = JSON.parse(response.body)
        expect(json_response).to eq("message" => "User successfully deleted")
      end
    end
    context 'when user is not present' do
      it 'returns an error message as JSON' do
        delete :destroy, params: { id: "" } 
        expect(response).to have_http_status(:not_found)

        error_response = JSON.parse(response.body)  
        expect(error_response).to include('errors')
        expect(error_response['errors']).to eq('User not found')
      end
    end
  end
end