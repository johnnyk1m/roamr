require "sinatra"
require "sinatra/activerecord"
require_relative "./models"
require "sinatra/flash"

enable :sessions

get "/" do
  erb(:index)
end

# loads the users index template
get "/users" do
  # loads all users from database
  @users = User.all

  erb(:users)
end


get "/signup" do
  erb(:signup)
end

post "/signup" do
  # creates new User in database
  @user = User.create(
    username: params[:username],
    password: params[:password],
    first_name: params[:first_name],
    last_name: params[:last_name],
    email: params[:email],
  )

  # loads the user, stores user id in session
  session[:user_id] = user.id

  # after logging the user in, redirect to the
  #   page where you can see all users
  redirect "/users"
end


get "/login" do
  erb(:login)
end

post "/login" do
  user = User.find_by(username: params[:username])
  
  if user && user.password == params[:password]
    
    session[:user_id] = user.id

    # display a sign-in message
    flash[:info] = "You are now signed in"

    # redirect to the users index page
    redirect "/"
  else
    # display error
    flash[:error] = "There was a problem logging in"

    # redirect to the signup page so they can try again
    redirect "/signup"
  end
end

get "/logout" do
  # erb(:logout)

  # signs user out: user_id is nil 
  session[:user_id] = nil

  # redirect back to the homepage
  redirect "/"
end