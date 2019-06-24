# frozen_string_literal: true

require_relative "./json_io"

class FileList
  attr_reader :list, :only_file_names

  def initialize
    @list = []
    @only_file_names = []
  end

  def make(dir_path)
    p "FileList.make" # debug
    # @list = Dir.glob("#{dir_path}/*")
    # @list.sort! { |a, b|
    #   File.basename(a, ".json").to_i <=> File.basename(b, ".json").to_i
    # }


    make_list(dir_path)
    make_only_file_names



    p "FileList.@list = " # debug
    pp @list # debug
  end

  private
    def make_list(dir_path)
      # ファイル名
      paths = Dir.glob("#{dir_path}/*")

      p "FileList.paths = " # debug
      pp paths # debug

      datas = []
      paths.each do |file_path|
        # p file_path # debug
        f = Json::Io.new(file_path)
        f.read

        # p "f.data[\"file_name\"] = #{f.data["file_name"]}"
        datas.push(f.data)
      end

      @list = datas.sort_by { |a| a[:datetime] }

      # p "FileList.datas" # debug
      # pp datas # degbu
      p "FileList@list"
      pp @list

      # datas.each do |d|
      #   p "d = " # debug
      #   p d["title"] # debug
      #   @list.push(d)
      # end
    end

    def make_only_file_names
      @list.each do |data|
        file_path = data["file_name"]
        @only_file_names.push(File.basename(file_path, ".json"))
      end
      p "FileList.@only_file_names" # debug
      pp @only_file_names # debug
    end
end
