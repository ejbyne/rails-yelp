require 'spec_helper'

RSpec.describe Restaurant, :type => :model do

  context 'invalid names' do

    it 'is not valid with a name less than three chraracters' do
      restaurant = Restaurant.new(name: 'kf')
      expect(restaurant).to have(1).error_on(:name)
      expect(restaurant).not_to be_valid
    end

    it 'is not valid unles it has a unique name' do
      Restaurant.create(name: "Moe's Tavern")
      restaurant = Restaurant.new(name: "Moe's Tavern")
      expect(restaurant).to have(1).error_on(:name)
    end

  end

  context 'restaurant reviews' do

    let(:restaurant) { Restaurant.create(name: 'The Ivy') }

    context 'no reviews' do
      it 'returns "N/A" when there are no reviews' do
        expect(restaurant.average_rating).to eq 'N/A'
      end
    end

    context 'one review' do
      it 'returns that rating' do
        restaurant.reviews.create(rating: 4)
        expect(restaurant.average_rating).to eq 4
      end
    end

    context 'multiple reviews' do
      it 'returns the average review rating' do
        restaurant.reviews.create(rating: 1)
        restaurant.reviews.create(rating: 5)
        expect(restaurant.average_rating).to eq 3
      end
    end

  end

end
