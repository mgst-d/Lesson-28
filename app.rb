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
end
# кавычки возле имен столбцов можно не писать!!!


get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
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
	erb "You typed: #{content}"
end
