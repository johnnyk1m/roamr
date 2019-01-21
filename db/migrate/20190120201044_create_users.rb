class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |user|
      user.string :username
      user.string :password
      user.string :first_name
      user.string :last_name
      user.string :email
      user.datetime :created_at
    end
  end
end
