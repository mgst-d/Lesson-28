#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
require 'sinatra/activerecord'


# def init_db
# 	@db = SQLite3::Database.new 'blog.db'
# 	@db.results_as_hash = true
# end

# before do
# 	init_db
# end
# configure do
# 	init_db
# 	@db.execute 'create table if not exists Posts 
# 		(
# 			id integer primary key,
# 			created_date date,
# 			content text
# 		)'
# 	@db.execute 'create table if not exists Comments 
# 		(
# 			id integer primary key,
# 			created_date date,
# 			content text,
# 			post_id integer
# 		)'
# end
# кавычки возле имен столбцов можно не писать!!!
set :database, adapter: 'sqlite3', database: 'blogActiveRecord.db'

class Post < ActiveRecord::Base
	validates :post, presence: true
	has_many :comments
end
class Comment < ActiveRecord::Base
end

get '/' do
	@posts = Post.order "created_at desc"
	erb :index1
end
get '/new' do
		erb :new1
end
post '/new' do
	@new_post = Post.new params[:post_message]
	if !@new_post.save
	 	@error = 'Вы ничего не ввели'
 		return erb :new
  	end

 	erb "You typed: #{@new_post.post}"
end
get '/comments/:id' do
	@post_list = Post.find(params[:id])
	@c = Comment.all
	erb :details1
end
 post '/comments/:id' do
 	@post_list = Post.find(params[:id])
	@content = params[:content]
	@c = Comment.new
	@c.post_id = :id
	@c.comment = @content
	@c.save
	erb :details1
end
# get '/' do
# 	@results = @db.execute 'select * from posts order by id desc'
# 	erb :index
# end

# get '/new' do
#   erb :new
# end

# post '/new' do
# 	content = params[:content]
# 	if content.length <= 0
# 		@error = 'Вы ничего не ввели'
# 		return erb :new
# 	end
# 	@db.execute 'insert into posts (content, created_date) values (?, datetime())', [content]

# 	# => redirect to '/'
# 	erb "You typed: #{content}"
# end

# get '/details/:h' do

# 	# получаем переменную из url
# 	h = params[:h]

# 	@results = @db.execute 'select * from posts where id = ?', [h]
# 	@comments = @db.execute 'select *from comments where post_id = ?', [h]
# 	erb :details
# end

# post '/details/:h' do
# 	h = params[:h]

# 	content = params[:content]
# 	if content.length <= 0
# 		@error = 'Вы ничего не ввели'
# 	else
# 	@db.execute 'insert into comments
# 		(content, created_date, post_id)
# 		values (?, datetime(), ?)', [content, h]
# 	end
# 	@results = @db.execute 'select * from posts where id = ?', [h]
# 	@comments = @db.execute 'select *from comments where post_id = ?', [h]
# 	erb :details
# end