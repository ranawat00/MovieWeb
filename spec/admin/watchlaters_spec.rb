require 'rails_helper'

# RSpec.describe 'Admin panel for User model', type: :feature do
RSpec.describe Admin::WatchlatersController, type: :controller do
  include Rails.application.routes.url_helpers

  render_views
  before(:each) do
    @admin = AdminUser.create!(email: 'test123@example.com', password: 'password', password_confirmation: 'password')
    @admin.save
    sign_in @admin
    @user = FactoryBot.create(:user)
    @watchlater = FactoryBot.create(:watchlater)
  end

  describe 'Index page' do
    it 'displays the list of watchlaters' do
      get :index
      expect(response).to have_http_status(200)
    end
    before(:each) do
      sign_out :user 
    end
  end

  describe 'Show page' do
    it 'displays the details of a watchlater' do
      get :show, params: {id: @watchlater.id}
      expect(response).to have_http_status(200)
    end
    before(:each) do
      sign_out :user 
    end
 

    it 'does not display sensitive data' do
      sensitive_data_watchlater = FactoryBot.create(:watchlater, sensitive_attribute: nil)
      
      get :show, params: { id: sensitive_data_watchlater.id }
      expect(sensitive_data_watchlater.sensitive_attribute).to be_nil
      expect(response.body).not_to include('Sensitive Data: ' + (sensitive_data_watchlater.sensitive_attribute || '').to_s)  
    end
    it 'returns a 404 status for non-existent user' do
      expect {
        get :show, params: { id: 'nonexistent_id' }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
    

  describe 'Creating a watchlater' do
    let(:valid_watchlater_params) do
      {
        user_id: @user.id,
        watchlater_movie_id: 3
      }
    end
    it 'allows the admin to create a new watchlater' do
      post :create, params:{watchlater: valid_watchlater_params}

      expect(response).to have_http_status(302)
    end

    it 'renders the new template with errors for invalid watchlater params' do
      invalid_watchlater_params = { watchlater_movie_id: '' } 
      post :create, params: { watchlater: invalid_watchlater_params }
      expect(response).to render_template(:new)
      expect(assigns(:watchlater).errors).not_to be_empty
    end
  end

  describe 'Updating a watchlater' do
    let(:valid_watchlater_params) do
      {
        user_id: @user.id,
        watchlater_movie_id: 5
      }
    end
    before do
      @watchlater = FactoryBot.create(:watchlater, id: 5) # Create a watchlater record with the ID you're trying to update
    end
    it 'allows the admin to edit an existing watchlater' do
      patch :update, params: {id: @user.id, watchlater: valid_watchlater_params}

      expect(response).to have_http_status(302)
    end

    it 'renders the edit template with errors for invalid user params' do
      invalid_watchlater_params = { watchlater_movie_id: '' } 
      patch :update, params: { id: @user.id, watchlater: invalid_watchlater_params }
      expect(response).to render_template(:edit)
      expect(assigns(:watchlater).errors).not_to be_empty
    end
  end

  describe 'Deleting a watchlater' do
    it 'allows the admin to delete a watchlater' do
      watchlater = FactoryBot.create(:watchlater)
      delete :destroy, params: { id: watchlater.id }
      
      expect(response).to have_http_status(302) # or 200 if you redirect after deletion
    end
    
  end
end