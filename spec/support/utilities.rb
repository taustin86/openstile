
def capybara_sign_in shopper
  visit '/users/sign_in'
  fill_in 'Email', with: shopper.email
  fill_in 'Password', with: shopper.password
  click_button 'Log in'
end

def style_profile_save
  'Save'
end

def tomorrow_morning
  ActiveSupport::TimeZone[Time.zone.name]
     .parse("#{1.day.from_now.change(hour: 9).to_s}")
end

def tomorrow_mid_morning
  ActiveSupport::TimeZone[Time.zone.name]
     .parse("#{1.day.from_now.change(hour: 10).to_s}")
end

def tomorrow_noon
  ActiveSupport::TimeZone[Time.zone.name]
     .parse("#{1.day.from_now.change(hour: 12).to_s}")
end

def tomorrow_afternoon
  ActiveSupport::TimeZone[Time.zone.name]
     .parse("#{1.day.from_now.change(hour: 13).to_s}")
end

def tomorrow_evening
  ActiveSupport::TimeZone[Time.zone.name]
     .parse("#{1.day.from_now.change(hour: 17).to_s}")
end
