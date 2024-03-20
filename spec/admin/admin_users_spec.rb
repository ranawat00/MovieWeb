require 'rails_helper'

# RSpec.describe 'Admin panel for User model', type: :feature do
RSpec.describe Admin::UsersController, type: :controller do
  include Rails.application.routes.url_helpers

  render_views
  before(:each) do
    @admin = AdminUser.create!(email: 'test123@example.com', password: 'password', password_confirmation: 'password')
    @admin.save
    sign_in @admin
    @user = FactoryBot.create(:user)
  end
 
  describe 'Index page' do
    it 'displays the list of users' do
      get :index
      expect(response).to have_http_status(200)
    end
    before(:each) do
      sign_out :user 
    end
  end

  describe 'Show page' do
    it 'displays the details of a user' do
      get :show, params: {id: @user.id}
      expect(response).to have_http_status(200)
    end
    before(:each) do
      sign_out :user 
    end

    it 'does not display sensitive data' do
      sensitive_data_user = FactoryBot.create(:user, sensitive_attribute: nil)
      
      get :show, params: { id: sensitive_data_user.id }
      expect(sensitive_data_user.sensitive_attribute).to be_nil
      expect(response.body).not_to include('Sensitive Data: ' + (sensitive_data_user.sensitive_attribute || '').to_s)  
    end
    it 'returns a 404 status for non-existent user' do
      expect {
        get :show, params: { id: 'nonexistent_id' }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
    

  describe 'Creating a user' do
    let(:valid_user_params) do {
        firstname: 'gaurav',
        lastname: 'ranawat',
        username: 'Gaurav123',
        email: 'gauravranawat7900@gmail.com',
        password: '123456',
        password_confirmation: '123456'

        }
    end
    it 'allows the admin to create a new user' do
      post :create, params:{user: valid_user_params}

      expect(response).to have_http_status(302)
    end

    it 'renders the new template with errors for invalid user params' do
      invalid_user_params = { firstname: 'John' } 
      post :create, params: { user: invalid_user_params }
      expect(response).to render_template(:new)
      expect(assigns(:user).errors).not_to be_empty
    end
  end

  describe 'Updating a user' do
    let!(:valid_user_params) do
      {
        firstname: 'Rahul',
        lastname: 'Sharma',
        username: 'Gaurav123',
        email: 'gauravranawat7900@gmail.com',
        password: '123456',
        password_confirmation: '123456'

      }
    end
    it 'allows the admin to edit an existing user' do
      patch :update, params: {id: @user.id, user: valid_user_params}

      expect(response).to have_http_status(302)
    end

    it 'renders the edit template with errors for invalid user params' do
      invalid_user_params = { firstname: '' } # Invalid parameter
      patch :update, params: { id: @user.id, user: invalid_user_params }
      expect(response).to render_template(:edit)
      expect(assigns(:user).errors).not_to be_empty
    end
  end

  describe 'Deleting a user' do
    it 'allows the admin to delete a user' do
      user = FactoryBot.create(:user)
      delete :destroy, params: { id: user.id }
      
      expect(response).to have_http_status(302) # or 200 if you redirect after deletion
    end
    
  end
end
