# frozen_string_literal: true

require "sinatra"
# require "sinatra/base"
require "sinatra/reloader"
require_relative "./lib/file_list"
require_relative "./lib/json_io"


use Rack::MethodOverride

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

def set_files(path)
  fl = FileList.new
  fl.make(path)
  fl.list
end

def set_only_file_names(path)
  fl = FileList.new
  fl.make(path)
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
  files = set_files("./data")
  set_titles(files)
  erb :top
end

get "/" do
  show
end

get "/create" do
  filenames = set_only_file_names("./data")
  new_file_name = filenames.map(&:to_i).max + 1
  @id = new_file_name
  erb :create
end

get "/:id" do
  @id = params[:id]
  set_one_memo("./data/#{params[:id]}.json")
  @title = h(@one_memo["title"])
  @contents = h(@one_memo["contents"])
  erb :read
end

get "/:id/edit" do |id|
  @id = params[:id]
  set_one_memo("./data/#{params[:id]}.json")
  @title = h(@one_memo["title"])
  @contents = h(@one_memo["contents"])
  erb :edit
end

post "/" do
  # idは自分で決める
  filenames = set_only_file_names
  new_file_name = filenames.map(&:to_i).max + 1
  @id = new_file_name

  @title = params["title"]
  if @title == ""
    @title = "新しいメモ"
  end

  @contents = params["contents"]
  update_data("./data/#{@id}.json", title: @title, contents: @contents)
  show
end

patch "/:id" do |id|
  @id = params[:id]
  @title = params["title"]
  if @title == ""
    @title = "新しいメモ"
  end

  @contents = params["contents"]
  update_data("./data/#{@id}.json", title: @title, contents: @contents)
  show
end

delete "/:id" do |id|
  @id = params[:id]
  File.delete("./data/#{@id}.json")
  show
end
