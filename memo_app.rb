# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require_relative "./lib/file_list"
require_relative "./lib/json_io"

class MemoApp < Sinatra::Base
  use Rack::MethodOverride
  DATAPASH = "./data"

  helpers do
    def h(text)
      Rack::Utils.escape_html(text)
    end
  end

  get "/" do
    show_top(DATAPASH)
  end

  get "/create" do
    erb :create, layout: :layout_edit
  end

  get "/:id" do |id|
    show_read(id)
  end

  get "/:id/edit" do |id|
    @id = id
    set_one_memo("./data/#{id}.json")
    @title = h(@one_memo["title"])
    @contents = h(@one_memo["contents"])
    erb :edit, layout: :layout_edit
  end

  post "/" do
    @id = new_id

    @title = params["title"]
    @title = "新しいメモ" if @title == ""

    @contents = params["contents"]
    update_data("./data/#{@id}.json")

    show_read(@id)
  end

  patch "/:id" do |id|
    @title = params["title"]
    @title = "新しいメモ" if @title == ""

    @contents = params["contents"]
    update_data("./data/#{id}.json")

    show_read(id)
  end

  delete "/:id" do |id|
    File.delete("./data/#{id}.json")
    show_top(DATAPASH)
  end

  private
    def set_one_memo(file_path)
      fi = Json::Io.new(file_path)
      fi.read
      @one_memo = fi.data
    end

    def show_top(path)
      files = set_files(path)
      set_titles(files)
      erb :top
    end

    def show_read(id)
      @id = id
      set_one_memo("./data/#{id}.json")
      @title = h(@one_memo["title"])
      @contents = h(@one_memo["contents"])
      erb :read
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

    def update_data(file_path)
      in_data = { title: @title, contents: @contents }
      fi = Json::Io.new(file_path)
      fi.read
      fi.update(in_data)
    end

    def new_id
      SecureRandom.uuid
    end
end

MemoApp.run!
