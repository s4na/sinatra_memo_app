# frozen_string_literal: true

class FileList
  attr_reader :list, :only_file_names

  def initialize
    @list = []
    @only_file_names = []
  end

  def make(path)
    p "Dir.pwd = #{Dir.pwd}" # debug
    # 作成：pathの`/*`消す処理
    # 課題：絶対パスにする必要あるかも？？
    @list = Dir.glob("#{path}/*")

    @list.each do |file_path|
      @only_file_names.push(File.basename(file_path, ".json"))
    end

    p "@only_file_names = #{@only_file_names}" # debug
    @list
  end
end

# fl = FileList.new
# fl.make("../data")
