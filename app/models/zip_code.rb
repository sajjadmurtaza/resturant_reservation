class ZipCode < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :restaurants
end
