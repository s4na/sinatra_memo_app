# frozen_string_literal: true

require "json"

module Json
  class Io
    attr_reader :data, :full_data

    def initialize(filename)
      @file_path = filename
    end

    def read
      p "Json::Io.read" # debug
      if ::File.exist?(@file_path)
        p "@file_path = " # debug
        p @file_path # debug
        @initial_data = open(@file_path, "r") do |io|
          ::JSON.load(io)
        end
      end
      # p "nilchech: @initial_data = #{@initial_data}" # debug
      if @initial_data.nil?
        # p "no file to make @initial_data = {}" # debug
        @initial_data = {}
      end
      set_only_filename
      set_initial_data
      # set_data
      @data = @initial_data
      p "Json@data = " # debug
      pp @data # debug
      @data
    end

    def update(input)
      input.each do |key, value|
        @data["#{key}"] = value
      end
      save
    end

    def delete
      @data = {}
      save
    end

    private
      #  あとで消す
      def set_only_filename
        only_file_name = File.basename(@file_path, ".json")
        # p "only_file_name = #{only_file_name}" # debug
        # p "@initial_data[\"file_name\"] = #{@initial_data["file_name"]}" # debug
        @initial_data["file_name"] = only_file_name
      end

      def set_initial_data
        ::File.open(@file_path) do |j|
          @initial_data = ::JSON.load(j)
        end
      end

      def save
        if @data != {}
          # p "delete before @data = #{@data}" # debug
          # p "@data.delete(\"file_name\") = #{@data.delete(":file_name")}" # debug
          @data.delete("file_name") # ファイル名だけ消す
          # p "delete after @data = #{@data}" # debug

          open(@file_path, "w") do |io|
            ::JSON.dump(@data, io)
          end
        end
        read
      end
  end
end
