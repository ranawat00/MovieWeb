require 'rails_helper'
require 'faker'

RSpec.describe Api::V1::WatchlatersController, type: :controller do
  describe 'GET #index' do
    context 'when watchlaters is present' do
      let!(:user1) { User.create(firstname: 'gaurav', lastname: 'ranawat', username: Faker::Name.name, email: Faker::Internet.email, password: 'Gaurav123') }
      let!(:user2) { User.create(firstname: 'akshay', lastname: 'kumar', username: Faker::Name.name, email: Faker::Internet.email, password: 'akshay123') }
      let!(:watchlater1) {Watchlater.create(user_id: user1.id, watchlater_movie_id: 3)}
      let!(:watchlater2) {Watchlater.create(user_id: user2.id, watchlater_movie_id: 5)}

      it'returns status code 200' do
        get :index
        expect(response).to have_http_status(:ok)
      end

      it'returns all watchlaters' do
        get :index
        expect(response).to have_http_status(:ok)
        watchlaters_response=JSON.parse(response.body)
        expect(watchlaters_response.count).to eq(2)
        expect(watchlaters_response[0]['watchlater_movie_id']).to eq(watchlater1.watchlater_movie_id)
        expect(watchlaters_response[1]['watchlater_movie_id']).to eq(watchlater2.watchlater_movie_id)
      end
    end
  

    context 'when watchlaters is not present' do 
      it 'returns http not found' do
        get :index
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an empty list of watchlaters as JSON' do
        get :index
        expect(response).to have_http_status(:not_found)
        watchlaters_response = JSON.parse(response.body)
        expect(watchlaters_response).to eq({ "message" => " watchlaters not found" })
      end
    end
  end

  describe 'GET #show' do 
    context 'when watchlater is present' do
      let!(:user1) { User.create(firstname: 'gaurav', lastname: 'ranawat', username: Faker::Name.name, email: Faker::Internet.email, password: 'Gaurav123') }
      let!(:user2) { User.create(firstname: 'akshay', lastname: 'kumar', username: Faker::Name.name, email: Faker::Internet.email, password: 'akshay123') }
      let!(:watchlater1) {Watchlater.create(user_id: user1.id, watchlater_movie_id: 3)}
      let!(:watchlater2) {Watchlater.create(user_id: user2.id, watchlater_movie_id: 5)}
      it 'return resposne  is successfull' do
        get :show ,params:{id: watchlater1.id}
        expect(response).to have_http_status(:ok)
      end
      
      it 'return watchlater as JSON' do 
        get :show ,params:{id: watchlater1.id}
        expect(response).to have_http_status(:ok)
        watchlaters_response=JSON.parse(response.body)
        expect(watchlaters_response['watchlater_movie_id']).to eq(watchlater1.watchlater_movie_id)
      end
    end

    context 'when watchlater is not present' do 
      it 'return response is not successfull' do
        get :show ,params: {id:"5"}
        expect(response).to have_http_status(:not_found)
      end
      it 'return an empty list of watchlater as JSON' do
        get :show ,params: {id:""}
        expect(response).to have_http_status(:not_found)
        watchlaters_response = JSON.parse(response.body)
        expect(watchlaters_response).to eq({ "message" => "watchlater not found" })
      end
    end   
  end


  describe 'POST #create' do
    let!(:user1) { User.create(firstname: 'gaurav', lastname: 'ranawat', username: Faker::Name.name, email: Faker::Internet.email, password: 'Gaurav123') }
    let!(:user2) { User.create(firstname: 'akshay', lastname: 'kumar', username: Faker::Name.name, email: Faker::Internet.email, password: 'akshay123') }
    context 'with valid params' do
      let(:valid_watchlater_params) do
        {
          user_id: user1.id,
          watchlater_movie_id: 3
        }
      end
      it 'create a watchlater' do
        
        post :create, params: {watchlater:valid_watchlater_params}
        expect(response).to have_http_status(:created)
        watchlaters_response=JSON.parse(response.body)
        expect(watchlaters_response['message']).to eq('watchlater successfully created')
        expect(watchlaters_response['watchlater']['user_id']).to eq(user1.id)
        expect(watchlaters_response['watchlater']['watchlater_movie_id']).to eq('3')
      end
    end

    context 'with invalid params' do
      let(:invalid_watchlater_params) do
        {
          user_id: user1.id,
          watchlater_movie_id: ''
        }
      end
      it 'does not create a watchlater' do
        
        post :create, params: {watchlater:invalid_watchlater_params}
        expect(response).to have_http_status(:unprocessable_entity)
        watchlaters_response=JSON.parse(response.body)
        expect(watchlaters_response['message']).to eq('watchlater not created')
      end
    end
  end


  describe 'PATCH #update' do 
    context 'when watchlater is present' do
      let!(:user1) { User.create(firstname: 'gaurav', lastname: 'ranawat', username: Faker::Name.name, email: Faker::Internet.email, password: 'Gaurav123') }
      let!(:user2) { User.create(firstname: 'akshay', lastname: 'kumar', username: Faker::Name.name, email: Faker::Internet.email, password: 'akshay123') }
      let!(:watchlater1) { Watchlater.create(user_id: user1.id, watchlater_movie_id: 3) }
      let!(:watchlater2) { Watchlater.create(user_id: user2.id, watchlater_movie_id: 5) }
      let!(:valid_watchlater_params) do
        {
          user_id: user1.id,
          watchlater_movie_id: '10'
        }
      end

      it 'returns status successfully' do
        patch :update, params: { id: watchlater1.id, watchlater: valid_watchlater_params }
        expect(response).to have_http_status(:ok)
      end

      it 'with valid params, updates the watchlater' do
        patch :update, params: { id: watchlater1.id, watchlater: valid_watchlater_params }
        expect(response).to have_http_status(:ok)
        watchlaters_response = JSON.parse(response.body)
        expect(watchlaters_response['message']).to eq('watchlater successfully updated')
      end
    end
      
    context 'with invalid params' do
      let!(:user1) { User.create(firstname: 'gaurav', lastname: 'ranawat', username: Faker::Name.name, email: Faker::Internet.email, password: 'Gaurav123') }
      let!(:watchlater1) { Watchlater.create(user_id: user1.id, watchlater_movie_id: 3) }
      let(:invalid_watchlater_params) do
        {
          user_id: user1.id,
          watchlater_movie_id: ''
        }
      end

      it 'watchlater present but params is invalid ' do
        patch :update, params: { id: watchlater1.id, watchlater: invalid_watchlater_params }
        expect(response).to have_http_status(:unprocessable_entity)
        error_response = JSON.parse(response.body)
        expect(error_response).to include('errors')
        expect(error_response['errors']).to eq(["Watchlater movie can't be blank"])
      end 
    end


    context 'watchlater id is not present' do
      it'returns http not found' do
        patch :update, params: { id: "" }
        expect(response).to have_http_status(:not_found)
        error_response = JSON.parse(response.body)
        expect(error_response).to include('errors')
        expect(error_response['errors']).to eq('watchlater not found')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when watchlater is present' do
      let!(:user1) { User.create(firstname: 'gaurav', lastname: 'ranawat', username: Faker::Name.name, email: Faker::Internet.email, password: 'Gaurav123') }
      let!(:user2) { User.create(firstname: 'akshay', lastname: 'kumar', username: Faker::Name.name, email: Faker::Internet.email, password: 'akshay123') }
      let!(:watchlater1) { Watchlater.create(user_id: user1.id, watchlater_movie_id: 3) }
      let!(:watchlater2) { Watchlater.create(user_id: user2.id, watchlater_movie_id: 5) }
      it'returns status successfully' do
        delete :destroy, params: { id: watchlater1.id }
        expect(response).to have_http_status(:ok)
      end
      it 'deletes the watchlater' do
        delete :destroy, params: { id: watchlater1.id }
        expect(response).to have_http_status(:ok)
        watchlaters_response = JSON.parse(response.body)
        expect(watchlaters_response['message']).to eq("watchlater successfully deleted")
      end
    end
    context 'when watchlater is not present' do
      it'returns http not found' do
        delete :destroy, params: { id: "" }
        expect(response).to have_http_status(:not_found)
        error_response = JSON.parse(response.body)
        expect(error_response).to include('errors')
        expect(error_response['errors']).to eq("watchlater not found")
      end
    end
  end

end

