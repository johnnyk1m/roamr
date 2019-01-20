require "sinatra/activerecord"
require "pg"

  set :database, {
    adapter: "postgresql",
    database: "rumblr",
    username: "postgres",
    password: "postgrespassword"
  }

class User < ActiveRecord::Base
end

class Post < ActiveRecord::Base
end