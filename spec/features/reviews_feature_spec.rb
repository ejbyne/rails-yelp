require 'rails_helper'

feature 'reviewing'  do

  before do
    Restaurant.create name: 'KFC'
    visit('/')
    click_link('Sign up')
    fill_in('Email', with: 'test@example.com')
    fill_in('Password', with: 'testtest')
    fill_in('Password confirmation', with: 'testtest')
    click_button('Sign up')
    leave_review('so so', '3')
  end

  scenario 'allows users to leave a review using a form' do
    expect(current_path).to eq '/restaurants'
    expect(page).to have_content('so so')
  end

  scenario 'user cannot leave more than 1 review per restaurant' do
    visit '/restaurants'
    click_link 'Review KFC'
    expect(page).to have_content('You cannot leave more than 1 review per restaurant')
  end

  scenario 'user can delete a review he has created' do
    visit '/restaurants'
    click_link "Delete this review"
    expect(page).to have_content("Review deleted successfully")
  end

  scenario "user cannot delete a review he hasn't created" do
    click_link('Sign out')
    another_user_sign_up
    visit '/restaurants'
    expect(page).not_to have_content 'Delete this review'

  end

  scenario 'average ratings' do
    click_link('Sign out')
    another_user_sign_up
    leave_review('Great', '5')
    expect(page).to have_content('Average rating: ★★★★☆')
  end

  # scenario 'time created' do
  #   leave_review('Great', '5')
  #   expect(page).to have_content('Review created: 1 hour ago')
  # end


  def leave_review(thoughts, rating)
    visit '/restaurants'
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
  
end
