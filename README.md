# Yelp Clone (Ruby on Rails)

## Summary

This was our first Ruby on Rails project in Week 8 at Makers Academy. We built a Yelp clone application, which includes the following features:

- User sign up, sign in and sign out (including the option to sign in with Facebook)
- User can add a restaurant (if signed in)
- User can leave a review (if signed in, and only one review per user)
- User can only edit or delete a restaurant/review they've created
- User can endorse a review
- Restaurant page shows individual reviews and average rating
- Option to upload restaurant image (stored on AWS S3)

Through this project we learnt how to create and structure a Rails application using models, views and controllers, together with integrating a PostgreSQL database using the ActiveRecord ORM and unit and feature testing with RSpec and Capybara.

We used the Devise gem to set up a user authentication system, and also added the ability to sign in with Facebook using the Omniauth gem.

The live version of the website can be accessed [here](https://rails-yelp-clone.herokuapp.com).

## Technologies used

- Ruby
- Rails
- PostgreSQL
- ActiveRecord
- RSpec
- Capybara
- Gems: Devise, Omniauth, Paperclip
- ImageMagick
- AWS S3
- Bootstrap
- HTML
- CSS

## Screenshots

### Homepage
<img src="images/home_screenshot">

### Restaurant review page
<img src="images/del_screenshot">
