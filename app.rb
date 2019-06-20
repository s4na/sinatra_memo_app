# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require_relative "./lib/file_list"
require_relative "./lib/json_io"

use Rack::MethodOverride

def set_files
  fl = FileList.new
  fl.make("./data")
  # @titles = ["aaa", "bbb"]
  # p fl.list
  fl.list
end

def set_titles(files)
  @titles = []
  files.each do |f|
    # p "f = #{f}" # debug
    fi = Json::Io.new(f)
    # p "read" # debug
    fi.read
    # p fi.data # debug
    # p "add #{fi.data["title"]}" # debug

    # 問題：この書き方がよくない
    @titles.push(file_name: fi.data["file_name"], title: fi.data["title"])
  end
end

def set_data(file_path)
  # p "f = #{f}" # debug
  fi = Json::Io.new(file_path)
  # p "read" # debug
  fi.read
  p fi.data # debug
  # p "add #{fi.data["title"]}" # debug

  # 問題：この書き方がよくない
  @one_memo = fi.data
end

def update_data(file_path, in_data)
  fi = Json::Io.new(file_path)
  fi.read
  fi.update(in_data)
end

get "/" do
  # "top page"
  files = set_files
  p "files = #{files}" # debug
  set_titles(files)
  p @titles
  erb :top
end

get "/show/:id" do
  # 問題：この書き方はよくないので、後で修正する
  # 課題：@title必要？

  p "./data/#{params[:id]}.json" # debug
  set_data("./data/#{params[:id]}.json")
  p @one_memo # debug
  @title = @one_memo["title"]
  @contents = @one_memo["contents"]
  erb :show
end

get "/edit/:id" do |id|
  # 作業：editボタンが効いてない
  # 作業：PATCH化する
  # 作業：一部データしかなくても反映されるようにする

  # --- 検討：1つのデータ持ってくる定型文にするかも・
  set_data("./data/#{params[:id]}.json")
  p @one_memo # debug
  @title = @one_memo["title"]
  @contents = @one_memo["contents"]
  # ---

  @id = params[:id]
  erb :edit
end

patch "/update/:id" do |id|
  pp params # debug
  @id = params[:id]
  p "in = ./data/#{@id}.json" # debug

  @title = params["title"]
  @contents = params["contents"]
  p @title # debug
  p @contents # debug
  update_data("./data/#{@id}.json", title: params["title"], contents: params["contents"])
  erb :update
end

get "/show_delete/:id" do |id|
  @id = params[:id]
  erb :show_delete
end

delete "/delete/:id" do |id|
  # 検討：button formにする？（しないとajax必要だっけ？
  # 課題 @id から @idに変更したい
  # 作業：DELETEメソッドにする
  @id = params[:id]
  p "@id = ./data/#{@id}.json"
  File.delete("./data/#{@id}.json")
  erb :delete
end
