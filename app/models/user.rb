class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :two_factor_authenticatable

  has_one_time_password

  def send_two_factor_authentication_code
    puts ">>>>>>>>>>>>>>> otp_secret_key: #{otp_secret_key}, otp_code: #{otp_code}"
    p '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'
  end

  def need_two_factor_authentication?(request)
    not otp_secret_key.nil?
  end

  has_many :reservations
  has_and_belongs_to_many :zip_codes
  has_many :restaurants, through: :zip_codes

end
