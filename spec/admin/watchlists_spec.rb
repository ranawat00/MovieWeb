require 'rails_helper'

# RSpec.describe 'Admin panel for User model', type: :feature do
RSpec.describe Admin::WatchlistsController, type: :controller do
  include Rails.application.routes.url_helpers

  render_views
  before(:each) do
    @admin = AdminUser.create!(email: 'test123@example.com', password: 'password', password_confirmation: 'password')
    @admin.save
    sign_in @admin
    @user = FactoryBot.create(:user)
    @watchlist = FactoryBot.create(:watchlist)
  end

  describe 'Index page' do
    it 'displays the list of watchlists' do
      get :index
      expect(response).to have_http_status(200)
    end
    before(:each) do
      sign_out :user 
    end
  end

  describe 'Show page' do
    it 'displays the details of a watchlist' do
      get :show, params: {id: @watchlist.id}
      expect(response).to have_http_status(200)
    end
    before(:each) do
      sign_out :user 
    end
 

    it 'does not display sensitive data' do
      sensitive_data_watchlist = FactoryBot.create(:watchlist, sensitive_attribute: nil)
      
      get :show, params: { id: sensitive_data_watchlist.id }
      expect(sensitive_data_watchlist.sensitive_attribute).to be_nil
      expect(response.body).not_to include('Sensitive Data: ' + (sensitive_data_watchlist.sensitive_attribute || '').to_s)  
    end
    it 'returns a 404 status for non-existent user' do
      expect {
        get :show, params: { id: 'nonexistent_id' }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
    

  describe 'Creating a watchlist' do
    let(:valid_watchlist_params) do
      {
        user_id: @user.id,
        watchlist_movie_id: 3
      }
    end
    it 'allows the admin to create a new watchlist' do
      post :create, params:{watchlist: valid_watchlist_params}

      expect(response).to have_http_status(302)
    end

    it 'renders the new template with errors for invalid watchlist params' do
      invalid_watchlist_params = { watchlist_movie_id: '' } 
      post :create, params: { watchlist: invalid_watchlist_params }
      expect(response).to render_template(:new)
      expect(assigns(:watchlist).errors).not_to be_empty
    end
  end

  describe 'Updating a watchlist' do
    let(:valid_watchlist_params) do
      {
        user_id: @user.id,
        watchlist_movie_id: 5
      }
    end
    it 'allows the admin to edit an existing watchlist' do
      patch :update, params: {id: @user.id, watchlist: valid_watchlist_params}

      expect(response).to have_http_status(302)
    end

    it 'renders the edit template with errors for invalid user params' do
      invalid_watchlist_params = { watchlist_movie_id: '' } 
      patch :update, params: { id: @user.id, watchlist: invalid_watchlist_params }
      expect(response).to render_template(:edit)
      expect(assigns(:watchlist).errors).not_to be_empty
    end
  end

  describe 'Deleting a watchlist' do
    it 'allows the admin to delete a watchlist' do
      watchlist = FactoryBot.create(:watchlist)
      delete :destroy, params: { id: watchlist.id }
      
      expect(response).to have_http_status(302) # or 200 if you redirect after deletion
    end
    
  end
end