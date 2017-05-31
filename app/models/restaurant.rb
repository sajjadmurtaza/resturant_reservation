class Restaurant < ActiveRecord::Base
  mount_uploader :image, ImageUploader

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable



  belongs_to :zip_code
  has_many :reservations

  scope :by_zip_code_id, lambda { |zip_code_id| where('zip_code_id = ?', zip_code_id) }

  def self.search(zip_code_id)
    restaurants = all
    restaurants = restaurants.by_zip_code_id(zip_code_id.to_i)
    restaurants

  end

end
