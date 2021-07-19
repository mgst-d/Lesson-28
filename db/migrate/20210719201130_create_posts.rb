class CreatePosts < ActiveRecord::Migration[6.1]
  def change
  	create_table :posts do |t|
  		t.text :post
  		t.timestamps
  	end
  	create_table :comments do |t|
  		t.belongs_to :post
  		t.text :comment
  		t.timestamps
  	end
  	Post.create :post => 'Первый пост.'
  	Post.create :post => 'Второй пост'
  end
end
