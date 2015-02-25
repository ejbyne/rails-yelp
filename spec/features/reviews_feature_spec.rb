require 'rails_helper'

feature 'reviews'  do

  let(:restaurant) { Restaurant.create(name: 'KFC') }

  def leave_review(thoughts, rating)
    visit "/restaurants/#{restaurant.id}"
    click_link 'Review KFC'
    fill_in 'Thoughts', with: thoughts
    select rating, from: 'Rating'
    click_button 'Leave Review'
  end

  def another_user_sign_up
    visit('/')
    click_link('Sign up')
    fill_in('Email', with: 'anotheruser@example.com')
    fill_in('Password', with: 'testtest')
    fill_in('Password confirmation', with: 'testtest')
    click_button('Sign up')
  end

  before do
    visit('/')
    click_link('Sign up')
    fill_in('Email', with: 'test@example.com')
    fill_in('Password', with: 'testtest')
    fill_in('Password confirmation', with: 'testtest')
    click_button('Sign up')
    leave_review('so so', '3')
  end


  context 'leaving reviews' do

    scenario 'allows users to leave a review using a form' do
      visit "/restaurants/#{restaurant.id}"
      expect(page).to have_content('so so')
    end

    scenario 'user cannot leave more than 1 review per restaurant' do
      visit "/restaurants/#{restaurant.id}"
      click_link 'Review KFC'
      expect(page).to have_content('You cannot leave more than 1 review per restaurant')
    end

  end

  context 'deleting reviews' do

    scenario 'user can delete a review he has created' do
      visit "/restaurants/#{restaurant.id}"
      click_link "Delete this review"
      expect(page).to have_content("Review deleted successfully")
    end

    scenario "user cannot delete a review he hasn't created" do
      click_link('Sign out')
      another_user_sign_up
      visit "/restaurants/#{restaurant.id}"
      expect(page).not_to have_content 'Delete this review'
      page.driver.delete("/reviews/4")
      visit "/restaurants/#{restaurant.id}"
      expect(page).to have_content 'so so'
    end

  end

  context 'average ratings' do

    scenario 'displays average ratings' do
      click_link('Sign out')
      another_user_sign_up
      leave_review('Great', '5')
      expect(page).to have_content('Average rating: ★★★★☆')
    end

  end

  context 'time created' do

    scenario 'displays the time a review was created' do
      expect(page).to have_content('Review created: 0 hours ago')
    end

  end

end
