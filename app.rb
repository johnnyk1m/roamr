require "sinatra"
require "sinatra/activerecord"
require_relative "./models"
require "sinatra/flash"

enable :sessions

get "/" do
  user = User.find_by(username: params[:username])
  if session[:user_id].nil?
    erb(:index)
  else
    user = User.find(session[:user_id])
    posts = Post.all.limit(20).reverse
  end
    erb(:index)
end

get "/signup" do
  erb(:signup)
end

post "/signup" do
  # creates new User in database
  user = User.create(
    username: params[:username],
    password: params[:password],
    first_name: params[:first_name],
    last_name: params[:last_name],
    email: params[:email],
  )

  # loads the user, stores user id in session
  session[:user_id] = user.id
  flash[:signup] = "You are now signed up as @user.username."
  # after logging the user in, redirect to the
  #   page where you can see all users
  redirect "/"
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

    redirect "/login"
  end
end

get "/logout" do

  # signs user out: user_id is nil 
  session[:user_id] = nil
  # flash[:signout] = "You have been signed out"

  # redirect "/logout"
  erb(:logout)
end

# loads the users index template
get "/users" do
  # loads all users from database
  # @users = User.all

  erb(:users)
end

get "/delete_account" do

  # find current user_id and deletes it
  user = User.find(session[:user_id])
  User.destroy(session[:user_id])
  session[:user_id] = nil
  flash[:warning] = "Account: #{user.username} has been destroyed."

  redirect "/"
end