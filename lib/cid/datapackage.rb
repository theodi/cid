require 'csvlint'
require 'json'

module Cid

  class Datapackage

    include Cid::Helpers::File

    attr_accessor :json

    def initialize(path)
      @path = path
      begin
        @datapackage = JSON.parse(File.new("#{@path}/datapackage.json").read)
      rescue
        return "No datapackage present!"
      end
    end

    def create
      # Clear out all the resources
      @datapackage["resources"] = []

      paths = Dir.glob("#{@path}/*/")

      paths.each do |path|
        schema = JSON.parse(File.new(Dir["#{path}/schema.json"][0]).read)

        Dir["#{path}*.csv"].each do |csv|
          @datapackage["resources"] << {
            name: File.basename(csv, ".csv"),
            path: csv.split("/").last(2).join("/"),
            format: "csv",
            mediatype: "text/csv",
            bytes: File.size(csv),
            schema: {
                fields: schema["fields"]
              }
          }
        end
      end

      @json = @datapackage.to_json
    end

    def write
      self.create if @json.nil?
      File.open("#{@path}/datapackage.json", 'w') { |f| f.write(@json) }
    end

    def publish(token = ENV['GITHUB_OAUTH_TOKEN'])
      git = Cid::Publish.new(@path, token)
      git.publish
    end

    def schema_for_file(file)
      path = clean_file(file)
      begin
        schema = @datapackage["resources"].select { |r| r["path"] == path }.first["schema"]
        Csvlint::Schema.from_json_table(nil, schema)
      rescue NoMethodError
        nil
      end
    end

  end

end
