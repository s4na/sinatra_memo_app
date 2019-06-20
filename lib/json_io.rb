# frozen_string_literal: true

require "json"

module Json
  class Io
    attr_reader :data

    def initialize(filename)
      @file_path = filename
    end

    # def data
    #   @data
    # end

    def read
      if ::File.exist?(@file_path)
        @initial_data = open(@file_path, "r") do |io|
          ::JSON.load(io)
        end
      end
      p "nilchech: @initial_data = #{@initial_data}" # debug
      if @initial_data.nil?
        p "no file to make @initial_data = {}" # debug
        @initial_data = {}
      end
      set_only_filename
      p "@initial_data = #{@initial_data}" # debug
      @data = @initial_data
    end

    def update(input)
      # 課題：input nil考慮
      # if @data.nil?
      #   @data = {}
      # end

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
      def set_only_filename
        # 問題：既に存在する場合どうなる？
        # 対策：saveにreject噛ませた
        only_file_name = File.basename(@file_path, ".json")
        p "only_file_name = #{only_file_name}" # debug
        p "@initial_data[\"file_name\"] = #{@initial_data["file_name"]}" # debug
        @initial_data[":file_name"] = only_file_name
      end

      def save
        # 問題点: 修正中に他のトランザクションで修正が行われたらデータが保護されない。上書きされる。

        if @data != {}
          p "delete before @data = #{@data}"
          p "@data.delete(\":file_name\") = #{@data.delete(":file_name")}"
          @data.delete(:file_name) # ファイル名だけ消す
          p "delete after @data = #{@data}"

          open(@file_path, "w") do |io|
            ::JSON.dump(@data, io)
          end
        end
        read
      end
  end
end

# fi = Json::Io.new("../data/4.json")
# p "read"
# fi.read

# p "show"
# p fi.data

# p "update"
# fi.update(title: "aaa", contents: "iii")

# p "show"
# p fi.data

# p "delete"
# fi.delete

# p "show"
# p fi.data
