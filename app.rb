require "sinatra"
# require "sinatra/flash"
require_relative "models"

enable :sessions

get "/" do
  erb(:index)
end

# defines the /users index route
#   that loads the users index template
get "/users" do
  # loads all users from the database
  @users = User.all

  # utilizes the /views/users.erb template
  erb(:users)
end


get "/signup" do
  erb(:signup)
end

#   this route responds the /signup form
post "/signup" do
  # creates the user in the database as a new User
  user = User.create(
    username: params[:username],
    password: params[:password],
    first_name: params[:first_name],
    last_name: params[:last_name],
    email: params[:email],
  )

  # loads the user into the system
  # stores their user id in the session
  session[:user_id] = user.id

  # after logging the user in, redirect to the
  #   page where you can see all users
  redirect "/users"
end


get "/login" do
  erb(:login)
end
#   this route responds to the submission from the
#   /login form
post "/login" do
  # finds the user by their username
  #   entered in the form beforehand and stores it in user
  user = User.find_by(username: params[:username])
  # checks if:
  #   a) user exists
  #   b) users password matches the password in the system
  if user && user.password == params[:password]
    # if both conditions pass then log in the user
    session[:user_id] = user.id

    # display a message on the following page
    #   indicating the user has ben signed in
    flash[:info] = "You are now signed in"

    # redirect to the users index page
    redirect "/users"
  else
    # display a message on the following page
    #   indicating they could not be signed in but
    #   ambiguously
    flash[:error] = "There was a problem logging in"

    # redirect to the signup page so they can try again
    redirect "/signup"
  end
end

# define the signout / logout route
get "/logout" do
  # this line signs a user out
  #   because their user_id is now nil, when we check
  #   if the user_id is set in the session on the view
  #   we find that the view is will not load the code
  #   specific to logged in users
  session[:user_id] = nil

  # redirect back to the homepage
  redirect "/"
end