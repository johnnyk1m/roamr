require "sinatra"
require "sinatra/activerecord"
require_relative "./models"
# require "sinatra/flash"

enable :sessions

get "/" do
  @user = User.find_by(username: params[:username])
  if session[:user_id].nil?
    erb(:index)
  else
    @user = User.find(session[:user_id])
    @posts = @user.posts.limit(20).reverse
  end
    erb(:index)
end

get "/users" do
  @user = User.all
  if @user
  erb(:users)

  else
  erb(:user_none)
  end
end

get "/user_post/:id" do
  @user = User.find(params[:id])
  @posts = @user.posts.limit(20).reverse
  if @posts.empty?
    erb :nopost
  else
    erb :user_post
  end
end

get '/create_post' do
  @user = User.find(session[:user_id])
  erb(:create_post)
end

post '/create_post' do
  @user = User.find(session[:user_id])
  @post = Post.create(
    user_id: @user.id,
    title: params[:title],
    post: params[:post]
  )
  redirect '/'
end

get '/delete_post/:id' do
  @user = User.find(session[:user_id])
  @post = Post.find(params[:id])
  @post.destroy

  redirect '/destroy_post'
end

get "/destroy_post" do
  erb(:destroy_post)
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
    birthday: params[:birthday],
    email: params[:email]
  )

  # stores user id in session
  session[:user_id] = @user.id

  # redirect after login
  redirect "/"
end


get "/login" do
  erb(:login)
end

post "/login" do
  user = User.find_by(username: params[:username])
  
  if user && user.password == params[:password]
    session[:user_id] = user.id

    redirect "/"
  else

    redirect "/login"
  end
end

get "/logout" do

  session[:user_id] = nil

  erb(:logout)
end

get "/delete_account/:id" do

  # find current user_id and delete it
  @user = User.find(session[:user_id])
  User.destroy(session[:user_id])
  session[:user_id] = nil

  redirect "/destroy"
end

get "/account" do
  @user = User.find(session[:user_id])
  if session[:user_id]
    erb(:account)
   end
end

get "/destroy" do
  erb(:destroy)
end