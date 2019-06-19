# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"

use Rack::MethodOverride

get "/" do
  # "top page"
  @data = ["aaa", "bbb"]
  erb :top
end
