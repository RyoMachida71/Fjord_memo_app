# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

def load(_)
  File.open(FILE_PATH) { |f| JSON.load(f) }
end

def dump(memos)
  File.open(FILE_PATH, 'w') { |f| JSON.dump(memos, f) }
end

FILE_PATH = 'data/data.json'
FILE_PATH.freeze

get '/memos' do
  if File.exist?(FILE_PATH)
    @memos = load(FILE_PATH)
  else
    File.open(FILE_PATH, 'w') { |f| f.write('{}') }
  end
  @memos = load(FILE_PATH)
  erb :top
end

post '/memos' do
  @memos = load(FILE_PATH)
  @memos[SecureRandom.uuid] = { 'title' => params['title'], 'content' => params['content'] }
  dump(@memos)
  redirect to '/memos'
end

get '/memos/:id/details' do
  memos = load(FILE_PATH)
  @id = params[:id]
  @memo = memos[@id]
  erb :show
end

get '/new' do
  erb :new
end

get '/memos/:id/edit' do
  memos = load(FILE_PATH)
  @id = params[:id]
  @memo = memos[@id]
  erb :edit
end

patch '/memos/:id' do
  id = params[:id]
  @memos = load(FILE_PATH)
  @memos[id] = { 'title' => params['title'], 'content' => params['content'] }
  dump(@memos)
  redirect to '/memos'
end

delete '/memos/:id' do
  @memos = load(FILE_PATH)
  @memos.delete(params[:id])
  dump(@memos)
  redirect to '/memos'
end
