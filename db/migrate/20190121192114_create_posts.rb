class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |post|
      post.integer :user_id
      post.string :title
      post.string :post
      post.datetime :created_at
      post.datetime :updated_at
      post.references :users
    end
  end
end
