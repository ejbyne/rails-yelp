require 'rails_helper'

describe ReviewsHelper, :type => :helper do

  context '#star_rating' do

    it 'does nothing for not a number' do
      expect(helper.star_rating('N/A')).to eq 'N/A'
    end

    it 'returns five black stars for a rating of five' do
      expect(helper.star_rating(5)).to eq '★★★★★'
    end

    it 'returns three black stars and two white stars for three' do
      expect(helper.star_rating(3)).to eq '★★★☆☆'
    end

    it 'returns four black stars and one white star for 3.5' do
      expect(helper.star_rating(3.5)).to eq '★★★★☆'
    end

  end

  # context 'time created' do

  #   it 'does nothing for no reviews' do
  #     expect(helper.time_created('0')).to eq '0'
  #   end

  #   it 'tells the time created for a review' do
  #     expect(helper.time_created())
  #   end
    
  # end

end
