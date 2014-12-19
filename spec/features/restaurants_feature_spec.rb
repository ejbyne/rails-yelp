require 'rails_helper'

feature 'restaurants' do

  def create_restaurant
    visit '/restaurants'
    click_link 'Add a restaurant'
    fill_in 'Name', with: 'KFC'
    click_button 'Create Restaurant'
    expect(page).to have_content 'KFC'
    expect(current_path).to eq '/restaurants'
  end

  before do
    visit('/')
    click_link('Sign up')
    fill_in('Email', with: 'test@example.com')
    fill_in('Password', with: 'testtest')
    fill_in('Password confirmation', with: 'testtest')
    click_button('Sign up')
  end
  
  context 'no restaurants have been added' do

    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants'
      expect(page).to have_link 'Add a restaurant'
    end

  end

  context 'restaurants have been added' do

    before { create_restaurant }

    scenario 'display restaurants' do
      visit '/restaurants'
      expect(page).to have_content('KFC')
      expect(page).not_to have_content('No restaurants')
    end

  end

  context 'creating restaurants' do

    scenario 'prompts user to fill out a form, then displays the new restaurant' do
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'KFC'
      click_button 'Create Restaurant'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq '/restaurants'
    end

  end

  context 'viewing restaurants' do

    let!(:kfc){ Restaurant.create(name: 'KFC') }

    scenario 'lets a user view a restaurant' do
      visit '/restaurants'
      click_link 'KFC'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq "/restaurants/#{kfc.id}"
    end

  end

  context 'editing restaurants' do

    before { create_restaurant }

    scenario 'let a user edit a restaurant' do
      visit '/restaurants'
      click_link 'Edit KFC'
      fill_in 'Name', with: 'Kentucky Fried Chicken'
      click_button 'Update Restaurant'
      expect(page).to have_content 'Kentucky Fried Chicken'
      expect(current_path).to eq '/restaurants'      
    end


  end

  context 'deleting restaurants' do

    before { create_restaurant }

    scenario 'removes a restaurant when a user clicks a delete link' do
      visit '/restaurants'
      click_link 'Delete KFC'
      expect(page).not_to have_content 'KFC'
      expect(page).to have_content 'Restaurant deleted successfully'
    end

  end

  context 'invalid restaurant' do
    scenario 'does not let you submit a name that is too short' do
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'kf'
      click_button 'Create Restaurant'
      expect(page).not_to have_css 'h2', text: 'kf'
      expect(page).to have_content 'error'
    end

  end

  context 'user cannot edit/delete restaurants they have not created' do
  
    before do
      User.create( email: 'another_user@test.com',
                          password: 'another_test',
                          password_confirmation: 'another_test',
                          id: 2)
    end

    let(:restaurant) { Restaurant.create( name: 'Square Pie',
                                          user_id: 2) }
    
    scenario "user cannot edit or delete a restaurant he hasn't created" do
      visit '/restaurants'
      expect(page).not_to have_content 'Edit Square Pie'
      expect(page).not_to have_content 'Delete Square Pie'
      visit "/restaurants/#{restaurant.id}/edit"
      expect(page).to have_content "You cannot edit a restaurant you haven't created"
      expect(page).not_to have_content 'Update Restaurant'
      # delete "/restaurants/#{restaurant.id}"
      # expect(page).to have_content "You cannot delete a restaurant you haven't created"
      # expect(page).not_to have_content "Restaurant deleted successfully"
    end
  end

  context 'allows an image to be uploaded for a restaurant' do

    scenario "restaurant create form contains image upload option" do
      visit '/restaurants/new'
      expect(page).to have_selector('#restaurant_image')
    end

    scenario "allows an image to be uploaded" do
      visit '/restaurants/new'
      attach_file('restaurant[image]', 'spec/features/del.jpg')
      fill_in 'Name', with: "Del's Diner"
      click_button 'Create Restaurant'
      expect(page).to have_css("img[src*='del.jpg']")
    end

  end

end





















