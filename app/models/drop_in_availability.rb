class DropInAvailability < ActiveRecord::Base
  ONE_TIME_FREQUENCY = "One-time"
  WEEKLY_FREQUENCY = "Weekly"
  DAILY_FREQUENCY = "Daily"

  belongs_to :retailer
  belongs_to :location
  
  validate :end_time_after_start_time
  validates :retailer_id, presence: true
  validates :template_date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :frequency, presence: true
  validates :bandwidth, presence: true
  validates :location_id, presence: true

  def end_time_after_start_time
    unless start_time.nil? or end_time.nil?
      if end_time < start_time
        errors.add(:end_time, "must be later than start time")
      end
    end
  end

  def covers_datetime? datetime
    if frequency == ONE_TIME_FREQUENCY
      if (template_date == datetime.to_date &&
          start_time.seconds_since_midnight <= datetime.seconds_since_midnight &&
          end_time.seconds_since_midnight > datetime.seconds_since_midnight)
        return true  
      end
    elsif frequency == WEEKLY_FREQUENCY
      if (template_date.wday == datetime.wday &&
          start_time.seconds_since_midnight <= datetime.seconds_since_midnight &&
          end_time.seconds_since_midnight > datetime.seconds_since_midnight)
        return true  
      end
    elsif frequency == DAILY_FREQUENCY
      if (start_time.seconds_since_midnight <= datetime.seconds_since_midnight &&
          end_time.seconds_since_midnight > datetime.seconds_since_midnight)
        return true  
      end
    end

    false
  end

  def covers_date? date
    if frequency == ONE_TIME_FREQUENCY
      if (template_date == date)
        return true  
      end
    elsif frequency == WEEKLY_FREQUENCY
      if (template_date.wday == date.wday)
        return true  
      end
    elsif frequency == DAILY_FREQUENCY
      return true  
    end

    false
  end

  def applied_start_and_end_times date
    [ActiveSupport::TimeZone[Time.zone.name].parse("#{date.to_s} #{start_time.strftime('%H:%M:%S')}"),
     ActiveSupport::TimeZone[Time.zone.name].parse("#{date.to_s} #{end_time.strftime('%H:%M:%S')}")]
  end

  def series_text 
    if frequency == WEEKLY_FREQUENCY
      return "Every #{template_date.strftime('%A')}"
    elsif frequency == DAILY_FREQUENCY
      return "Everyday"
    else
      return ""
    end
  end

  def turn_off_date_in_series date
    DropInAvailability.create!(template_date: date,
                               location: self.location,
                               retailer: self.retailer,
                               start_time: "00:00:00",
                               end_time: "23:59:59",
                               frequency: ONE_TIME_FREQUENCY,
                               bandwidth: 0)
  end
end
