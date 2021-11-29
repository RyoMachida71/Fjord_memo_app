# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'
require 'pg'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end
CONNECTION = PG.connect(host: 'localhost', user: 'postgres', password: 'Pu6kgmth', dbname: 'memos')
CONNECTION.freeze

def create_table
  CONNECTION.exec('CREATE TABLE IF NOT EXISTS memos_data (id TEXT PRIMARY KEY, title TEXT, content TEXT)')
end

def read
  CONNECTION.exec('SELECT * FROM memos_data')
end

def write(id, title, content)
  CONNECTION.exec("INSERT INTO memos_data (id, title, content) VALUES('#{id}', '#{title}', '#{content}')")
end

def get_record(id)
  CONNECTION.exec("SELECT * FROM memos_data WHERE id='#{id}'")
end

def rewrite(id, title, content)
  CONNECTION.exec("UPDATE memos_data SET (title, content) = ('#{title}', '#{content}') WHERE id = '#{id}'")
end

def delete(id)
  CONNECTION.exec("DELETE FROM memos_data WHERE id = '#{id}'")
end

get '/memos' do
  create_table
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
