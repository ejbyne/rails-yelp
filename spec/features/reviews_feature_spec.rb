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
  end

  scenario 'allows users to leave a review using a form' do
    visit '/restaurants'
    click_link 'Review KFC'
    fill_in 'Thoughts', with: 'so so'
    select '3', from: 'Rating'
    click_button 'Leave Review'

    expect(current_path).to eq '/restaurants'
    expect(page).to have_content('so so')
  end

  scenario 'user cannot leave more than 1 review per restaurant' do
    visit '/restaurants'
    click_link 'Review KFC'
    fill_in 'Thoughts', with: 'so so'
    select '3', from: 'Rating'
    click_button 'Leave Review'
    visit '/restaurants'
    click_link 'Review KFC'
    expect(page).to have_content('You cannot leave more than 1 review per restaurant')
  end

  scenario 'average ratings' do
    leave_review('so so', '3')
    click_link('Sign out')
    visit('/')
    click_link('Sign up')
    fill_in('Email', with: 'testuser@example.com')
    fill_in('Password', with: 'testtest')
    fill_in('Password confirmation', with: 'testtest')
    click_button('Sign up')
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

end
