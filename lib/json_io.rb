# frozen_string_literal: true

require "json"

module Json
  class Io
    attr_reader :data

    def initialize(filename)
      @file_path = filename
    end

    def read
      set_initiali_data
      set_only_filename
      @data = @initial_data
    end

    def update(input)
      input.each { |key, value| @data["#{key}"] = value }
      save
    end

    def delete
      @data = {}
      save
    end

    private
      def set_initiali_data
        if ::File.exist?(@file_path)
          @initial_data = open(@file_path, "r") { |io| ::JSON.load(io) }
        end

        @initial_data = {} if @initial_data.nil?
      end

      def set_only_filename
        only_file_name = File.basename(@file_path, ".json")
        @initial_data["file_name"] = only_file_name
      end

      def save
        if @data != {}
          @data.delete("file_name")
          open(@file_path, "w") { |io| ::JSON.dump(@data, io) }
        end
        read
      end
  end
end
