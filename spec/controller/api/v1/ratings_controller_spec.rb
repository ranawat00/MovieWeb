require 'rails_helper'
require 'faker'

RSpec.describe Api::V1::RatingsController, type: :controller do
  describe 'GET #index' do
    context 'when ratings is present' do
      let!(:user1) { User.create(firstname: 'gaurav', lastname: 'ranawat', username: Faker::Name.name, email: Faker::Internet.email, password: 'Gaurav123') }
      let!(:user2) { User.create(firstname: 'akshay', lastname: 'kumar', username: Faker::Name.name, email: Faker::Internet.email, password: 'akshay123') }
      let!(:rating1) {Rating.create(user_id: user1.id,rating_value: 4.5, rating_movie_id: 3)}
      let!(:rating2) {Rating.create(user_id: user2.id,rating_value: 6.5, rating_movie_id: 5)}

      it'returns status code 200' do
        get :index
        expect(response).to have_http_status(:ok)
      end

      it'returns all ratings' do
        get :index
        expect(response).to have_http_status(:ok)
        watclists_response=JSON.parse(response.body)
        expect(watclists_response.count).to eq(2)
        expect(watclists_response[0]['rating_movie_id']).to eq(rating1.rating_movie_id)
        expect(watclists_response[1]['rating_movie_id']).to eq(rating2.rating_movie_id)
      end
    end
  

    context 'when ratings is not present' do 
      it 'returns http not found' do
        get :index
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an empty list of ratings as JSON' do
        get :index
        expect(response).to have_http_status(:not_found)
        ratings_response = JSON.parse(response.body)
        expect(ratings_response).to eq({ "message" => "ratings not found" })
      end
    end
  end

  describe 'GET #show' do 
    context 'when rating is present' do
      let!(:user1) { User.create(firstname: 'gaurav', lastname: 'ranawat', username: Faker::Name.name, email: Faker::Internet.email, password: 'Gaurav123') }
      let!(:user2) { User.create(firstname: 'akshay', lastname: 'kumar', username: Faker::Name.name, email: Faker::Internet.email, password: 'akshay123') }
      let!(:rating1) {Rating.create(user_id: user1.id,rating_value: 4.5, rating_movie_id: 3)}
      let!(:rating2) {Rating.create(user_id: user2.id,rating_value: 6.5, rating_movie_id: 5)}
      it 'return resposne  is successfull' do
        get :show ,params:{id: rating1.id}
        expect(response).to have_http_status(:ok)
      end
      
      it 'return rating as JSON' do 
        get :show ,params:{id: rating1.id}
        expect(response).to have_http_status(:ok)
        watclists_response=JSON.parse(response.body)
        expect(watclists_response['rating_movie_id']).to eq(rating1.rating_movie_id)
      end
    end

    context 'when rating is not present' do 
      it 'return response is not successfull' do
        get :show ,params: {id:"5"}
        expect(response).to have_http_status(:not_found)
      end
      it 'return an empty list of rating as JSON' do
        get :show ,params: {id:""}
        expect(response).to have_http_status(:not_found)
        ratings_response = JSON.parse(response.body)
        expect(ratings_response).to eq({ "message" => "rating not found" })
      end
    end   
  end


  describe 'POST #create' do
    let!(:user1) { User.create(firstname: 'gaurav', lastname: 'ranawat', username: Faker::Name.name, email: Faker::Internet.email, password: 'Gaurav123') }
    let!(:user2) { User.create(firstname: 'akshay', lastname: 'kumar', username: Faker::Name.name, email: Faker::Internet.email, password: 'akshay123') }
    context 'with valid params' do
      let(:valid_rating_params) do
        {
          user_id: user1.id,
          rating_value: 4.5,
          rating_movie_id: 3
        }
      end
      it 'create a rating' do
        post :create, params: {rating:valid_rating_params}
        expect(response).to have_http_status(:created)
        ratings_response=JSON.parse(response.body)
        expect(ratings_response['message']).to eq("rating created succesfull")
        expect(ratings_response['rating']['user_id']).to eq(user1.id)
        expect(ratings_response['rating']['rating_movie_id']).to eq('3')
      end
    end

    context 'with invalid params' do
      let(:invalid_rating_params) do
        {
          user_id: user1.id,
          rating_value: 4.5,
          rating_movie_id: ''
        }
      end
      it 'does not create a rating' do
        
        post :create, params: {rating:invalid_rating_params}
        expect(response).to have_http_status(:unprocessable_entity)
        ratings_response=JSON.parse(response.body)
        expect(ratings_response['message']).to eq("rating created unsuccessfull")
      end
    end
  end


  describe 'PATCH #update' do 
    context 'when rating is present' do
      let!(:user1) { User.create(firstname: 'gaurav', lastname: 'ranawat', username: Faker::Name.name, email: Faker::Internet.email, password: 'Gaurav123') }
      let!(:user2) { User.create(firstname: 'akshay', lastname: 'kumar', username: Faker::Name.name, email: Faker::Internet.email, password: 'akshay123') }
      let!(:rating1) { Rating.create(user_id: user1.id, rating_value: 4.5,rating_movie_id: 3) }
      let!(:rating2) { Rating.create(user_id: user2.id, rating_value: 6.5,rating_movie_id: 5) }
      let!(:valid_rating_params) do
        {
          user_id: user1.id,
          rating_value: 8.5,
          rating_movie_id: '10'
        }
      end

      it 'returns status successfully' do
        patch :update, params: { id: rating1.id, rating: valid_rating_params }
        expect(response).to have_http_status(:ok)
      end

      it 'with valid params, updates the rating' do
        patch :update, params: { id: rating1.id, rating: valid_rating_params }
        expect(response).to have_http_status(:ok)
        ratings_response = JSON.parse(response.body)
        expect(ratings_response['message']).to eq('rating successfully updated')
      end
    end
      
    context 'with invalid params' do
      let!(:user1) { User.create(firstname: 'gaurav', lastname: 'ranawat', username: Faker::Name.name, email: Faker::Internet.email, password: 'Gaurav123') }
      let!(:rating1) { Rating.create(user_id: user1.id, rating_value: 6.5,rating_movie_id: 3) }
      let(:invalid_rating_params) do
        {
          user_id: user1.id,
          rating_value: 6.5,
          rating_movie_id: ''
        }
      end

      it 'rating present but params is invalid ' do
        patch :update, params: { id: rating1.id, rating: invalid_rating_params }
        expect(response).to have_http_status(:unprocessable_entity)
        error_response = JSON.parse(response.body)
        expect(error_response).to include('errors')
        expect(error_response['errors']).to eq(["Rating movie can't be blank"])
      end 
    end


    context 'rating id is not present' do
      it'returns http not found' do
        patch :update, params: { id: "" }
        expect(response).to have_http_status(:not_found)
        error_response = JSON.parse(response.body)
        expect(error_response).to include('errors')
        expect(error_response['errors']).to eq('rating not found')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when rating is present' do
      let!(:user1) { User.create(firstname: 'gaurav', lastname: 'ranawat', username: Faker::Name.name, email: Faker::Internet.email, password: 'Gaurav123') }
      let!(:user2) { User.create(firstname: 'akshay', lastname: 'kumar', username: Faker::Name.name, email: Faker::Internet.email, password: 'akshay123') }
      let!(:rating1) { Rating.create(user_id: user1.id,rating_value: 4.5, rating_movie_id: 3) }
      let!(:rating2) { Rating.create(user_id: user2.id,rating_value: 6.5, rating_movie_id: 5) }
      it'returns status successfully' do
        delete :destroy, params: { id: rating1.id }
        expect(response).to have_http_status(:ok)
      end
      it 'deletes the rating' do
        delete :destroy, params: { id: rating1.id }
        expect(response).to have_http_status(:ok)
        ratings_response = JSON.parse(response.body)
        expect(ratings_response['message']).to eq("rating successfully deleted")
      end
    end
    context 'when rating is not present' do
      it'returns http not found' do
        delete :destroy, params: { id: "" }
        expect(response).to have_http_status(:not_found)
        error_response = JSON.parse(response.body)
        expect(error_response).to include('errors')
        expect(error_response['errors']).to eq("rating not found")
      end
    end
  end

end

