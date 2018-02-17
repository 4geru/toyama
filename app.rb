require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require './models.rb'
require 'line/bot'
require './src/line'
require 'dotenv'
Dotenv.load

