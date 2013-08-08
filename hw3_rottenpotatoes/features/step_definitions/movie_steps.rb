# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(:title => movie[:title], :release_date => movie[:release_date], :rating => movie[:rating])
  end
#  flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  first_element = page.body.index(e1)
  later_element = page.body.index(e2)
  first_element.should < later_element
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"
#
#When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
#  flunk "Unimplemented"
#end

Given /I check the following ratings: (.+)/ do |ratings|
  @checkboxes_checked = []
  ratings.split(',').each do |rating|
    rating = rating.strip
    @checkboxes_checked.push(rating)
    check("ratings_"+rating)
  end
end

Then /^uncheck all other checkboxes/ do
  all_ratings = Movie.all_ratings
  checkboxes_uncheck = all_ratings - @checkboxes_checked
  checkboxes_uncheck.each do |checkbox|
    uncheck("ratings_"+checkbox)
  end
end

Then /I should see the correct movies/ do
  all_movies = Movie.all
  visible_movies = []
# iterate over chosen ratings, fetch movies with this ratings
# from databse and check if this movies are visible on page
  @checkboxes_checked.each do |rating|
    correct_movies = Movie.where(rating: rating)
    correct_movies.each do |movie|
      step "I should see \"#{movie[:title]}\""
      visible_movies << movie
    end
  end
# get the difference from all movies and movies with chosen
# ratings, these movies should not be visible
    movies_not_visible = all_movies - visible_movies
    movies_not_visible.each do |movie|
      step "I should not see \"#{movie[:title]}\""
    end
end

Then /I should see all of the movies/ do
  all_movies = Movie.all
  all_movies.each do |movie|
    step "I should see \"#{movie[:title]}\""
  end
end
