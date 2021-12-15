# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'pg'
require 'dotenv'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

Dotenv.load
CONNECTION = PG.connect(host: 'localhost', user: ENV['DB_USER'], password: ENV['DB_PASSWORD'], dbname: 'memos')
CONNECTION.freeze

def read
  CONNECTION.exec('SELECT * FROM memos_data')
end

def write(id, title, content)
  CONNECTION.exec('INSERT INTO memos_data (id, title, content) VALUES($1, $2, $3);', [id, title, content])
end

def get_record(id)
  CONNECTION.exec('SELECT * FROM memos_data WHERE id=$1;', [id])
end

def rewrite(id, title, content)
  CONNECTION.exec('UPDATE memos_data SET (title, content) = ($1, $2) WHERE id = $3;', [title, content, id])
end

def delete(id)
  CONNECTION.exec('DELETE FROM memos_data WHERE id = $1;', [id])
end

get '/memos' do
  @memos = read
  erb :top
end

post '/memos' do
  write(SecureRandom.uuid, params['title'], params['content'])
  @memos = read
  redirect to '/memos'
end

get '/memos/new' do
  erb :new
end

get '/memos/:id' do
  @memo = get_record(params['id'])
  erb :show
end

get '/memos/:id/edit' do
  @memo = get_record(params['id'])
  erb :edit
end

patch '/memos/:id' do
  @memo = rewrite(params['id'], params['title'], params['content'])
  redirect to '/memos'
end

delete '/memos/:id' do
  delete(params['id'])
  redirect to '/memos'
end
