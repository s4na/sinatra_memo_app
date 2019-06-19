# frozen_string_literal: true

module Json
  class Io
    def initialize(filename)
      @file_path = filename
    end

    def read
      @json_data = open(@file_path) do |io|
        JSON.load(io)
      end
    end

    def update(data)
      if @json_data.nil?
        @json_data = {}
      end
      data.each do |key, value|
        @json_data[":#{key}"] = value
      end
    end

    def show
      p @json_data
    end

    def delete
      @json_data = {}
    end

    def save
      if @json_data != {}
        open(@file_path, "w+") do |io|
          JSON.dump(@json_data, io)
        end
      end
    end
  end
end

fi = Json::Io.new("../data/1.json")
p "read"
fi.read

p "show"
fi.show

p "update"
fi.update(name: "aaa", content: "iii")

p "show"
fi.show
# p "delete"
# fi.delete

p "show"
fi.show

p "save"
fi.save
