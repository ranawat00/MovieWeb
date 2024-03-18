require 'rails_helper'
require 'faker'

RSpec.describe Api::V1::WatchlistsController, type: :controller do
  describe 'GET #index' do
    context 'when watchlists is present' do
      let!(:user1) { User.create(firstname: 'gaurav', lastname: 'ranawat', username: Faker::Name.name, email: Faker::Internet.email, password: 'Gaurav123') }
      let!(:user2) { User.create(firstname: 'akshay', lastname: 'kumar', username: Faker::Name.name, email: Faker::Internet.email, password: 'akshay123') }
      let!(:watchlist1) {Watchlist.create(user_id: user1.id, watchlist_movie_id: 3)}
      let!(:watchlist2) {Watchlist.create(user_id: user2.id, watchlist_movie_id: 5)}

      it'returns status code 200' do
        get :index
        expect(response).to have_http_status(:ok)
      end

      it'returns all watchlists' do
        get :index
        expect(response).to have_http_status(:ok)
        watclists_response=JSON.parse(response.body)
        expect(watclists_response.count).to eq(2)
        expect(watclists_response[0]['watchlist_movie_id']).to eq(watchlist1.watchlist_movie_id)
        expect(watclists_response[1]['watchlist_movie_id']).to eq(watchlist2.watchlist_movie_id)
      end
    end
  

    context 'when watchlists is not present' do 
      it 'returns http not found' do
        get :index
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an empty list of watchlists as JSON' do
        get :index
        expect(response).to have_http_status(:not_found)
        watchlists_response = JSON.parse(response.body)
        expect(watchlists_response).to eq({ "message" => " watchlists not found" })
      end
    end
  end

  describe 'GET #show' do 
    context 'when watchlist is present' do
      let!(:user1) { User.create(firstname: 'gaurav', lastname: 'ranawat', username: Faker::Name.name, email: Faker::Internet.email, password: 'Gaurav123') }
      let!(:user2) { User.create(firstname: 'akshay', lastname: 'kumar', username: Faker::Name.name, email: Faker::Internet.email, password: 'akshay123') }
      let!(:watchlist1) {Watchlist.create(user_id: user1.id, watchlist_movie_id: 3)}
      let!(:watchlist2) {Watchlist.create(user_id: user2.id, watchlist_movie_id: 5)}
      it 'return resposne  is successfull' do
        get :show ,params:{id: watchlist1.id}
        expect(response).to have_http_status(:ok)
      end
      
      it 'return watchlist as JSON' do 
        get :show ,params:{id: watchlist1.id}
        expect(response).to have_http_status(:ok)
        watclists_response=JSON.parse(response.body)
        expect(watclists_response['watchlist_movie_id']).to eq(watchlist1.watchlist_movie_id)
      end
    end

    context 'when watchlist is not present' do 
      it 'return response is not successfull' do
        get :show ,params: {id:"5"}
        expect(response).to have_http_status(:not_found)
      end
      it 'return an empty list of watchlist as JSON' do
        get :show ,params: {id:""}
        expect(response).to have_http_status(:not_found)
        watchlists_response = JSON.parse(response.body)
        expect(watchlists_response).to eq({ "message" => "Watchlist not found" })
      end
    end   
  end


  describe 'POST #create' do
    let!(:user1) { User.create(firstname: 'gaurav', lastname: 'ranawat', username: Faker::Name.name, email: Faker::Internet.email, password: 'Gaurav123') }
    let!(:user2) { User.create(firstname: 'akshay', lastname: 'kumar', username: Faker::Name.name, email: Faker::Internet.email, password: 'akshay123') }
    context 'with valid params' do
      let(:valid_watchlist_params) do
        {
          user_id: user1.id,
          watchlist_movie_id: 3
        }
      end
      it 'create a watchlist' do
        post :create, params: {watchlist:valid_watchlist_params}
        expect(response).to have_http_status(:created)
        watchlists_response=JSON.parse(response.body)
        expect(watchlists_response['message']).to eq('Watchlist successfully created')
        expect(watchlists_response['watchlist']['user_id']).to eq(user1.id)
        expect(watchlists_response['watchlist']['watchlist_movie_id']).to eq('3')
      end
    end

    context 'with invalid params' do
      let(:invalid_watchlist_params) do
        {
          user_id: user1.id,
          watchlist_movie_id: ''
        }
      end
      it 'does not create a watchlist' do
        
        post :create, params: {watchlist:invalid_watchlist_params}
        expect(response).to have_http_status(:unprocessable_entity)
        watchlists_response=JSON.parse(response.body)
        expect(watchlists_response['message']).to eq('watchlist not created')
      end
    end
  end


  describe 'PATCH #update' do 
    context 'when watchlist is present' do
      let!(:user1) { User.create(firstname: 'gaurav', lastname: 'ranawat', username: Faker::Name.name, email: Faker::Internet.email, password: 'Gaurav123') }
      let!(:user2) { User.create(firstname: 'akshay', lastname: 'kumar', username: Faker::Name.name, email: Faker::Internet.email, password: 'akshay123') }
      let!(:watchlist1) { Watchlist.create(user_id: user1.id, watchlist_movie_id: 3) }
      let!(:watchlist2) { Watchlist.create(user_id: user2.id, watchlist_movie_id: 5) }
      let!(:valid_watchlist_params) do
        {
          user_id: user1.id,
          watchlist_movie_id: '10'
        }
      end

      it 'returns status successfully' do
        patch :update, params: { id: watchlist1.id, watchlist: valid_watchlist_params }
        expect(response).to have_http_status(:ok)
      end

      it 'with valid params, updates the watchlist' do
        patch :update, params: { id: watchlist1.id, watchlist: valid_watchlist_params }
        expect(response).to have_http_status(:ok)
        watchlists_response = JSON.parse(response.body)
        expect(watchlists_response['message']).to eq('watchlist successfully updated')
      end
    end
      
    context 'with invalid params' do
      let!(:user1) { User.create(firstname: 'gaurav', lastname: 'ranawat', username: Faker::Name.name, email: Faker::Internet.email, password: 'Gaurav123') }
      let!(:watchlist1) { Watchlist.create(user_id: user1.id, watchlist_movie_id: 3) }
      let(:invalid_watchlist_params) do
        {
          user_id: user1.id,
          watchlist_movie_id: ''
        }
      end

      it 'watchlist present but params is invalid ' do
        patch :update, params: { id: watchlist1.id, watchlist: invalid_watchlist_params }
        expect(response).to have_http_status(:unprocessable_entity)
        error_response = JSON.parse(response.body)
        expect(error_response).to include('errors')
        expect(error_response['errors']).to eq(["Watchlist movie can't be blank"])
      end 
    end


    context 'watchlist id is not present' do
      it'returns http not found' do
        patch :update, params: { id: "" }
        expect(response).to have_http_status(:not_found)
        error_response = JSON.parse(response.body)
        expect(error_response).to include('errors')
        expect(error_response['errors']).to eq('watchlist not found')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when watchlist is present' do
      let!(:user1) { User.create(firstname: 'gaurav', lastname: 'ranawat', username: Faker::Name.name, email: Faker::Internet.email, password: 'Gaurav123') }
      let!(:user2) { User.create(firstname: 'akshay', lastname: 'kumar', username: Faker::Name.name, email: Faker::Internet.email, password: 'akshay123') }
      let!(:watchlist1) { Watchlist.create(user_id: user1.id, watchlist_movie_id: 3) }
      let!(:watchlist2) { Watchlist.create(user_id: user2.id, watchlist_movie_id: 5) }
      it'returns status successfully' do
        delete :destroy, params: { id: watchlist1.id }
        expect(response).to have_http_status(:ok)
      end
      it 'deletes the watchlist' do
        delete :destroy, params: { id: watchlist1.id }
        expect(response).to have_http_status(:ok)
        watchlists_response = JSON.parse(response.body)
        expect(watchlists_response['message']).to eq("watchlist successfully deleted")
      end
    end
    context 'when watchlist is not present' do
      it'returns http not found' do
        delete :destroy, params: { id: "" }
        expect(response).to have_http_status(:not_found)
        error_response = JSON.parse(response.body)
        expect(error_response).to include('errors')
        expect(error_response['errors']).to eq("watchlist not found")
      end
    end
  end

end

