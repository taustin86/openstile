class DropIn < ActiveRecord::Base
  Time::DATE_FORMATS[:month_slash_day] = "%_m#{'/'}%d"
  Time::DATE_FORMATS[:informal_time] = "%l:%M %p"

  belongs_to :retailer
  belongs_to :user

  validate :retailer_available_for_drop_in, on: :create
  validate :shopper_drop_in_at_same_time
  validates :retailer_id, presence: true
  validates :user_id, presence: true
  validates :time, presence: true
  validates :comment, length: {maximum: 250}
  validates :shopper_rating, numericality: { greater_than_or_equal_to: 1, 
                                             less_than_or_equal_to: 5 }, 
                             unless: "shopper_rating.blank?"
  validates :retailer_rating, numericality: { greater_than_or_equal_to: 1, 
                                             less_than_or_equal_to: 5 }, 
                             unless: "retailer_rating.blank?"
  validates :shopper_feedback, length: { maximum: 500 }
  validates :retailer_feedback, length: { maximum: 500 }
  validates :sales_generated, numericality: true, unless: "sales_generated.blank?"

  default_scope { order('time ASC') }

  scope :overlapping, ->(start_time, end_time) { where("time >= ? and time < ?", start_time, end_time) }

  def retailer_available_for_drop_in
    unless retailer.nil? || time.nil?
      unless retailer.available_for_drop_in?(time)
        errors.add(:time, "is not an available time slot for a drop in")
      end
    end
  end

  def shopper_drop_in_at_same_time
    unless user_id.nil? || time.nil?
      same_time_drop_in = DropIn.where(user_id: user_id, time: time).first
      unless same_time_drop_in.nil?
        if same_time_drop_in.id != self.id
          errors[:base] << "You have another drop-in scheduled at this time"
        end
      end
    end
  end

  def self.upcoming_for_shopper user_id
    where("user_id = ? and time > ?", user_id, DateTime.current)
  end

  def self.upcoming_for_retailer retailer_id
    where("retailer_id = ? and time > ?", retailer_id, DateTime.current)
  end

  def self.previous_for_shopper user_id
    where("user_id = ? and time < ?", user_id, DateTime.current)
  end

  def self.previous_for_retailer retailer_id
    where("retailer_id = ? and time < ?", retailer_id, DateTime.current.advance(minutes: 30))
  end

  def self.upcoming_for_shopper_at_retailer user_id, retailer_id
    where("user_id = ? and retailer_id = ? and time > ?",
                          user_id, retailer_id, DateTime.current)
  end

  def colloquial_time
    if time.to_date == DateTime.current.to_date
      date_string = "Today"
    elsif time.to_date == DateTime.current.advance(days: 1).to_date
      date_string = "Tomorrow"
    else
      date_string = time.to_s(:month_slash_day)
    end

    time_string = time.to_s(:informal_time)

    "#{date_string} @ #{time_string}".gsub(":00",'')
  end
end
