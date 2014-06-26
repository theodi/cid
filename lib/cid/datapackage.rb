require 'csvlint'
require 'json'

module Cid

  class Datapackage

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

      paths = Dir.glob("#{@path}/*/")

      paths.each do |path|

        if File.file?("#{path}schema.json")
          schema = JSON.parse(File.new(Dir["#{path}schema.json"][0]).read)
        else
          schema = nil
        end

        Dir["#{path}*.csv"].each do |csv|
          ref = csv.split("/").last(2).join("/")

          schema = schema_for_file(ref, true) rescue nil if schema.nil?

          resource = {
            name: File.basename(csv, ".csv"),
            path: ref,
            format: "csv",
            mediatype: "text/csv",
            bytes: File.size(csv)
          }

          resource[:schema] = { fields: schema["fields"] } unless schema.nil?

          @datapackage["resources"].reject! { |r| r["path"] == ref }
          @datapackage["resources"] << resource
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

    def schema_for_file(path, json = false)
      begin
        schema = @datapackage["resources"].select { |r| r["path"] == path }.first["schema"]
        return Csvlint::Schema.from_json_table(nil, schema) if json === false
      rescue NoMethodError
        nil
      end
      return schema
    end

  end

end
