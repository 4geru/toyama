require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require './models.rb'
require 'line/bot'
require './src/line'
require 'sinatra/cross_origin'
require 'dotenv'
Dotenv.load

enable :cross_origin

options "*" do
  response.headers["Allow"] = "GET,POST"
  response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"
end

get '/date/:year/:month/:day' do
  cross_origin
  photos = Photo.where{
    DateTime.parse("#{params[:year]}/#{params[:month]}/#{params[:day]}") > created_at and
    created_at > DateTime.parse("#{params[:year]}/#{params[:month]}/#{params[:day].to_i-1}")
  }
  photos.to_json
end