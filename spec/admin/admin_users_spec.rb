require 'rails_helper'

# RSpec.describe 'Admin panel for User model', type: :feature do
RSpec.describe Admin::UsersController, type: :controller do
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
debugger
      expect(response).to have_http_status(200)
      # Add more expectations as needed for other displayed attributes
    end
  end

  describe 'Show page' do
    it 'displays the details of a user' do
      get :show, params: {id: @user.id}

      expect(response).to have_http_status(200)
      # Add more expectations as needed for other displayed attributes
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

      expect(response).to have_http_status(200)
    end
  end

  # describe 'Editing a user' do
  #   it 'allows the admin to edit an existing user' do
  #     user = create(:user, firstname: 'Jane', lastname: 'Doe')

  #     visit edit_admin_user_path(user)

  #     fill_in 'user_firstname', with: 'Updated Firstname'
  #     fill_in 'user_lastname', with: 'Updated Lastname'

  #     click_button 'Update User'

  #     expect(page).to have_content('User was successfully updated.')
  #     expect(user.reload.firstname).to eq('Updated Firstname')
  #     # Add more expectations as needed
  #   end
  # end

  # describe 'Deleting a user' do
  #   it 'allows the admin to delete a user' do
  #     user = create(:user)

  #     visit admin_users_path

  #     expect(page).to have_content(user.firstname)

  #     click_link 'Delete', href: admin_user_path(user)

  #     expect(page).to have_content('User was successfully destroyed.')
  #     expect(User.exists?(user.id)).to be_falsey
  #   end
  # end
end
