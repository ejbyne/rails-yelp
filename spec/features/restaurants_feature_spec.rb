require 'rails_helper'

feature 'restaurants' do

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

    before do
      Restaurant.create(name: 'KFC')
    end

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

    
    before { Restaurant.create(name: 'KFC') }

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

    before { Restaurant.create(name: 'KFC') }

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
    click_link 'Sign out'
    visit('/')
    click_link('Sign up')
    fill_in('Email', with: 'another_user@example.com')
    fill_in('Password', with: 'anotherpass')
    fill_in('Password confirmation', with: 'anotherpass')
    click_button('Sign up')
    click_link 'Add a restaurant'
    fill_in 'Name', with: 'Square Pie'
    click_button 'Create Restaurant'
    click_link 'Sign out'
  end

    scenario "user cannot edit a restaurant he hasn't created" do
      visit '/restaurants'
      click_link 'Edit Square Pie'
      expect(page).to have_content 'You cannot edit restaurants you have not created'
    end
  end
end





























