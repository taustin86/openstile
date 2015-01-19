def given_i_am_a_logged_in_shopper shopper
  capybara_sign_in shopper
end

def when_i_set_my_style_profile_sizes_to sizes
  click_link 'Style Profile'

  within(:css, "div#top_sizes") do
    check(sizes[:top_size].name)
  end
  within(:css, "div#bottom_sizes") do
    check(sizes[:bottom_size].name)
  end
  within(:css, "div#dress_sizes") do
    check(sizes[:dress_size].name)
  end
  click_button style_profile_save 

  expect(page).to have_content('My Style Feed')
end

def when_i_set_my_style_profile_budget_to budget
  click_link 'Style Profile'

  within(:css, "div#budgets") do
    select(budget[:dress], from: "A dress:")
    select(budget[:top], from: "A top or blouse:")
    select(budget[:bottom], from: "A pair of pants or jeans:")
  end

  click_button style_profile_save 

  expect(page).to have_content('My Style Feed')
end

def when_i_set_my_style_profile_feelings_for_a_look_as look, partiality
  click_link 'Style Profile'

  within(:css, "div#look_#{look.id}") do
    if partiality == :hate
      choose "I hate it!"
    end
    if partiality == :impartial
      choose "It's alright"
    end
    if partiality == :love
      choose "I love it!"
    end
  end
 
  click_button style_profile_save 

  expect(page).to have_content('My Style Feed')
end

def then_my_style_feed_should_not_contain recommendation
  visit '/'
  expect(page).to_not have_content(recommendation.name)
end

def then_my_style_feed_should_contain recommendation
  visit '/'
  expect(page).to have_content(recommendation.name)
end

def when_i_set_my_style_profile_body_shape_to body_shape
  click_link 'Style Profile'

  within(:css, "div.body-shape") do
    choose("style_profile_body_shape_id_#{body_shape.id}")
  end
 
  click_button style_profile_save 
  expect(page).to have_content('My Style Feed')
end

def when_i_set_my_style_profile_height_to height
  click_link 'Style Profile'

  feet = height.first if height.match(/^\d\sfeet/)

  within(:css, "div.height") do
    select feet, from: 'feet'
    select "0", from: 'inches'
  end

  click_button style_profile_save 
  expect(page).to have_content('My Style Feed')
end

def when_i_set_my_style_profile_body_build_to build
  click_link 'Style Profile'

  within(:css, "div.body-build") do
    select build, from: 'Build'
  end

  click_button style_profile_save 
  expect(page).to have_content('My Style Feed')
end

def when_i_set_my_style_profile_preferred_fit_as fit, type
  click_link 'Style Profile'

  within(:css, "div.fit") do
    if type == :top
      select fit, from: 'Top fit'
    end
    if type == :bottom
      select fit, from: 'Bottom fit'
    end
  end

  click_button style_profile_save 
  expect(page).to have_content('My Style Feed')
end

def when_i_set_my_style_profile_feelings_for_a_consideration_as consideration, importance
  click_link 'Style Profile'

  within(:css, "div.considerations") do
    if importance == :important
      check(consideration.name)
    end
    if importance == :not_important
      uncheck(consideration.name)
    end
  end

  click_button style_profile_save
  expect(page).to have_content('My Style Feed')
end

def when_i_set_my_style_profile_coverage_preference_as parts, tolerance
  click_link 'Style Profile'
 
  parts.each do |part|
    within(:css, "div#part_#{part.id}") do
      if tolerance == :cover
        choose "Cover"
      end
      if tolerance == :impartial
        choose "Mix it up"
      end
      if tolerance == :flaunt
        choose "Show off"
      end
    end
  end
 
  click_button style_profile_save 

  expect(page).to have_content('My Style Feed')
end

def then_the_recommendation_ordering_should_be higher_ranking, lower_ranking
  visit '/'
  expect(page.body.index(higher_ranking.name)).to be < (page.body.index(lower_ranking.name))
end

def then_the_recommendation_should_be_for recommendation_string
  visit '/'
  expect(page).to have_content("is recommended for #{recommendation_string}")
end


