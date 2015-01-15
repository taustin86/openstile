class Dress < ActiveRecord::Base
  belongs_to :retailer
  has_and_belongs_to_many :dress_sizes

  validates :name, presence: true, length: { maximum: 100 } 
  validates :description, presence: true, length: { maximum: 250 }
  validates :web_link, length: { maximum: 100 }
  validates :price, presence: true
  validates :retailer_id, presence: true

  def self.within_budget budget, fuzz
    if budget.dress_min_price.nil? or budget.dress_max_price.nil?
      return none
    end
    where("price >= ? and price <= ?", budget.dress_min_price - fuzz,
                                       budget.dress_max_price + fuzz)
  end
end