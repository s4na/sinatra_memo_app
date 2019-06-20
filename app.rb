# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require_relative "./lib/file_list"
require_relative "./lib/json_io"

use Rack::MethodOverride

def set_files
  fl = FileList.new
  fl.make("./data")
  fl.list
end

def set_only_file_names
  fl = FileList.new
  fl.make("./data")
  check_blank(fl.only_file_names)
end

def check_blank(input)
  input == [] ? ["0"] : input
end

def set_titles(files)
  @titles = []
  files.each do |f|
    fi = Json::Io.new(f)
    fi.read
    @titles.push(fi.data)
  end
end

def set_one_memo(file_path)
  fi = Json::Io.new(file_path)
  fi.read
  @one_memo = fi.data
end

def update_data(file_path, in_data)
  fi = Json::Io.new(file_path)
  fi.read
  fi.update(in_data)
end

def show
  files = set_files
  set_titles(files)
  erb :top
end

get "/" do
  show
end

get "/create" do
  filenames = set_only_file_names
  new_file_name = filenames.map(&:to_i).max + 1
  @id = new_file_name
  erb :create
end

get "/:id" do
  @id = params[:id]
  set_one_memo("./data/#{params[:id]}.json")
  @title = @one_memo["title"]
  @contents = @one_memo["contents"]
  erb :read
end

get "/:id/edit" do |id|
  @id = params[:id]
  set_one_memo("./data/#{params[:id]}.json")
  @title = @one_memo["title"]
  @contents = @one_memo["contents"]
  erb :edit
end

patch "/:id" do |id|
  @id = params[:id]
  @title = params["title"]
  @contents = params["contents"]
  update_data("./data/#{@id}.json", title: params["title"], contents: params["contents"])
  show
end

delete "/:id" do |id|
  @id = params[:id]
  File.delete("./data/#{@id}.json")
  show
end
