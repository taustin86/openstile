class Shopper < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  VALID_CELL_PHONE_REGEX = /\A\d{10,11}\z/

  before_validation(on: :create) do
    cell_phone.gsub!(/[^0-9]/, "") if attribute_present?("cell_phone")
  end
  before_save { email.downcase! }                                    

  validates :first_name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 100 },
                                    format: { with: VALID_EMAIL_REGEX },
                                    uniqueness: { case_sensitive: false }
  validates :cell_phone, format: { with: VALID_CELL_PHONE_REGEX }, unless: "cell_phone.nil?"
end
