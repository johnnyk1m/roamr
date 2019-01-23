require "sinatra/activerecord"
require "pg"

configure :development do
  set :database, {
    adapter: "postgresql",
    host: "localhost",
    database: "roamr",
    username: "postgres",
    password: "postgrespassword"
  }
end

configure :production do
  # this environment variable is auto generated/set by heroku
  #   check Settings > Reveal Config Vars on your heroku app admin panel
  set :database, ENV["DATABASE_URL"]
end

class User < ActiveRecord::Base
  # only one user can have their username
  validates_uniqueness_of :username
  has_many :posts, :dependent => :destroy
end

class Post < ActiveRecord::Base
  belongs_to :user
end