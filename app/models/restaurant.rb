class Restaurant < ActiveRecord::Base

  has_many :reviews, dependent: :destroy

  belongs_to :user

  validates :name, length: {minimum: 3}, uniqueness: true

  has_attached_file :image,
                    :styles => { :medium => "300x300", :thumb => "100x100" },
                    :default_url => "/images/:style/missing.png",
                    :s3_host_name => 's3-us-west-2.amazonaws.com'

  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\z/

  attr_accessor :image_file_name

  def average_rating
    return 'N/A' if reviews.none?
    reviews.average(:rating)
  end

end
