require "sinatra/activerecord"
require "pg"

  set :database, {
    adapter: "postgresql",
    host: "localhost",
    database: "roamr",
    username: "postgres",
    password: "postgrespassword"
  }

class User < ActiveRecord::Base
  # only one user can have their username
  validates_uniqueness_of :username
  has_many :posts
end

class Post < ActiveRecord::Base
  belongs_to :user
end