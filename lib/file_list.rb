# frozen_string_literal: true

class FileList
  attr_reader :list

  def initialize
    @list = []
  end

  def make(path)
    p "Dir.pwd = #{Dir.pwd}" # debug
    # 作成：pathの`/*`消す処理
    # 課題：絶対パスにする必要あるかも？？
    @list = Dir.glob("#{path}/*")
  end

  # debug def
  # def show
  #   p @list
  # end
end

# fl = FileList.new
# fl.make("../data")
