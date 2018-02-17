require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require './models.rb'
require 'line/bot'
require 'dotenv'
require './src/line'
Dotenv.load

