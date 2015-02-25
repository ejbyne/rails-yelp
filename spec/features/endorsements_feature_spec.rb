require 'rails_helper'

feature 'endorsing reviews' do

  let(:restaurant) { Restaurant.create(name: 'KFC') }

  before do
    visit('/')
    click_link('Sign up')
    fill_in('Email', with: 'test@example.com')
    fill_in('Password', with: 'testtest')
    fill_in('Password confirmation', with: 'testtest')
    click_button('Sign up')
    visit "/restaurants/#{restaurant.id}"
    click_link 'Review KFC'
    fill_in 'Thoughts', with: 'It was an abomination'
    select '1', from: 'Rating'
    click_button 'Leave Review'
  end

  scenario 'a user can endorse a review, which updates the review endorsement count', js: true do
    visit "/restaurants/#{restaurant.id}"
    click_link 'Endorse'
    expect(page).to have_content('1 endorsement')
  end

  scenario 'will display the correct number of endorsements', js: true do
    visit "/restaurants/#{restaurant.id}"
    click_link 'Endorse'
    click_link 'Endorse'
    expect(page).to have_content('2 endorsements')
  end

end