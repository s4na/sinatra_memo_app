# frozen_string_literal: true

class FileList
  attr_reader :list, :only_file_names

  def initialize
    @list = []
    @only_file_names = []
  end

  def make(path)
    @list = Dir.glob("#{path}/*")
    @list.sort! { |a,b|
      File.basename(a, ".json").to_i <=> File.basename(b, ".json").to_i
    }

    @list.each do |file_path|
      @only_file_names.push(File.basename(file_path, ".json"))
    end
    @list
  end
end
