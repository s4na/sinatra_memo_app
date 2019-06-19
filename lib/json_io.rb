# frozen_string_literal: true

require "json"

module Json

  class Io
    attr_reader :json_data

    def initialize(filename)
      @file_path = filename
    end

    # def json_data
    #   @json_data
    # end

    def read
      if ::File.exist?(@file_path)
        @initial_json_data = open(@file_path, "r") do |io|
          ::JSON.load(io)
        end
      end
      @json_data = @initial_json_data
    end

    def update(data)
      if @json_data.nil?
        @json_data = {}
      end
      data.each do |key, value|
        @json_data[":#{key}"] = value
      end
      save
    end

    def delete
      @json_data = {}
      save
    end

    private

      def save
        # 問題点: 修正中に他のトランザクションで修正が行われたらデータが保護されない。上書きされる。

        if @json_data != {}
          open(@file_path, "w") do |io|
            ::JSON.dump(@json_data, io)
          end
        end
        read
      end
  end
end

fi = Json::Io.new("../data/2.json")
p "read"
fi.read

p "show"
p fi.json_data

p "update"
fi.update(name: "aaa", content: "iii")

p "show"
p fi.json_data

p "delete"
fi.delete

p "show"
p fi.json_data
