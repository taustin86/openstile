require 'rails_helper'

feature 'Shopper shares style preferences with retailer' do
  let(:shopper){ FactoryGirl.create(:shopper_user, first_name: 'Jane') }
  let(:retailer){ FactoryGirl.create(:retailer, name: 'ABC Boutique') }
  let!(:availability){ FactoryGirl.create(:standard_availability_for_tomorrow, retailer: retailer)}
  let!(:store_owner){ FactoryGirl.create(:retailer_user, retailer: retailer,
                                        email: 'me@myboutique.com', password: 'password',
                                        password_confirmation: 'password') }

  scenario 'and specifies no preferences' do
    seed_style_profile_options

    given_i_am_a_logged_in_user shopper
    when_i_navigate_to_my_style_profile
    when_i_save_my_style_profile
    when_i_schedule_a_dropin_with_retailer
    then_the_store_owner_should_know "No preferences specified"
  end

  scenario 'and specifies her size preferences' do
    seed_style_profile_options

    given_i_am_a_logged_in_user shopper
    when_i_navigate_to_my_style_profile
    when_i_set_my_top_sizes_as ['2 (XS)', '4 (S)']
    when_i_set_my_bottom_sizes_as ['8 (M)']
    when_i_set_my_dress_sizes_as ['6 (S)', '8 (M)']
    when_i_save_my_style_profile
    when_i_schedule_a_dropin_with_retailer
    then_the_store_owner_should_know "Tops\nSizes: 2 (XS), 4 (S)\nBottoms\n Sizes: 8 (M)\nDresses\nSizes: 6 (S), 8 (M)"
  end

  scenario 'and specifies her build' do
    seed_style_profile_options

    given_i_am_a_logged_in_user shopper
    when_i_navigate_to_my_style_profile
    when_i_set_my_build_as ['Petite', 'Curvy']
    when_i_save_my_style_profile
    when_i_schedule_a_dropin_with_retailer
    then_the_store_owner_should_know "Build considerations: Petite, Curvy\n"
  end

  scenario 'and specifies her body shape' do
    seed_style_profile_options

    given_i_am_a_logged_in_user shopper
    when_i_navigate_to_my_style_profile
    when_i_set_my_body_shape_as 'Hourglass'
    when_i_save_my_style_profile
    when_i_schedule_a_dropin_with_retailer
    then_the_store_owner_should_know "Body shape: Hourglass"
    expect(page).to have_xpath("//img[@alt='Hourglass']")
  end

  scenario 'and specifies her budget' do
    seed_style_profile_options

    given_i_am_a_logged_in_user shopper
    when_i_navigate_to_my_style_profile
    when_i_set_my_top_budget_as 'max $50'
    when_i_set_my_bottom_budget_as 'max $150'
    when_i_set_my_dress_budget_as '$200 +'
    when_i_save_my_style_profile
    when_i_schedule_a_dropin_with_retailer
    then_the_store_owner_should_know "Tops\nBudget: max $50\nBottoms\nBudget: max $150\nDresses\nBudget: $200 +"
  end

  scenario 'and specifies her favorite looks' do
    seed_style_profile_options

    given_i_am_a_logged_in_user shopper
    when_i_navigate_to_my_style_profile
    when_i_select_as_a_loved_look ['Hipster1']
    when_i_save_my_style_profile
    when_i_schedule_a_dropin_with_retailer
    then_the_store_owner_should_know 'Loved looks:'
    expect(page).to have_xpath("//img[@alt='Hipster1']")
  end

  scenario 'and specifies what is important to her' do
    seed_style_profile_options

    given_i_am_a_logged_in_user shopper
    when_i_navigate_to_my_style_profile
    when_i_select_as_important ['Ethically-made', 'Made in USA']
    when_i_save_my_style_profile
    when_i_schedule_a_dropin_with_retailer
    then_the_store_owner_should_know "Values: Made in USA, Ethically-made\n"
  end

  scenario 'and specifies how she likes her clothes to fit' do
    seed_style_profile_options

    given_i_am_a_logged_in_user shopper
    when_i_navigate_to_my_style_profile
    when_i_select_my_top_fit_preference_as 'Oversized'
    when_i_select_my_bottom_fit_preference_as 'Tight'
    when_i_save_my_style_profile
    when_i_schedule_a_dropin_with_retailer
    then_the_store_owner_should_know "Tops\nFit: Oversized\nBottoms\nFit: Tight"
  end

  scenario 'and specifies her coverage preferences' do
    seed_style_profile_options

    given_i_am_a_logged_in_user shopper
    when_i_navigate_to_my_style_profile
    when_i_choose_to_flaunt ['Arms', 'Legs']
    when_i_choose_to_downplay ['Midsection']
    when_i_save_my_style_profile
    when_i_schedule_a_dropin_with_retailer
    then_the_store_owner_should_know "Parts to flaunt: Arms, Legs\nParts to downplay: Midsection"
  end

  scenario 'and specifies colors she avoids' do
    seed_style_profile_options

    given_i_am_a_logged_in_user shopper
    when_i_navigate_to_my_style_profile
    when_i_select_palettes_i_avoid ['Beiges']
    when_i_save_my_style_profile
    when_i_schedule_a_dropin_with_retailer
    then_the_store_owner_should_know "Colors to avoid: Beiges\n"
  end

  scenario 'and changes her preferences' do
    seed_style_profile_options

    given_i_am_a_logged_in_user shopper
    when_i_navigate_to_my_style_profile
    when_i_select_random_sampling_options_1
    when_i_save_my_style_profile
    when_i_schedule_a_dropin_with_retailer
    then_the_store_owner_should_know_random_sampling_options_1

    given_i_am_a_logged_in_user shopper
    when_i_navigate_to_my_style_profile
    when_i_change_my_preferences_to_random_sampling_options_2
    click_button 'Save'
    then_the_store_owner_should_know_random_sampling_options_2
  end

  def when_i_navigate_to_my_style_profile
    click_link 'Style Profile'
  end

  def when_i_set_my_top_sizes_as sizes
    within(:css, '.top_sizes') do
      sizes.each{|size| check size}
    end
  end

  def when_i_set_my_bottom_sizes_as sizes
    within(:css, '.bottom_sizes') do
      sizes.each{|size| check size}
    end
  end

  def when_i_set_my_dress_sizes_as sizes
    within(:css, '.dress_sizes') do
      sizes.each{|size| check size}
    end
  end

  def when_i_set_my_build_as builds
    within(:css, '.build') do
      builds.each{|build| check build}
    end
  end

  def when_i_set_my_body_shape_as shape
    choose shape
  end

  def when_i_set_my_top_budget_as amount
    select amount, from: 'A shirt, blouse, or sweater'
  end

  def when_i_set_my_bottom_budget_as amount
    select amount, from: 'A pair of pants, jeans, or a skirt'
  end

  def when_i_set_my_dress_budget_as amount
    select amount, from: 'An everyday, work, or transitional dress'
  end

  def when_i_select_as_a_loved_look looks
    looks.each{|look|
      id = page.find(:xpath, "//img[@alt='#{look}']/..")['data-id']
      check id
    }
  end

  def when_i_select_as_important values
    values.each{|value| check value}
  end

  def when_i_select_my_top_fit_preference_as fit
    select fit, from: 'Top fit'
  end

  def when_i_select_my_bottom_fit_preference_as fit
    select fit, from: 'Bottom fit'
  end

  def when_i_choose_to_flaunt parts
    within(:css, '.flaunt') do
      parts.each{|part| check part}
    end
  end

  def when_i_choose_to_downplay parts
    within(:css, '.cover') do
      parts.each{|part| check part}
    end
  end

  def when_i_select_palettes_i_avoid palettes
    palettes.each{|palette|
      id = page.find(:xpath, "//img[@alt='#{palette}']/..")['data-id']
      check id
    }
  end

  def when_i_save_my_style_profile
    click_button 'Save'
    expect(page).to have_text('SHOP LIKE A VIP')
  end

  def when_i_schedule_a_dropin_with_retailer
    click_link 'Boutiques'
    click_link 'ABC Boutique'
    fill_in 'Date', with: 1.day.from_now.strftime('%Y-%m-%d')
    fill_in 'Time', with: '10:00:00'
    click_button 'Book session'
  end

  def then_the_store_owner_should_know style_synopsis
    click_link 'Log out'
    visit '/users/sign_in'
    fill_in 'Email', with: 'me@myboutique.com'
    fill_in 'Password', with: 'password'
    click_button 'Log in'
    click_link 'View my bookings'
    expect(page).to have_text('Jane Tomorrow @ 10 AM')
    expect(page).to have_text(style_synopsis)
  end

  def when_i_select_random_sampling_options_1
    when_i_set_my_top_sizes_as ['2 (XS)']
    when_i_set_my_dress_budget_as '$200 +'
    when_i_select_my_bottom_fit_preference_as 'Tight'
    when_i_set_my_build_as ['Petite', 'Curvy']
    when_i_set_my_body_shape_as 'Apple'
    when_i_choose_to_flaunt ['Arms']
    when_i_select_as_a_loved_look ['Hipster1', 'Girly2', 'Rocker3']
  end

  def when_i_change_my_preferences_to_random_sampling_options_2
    within(:css, '.top_sizes') do
      uncheck '2 (XS)'
      check '4 (S)'
    end
    when_i_select_my_bottom_fit_preference_as 'Tight' #TODO selenium wierdness forcing me to reselect this
    when_i_set_my_dress_budget_as 'max $150'
    when_i_set_my_dress_sizes_as ['6 (S)']
    when_i_select_as_important ['Made in USA']
    when_i_set_my_body_shape_as 'Straight'
    within(:css, '.flaunt') do
      uncheck 'Arms'
    end
    when_i_choose_to_downplay ['Arms']
    ['Hipster1', 'Girly2', 'Rocker3'].each{ |look|
      id = page.find(:xpath, "//img[@alt='#{look}']/..")['data-id']
      uncheck id
    }
    when_i_select_palettes_i_avoid ['Beiges', 'Pinks']
  end

  def then_the_store_owner_should_know_random_sampling_options_1
    preferences = <<EOF
Tops
Sizes: 2 (XS)
Bottoms
Fit: Tight
Dresses
Budget: $200 +
Build considerations: Petite, Curvy
Body shape: Apple
A description
Loved looks:
Parts to flaunt: Arms
EOF
    then_the_store_owner_should_know preferences
    expect(page).to have_xpath("//img[@alt='Hipster1']")
    expect(page).to have_xpath("//img[@alt='Girly2']")
    expect(page).to have_xpath("//img[@alt='Rocker3']")
  end

  def then_the_store_owner_should_know_random_sampling_options_2
    preferences = <<EOF
Tops
Sizes: 4 (S)
Bottoms
Fit: Tight
Dresses
Sizes: 6 (S)
Budget: max $150
Build considerations: Petite, Curvy
Body shape: Straight
A description
Values: Made in USA
Parts to downplay: Arms
Colors to avoid: Beiges, Pinks
EOF
    then_the_store_owner_should_know preferences
    expect(page).to_not have_xpath("//img[@alt='Hipster1']")
    expect(page).to_not have_xpath("//img[@alt='Girly2']")
    expect(page).to_not have_xpath("//img[@alt='Rocker3']")
  end
end