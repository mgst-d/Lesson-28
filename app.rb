#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
	@db = SQLite3::Database.new 'blog.db'
	@db.results_as_hash = true
end

before do
	init_db
end
configure do
	init_db
	@db.execute 'create table if not exists Posts 
		(
			id integer primary key,
			created_date date,
			content text
		)'
	@db.execute 'create table if not exists Comments 
		(
			id integer primary key,
			created_date date,
			content text,
			post_id integer
		)'
end
# кавычки возле имен столбцов можно не писать!!!


get '/' do
	@results = @db.execute 'select * from posts order by id desc'
	erb :index
end

get '/new' do
  erb :new
end

post '/new' do
	content = params[:content]
	if content.length <= 0
		@error = 'Вы ничего не ввели'
		return erb :new
	end
	@db.execute 'insert into posts (content, created_date) values (?, datetime())', [content]

	# => redirect to '/'
	erb "You typed: #{content}"
end

get '/details/:h' do

	# получаем переменную из url
	h = params[:h]

	@results = @db.execute 'select * from posts where id = ?', [h]
	
	erb :details
end

post '/details/:h' do
	h = params[:h]

	content = params[:content]
	@db.execute 'insert into comments
		(content, created_date, post_id)
		values (?, datetime(), ?)', [content, h]
	
	redirect to "/details/#{h}"
end