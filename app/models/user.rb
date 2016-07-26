class User < ActiveRecord::Base
  has_secure_password

  validates :name, presence: true
  validates :email, presence: true
  validates :country_code, presence: true
  validates :phone, presence: true
  validates :username, presence: true

end

