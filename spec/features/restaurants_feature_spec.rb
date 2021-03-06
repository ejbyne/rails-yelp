require 'rails_helper'

feature 'restaurants' do

  def create_restaurant
    visit '/restaurants'
    click_link 'Add a restaurant'
    fill_in 'Name', with: 'KFC'
    click_button 'Create Restaurant'
  end

  let(:restaurant) { Restaurant.find_by name: 'KFC' }

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

  context 'creating restaurants' do

    scenario 'prompts user to fill out a form, then displays the new restaurant' do
      create_restaurant
      expect(page).to have_content 'KFC'
      expect(current_path).to eq '/restaurants'
      expect(page).not_to have_content('No restaurants')
    end

    scenario 'does not let you submit a name that is too short' do
      visit '/restaurants'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'kf'
      click_button 'Create Restaurant'
      expect(page).not_to have_css 'h2', text: 'kf'
      expect(page).to have_content 'error'
    end

  end

  context 'viewing restaurants' do

    before { create_restaurant }

    scenario 'lets a user view a restaurant' do
      visit '/restaurants'
      click_link 'KFC'
      expect(page).to have_content 'KFC'
      expect(current_path).to eq "/restaurants/#{restaurant.id}"
    end

  end

  context 'editing and deleting restaurants' do

    before { create_restaurant }

    scenario 'let a user edit a restaurant they have created' do
      visit "/restaurants/#{restaurant.id}"
      click_link 'Edit KFC'
      fill_in 'Name', with: 'Kentucky Fried Chicken'
      click_button 'Update Restaurant'
      expect(page).to have_content 'Kentucky Fried Chicken'
      expect(current_path).to eq '/restaurants'      
    end

    scenario 'removes a restaurant when a user clicks a delete link for a restaurant they have created' do
      visit "/restaurants/#{restaurant.id}"
      click_link 'Delete KFC'
      expect(page).not_to have_content 'KFC'
      expect(page).to have_content 'Restaurant deleted successfully'
    end

    scenario "user cannot edit or delete a restaurant he hasn't created" do
      User.create(  email: 'another_user@test.com',
                    password: 'another_test',
                    password_confirmation: 'another_test',
                    id: 2)
      another_restaurant = Restaurant.create( name: 'Square Pie',
                                              user_id: 2)
      visit "/restaurants/#{another_restaurant.id}"
      expect(page).not_to have_content 'Edit Square Pie'
      expect(page).not_to have_content 'Delete Square Pie'
      visit "/restaurants/#{another_restaurant.id}/edit"
      expect(page).to have_content "You cannot edit a restaurant you haven't created"
      expect(page).not_to have_content 'Update Restaurant'
      page.driver.delete("/restaurants/#{another_restaurant.id}")
      visit '/restaurants'
      expect(page).to have_content "Square Pie"
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