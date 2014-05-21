require 'csvlint'
require 'json'

module Cid

  class Datapackage

    def self.create(path)

      begin
        datapackage = JSON.parse(File.new("#{path}/datapackage.json").read)
      rescue
        return "No datapackage present!"
      end

      # Clear out all the resources
      datapackage["resources"] = []

      paths = Dir.glob("#{path}/*/")

      paths.each do |path|
        schema = JSON.parse(File.new(Dir["#{path}/schema.json"][0]).read)

        Dir["#{path}*.csv"].each do |csv|
          datapackage["resources"] << {
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

      datapackage.to_json
    end

  end

end
