require 'rails_helper'

# RSpec.describe 'Admin panel for User model', type: :feature do
RSpec.describe Admin::RatingsController, type: :controller do
  include Rails.application.routes.url_helpers

  render_views
  before(:each) do
    @admin = AdminUser.create!(email: 'test123@example.com', password: 'password', password_confirmation: 'password')
    @admin.save
    sign_in @admin
    @user = FactoryBot.create(:user)
    @rating = FactoryBot.create(:rating)
  end

  describe 'Index page' do
    it 'displays the list of ratings' do
      get :index
      expect(response).to have_http_status(200)
    end
    before(:each) do
      sign_out :user 
    end
  end

  describe 'Show page' do
    it 'displays the details of a rating' do
      get :show, params: {id: @rating.id}
      expect(response).to have_http_status(200)
    end
    before(:each) do
      sign_out :user 
    end
 

    it 'does not display sensitive data' do
      sensitive_data_rating = FactoryBot.create(:rating, sensitive_attribute: nil)
      
      get :show, params: { id: sensitive_data_rating.id }
      expect(sensitive_data_rating.sensitive_attribute).to be_nil
      expect(response.body).not_to include('Sensitive Data: ' + (sensitive_data_rating.sensitive_attribute || '').to_s)  
    end
    it 'returns a 404 status for non-existent user' do
      expect {
        get :show, params: { id: 'nonexistent_id' }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
    

  describe 'Creating a rating' do
    let(:valid_rating_params) do
      {
        user_id: @user.id,
        rating_value:7.6,
        rating_movie_id: 3
      }
    end
    it 'allows the admin to create a new rating' do
      post :create, params:{rating: valid_rating_params}

      expect(response).to have_http_status(302)
    end

    it 'renders the new template with errors for invalid rating params' do
      invalid_rating_params = { rating_movie_id: '' } 
      post :create, params: { rating: invalid_rating_params }
      expect(response).to render_template(:new)
      expect(assigns(:rating).errors).not_to be_empty
    end
  end

  describe 'Updating a rating' do
    let(:valid_rating_params) do
      {
        user_id: @user.id,
        rating_value:6.6,
        rating_movie_id: 5
      }
    end
    it 'allows the admin to edit an existing rating' do
      patch :update, params: {id: @user.id, rating: valid_rating_params}

      expect(response).to have_http_status(302)
    end

    it 'renders the edit template with errors for invalid user params' do
      invalid_rating_params = { rating_movie_id: '',rating_value:nil } 
      patch :update, params: { id: @user.id, rating: invalid_rating_params }
      expect(response).to render_template(:edit)
      expect(assigns(:rating).errors).not_to be_empty
    end
  end

  describe 'Deleting a rating' do
    it 'allows the admin to delete a rating' do
      rating = FactoryBot.create(:rating)
      delete :destroy, params: { id: rating.id }
      
      expect(response).to have_http_status(302) # or 200 if you redirect after deletion
    end
    
  end
end