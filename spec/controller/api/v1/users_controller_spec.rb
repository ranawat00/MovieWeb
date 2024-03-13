require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do

  describe 'GET #index' do
    context 'when users are present' do
      let!(:user1) { User.create(firstname: 'gaurav', lastname: 'ranawat', username: 'gaurav', email: 'john@example.com', password: 'Gaurav123') }
      let!(:user2) { User.create(firstname: 'akshay', lastname: 'kumar', username: 'akshay', email: 'akshay@example.com', password: 'akshay123') }

      it 'returns a successful response' do
        get :index
        expect(response).to have_http_status(:ok)
      end

      it 'returns a list of users as JSON' do
        get :index
        expect(response).to have_http_status(:ok)

        users_response = JSON.parse(response.body)
        expect(users_response.size).to eq(2)
        expect(users_response.map { |u| u['username'] }).to include('gaurav', 'akshay')
        expect(users_response.map { |u| u['email'] }).to include('john@example.com', 'akshay@example.com')
      end
    end

    context 'when no users are present' do
      it 'returns a successful response' do
        get :index
        expect(response).to have_http_status(:ok)
      end
  
      it 'returns an empty list of users as JSON' do
        get :index
        expect(response).to have_http_status(:ok)
  
        users_response = JSON.parse(response.body)
        expect(users_response).to be_an(Array)
        expect(users_response).to be_empty
      end
    end
  end


  describe 'GET #show' do
    context 'when user is present' do
      let!(:user1) { User.create(firstname: 'gaurav', lastname: 'ranawat', username: 'Gaurav123', email: 'john@example.com', password: 'Gaurav123') }
      let!(:user2) { User.create(firstname: 'akshay', lastname: 'kumar', username: 'Akshay123', email: 'akshay@example.com', password: 'akshay123') }
      it 'returns a user as JSON' do
        get :show, params: { id: user1.id }
        expect(response).to have_http_status(:ok)

        user_response = JSON.parse(response.body)
        expect(user_response['username']).to eq('Gaurav123')
        expect(user_response['email']).to eq('john@example.com')
        expect(user_response['id']).to eq(user1.id)
      end
    end

    context 'when user is not present' do
      it 'returns an error message as JSON' do
        get :show, params: { id: 3 } 
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
      let!(:user1) { User.create(firstname: 'gaurav', lastname: 'ranawat', username: 'Gaurav123', email: 'john@example.com', password: 'Gaurav123') }
      let!(:user2) { User.create(firstname: 'akshay', lastname: 'kumar', username: 'Akshay123', email: 'akshay@example.com', password: 'akshay123') }
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

        user_response = JSON.parse(response.body)
        expect(user_response['username']).to eq('Gaurav123')
        expect(user_response['email']).to eq('gauravranawat7900@gmail.com')
        expect(user_response['id']).to eq(user1.id)
      end
  
      it 'update the  user' do
        patch :update, params: {id:user1.id ,user: valid_user_params}
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
        patch :update, params: { id: 3 } 
        expect(response).to have_http_status(:not_found)

        error_response = JSON.parse(response.body)
        expect(error_response).to include('errors')
        expect(error_response['errors']).to eq('User not found')
      end
    end

  end
   
end