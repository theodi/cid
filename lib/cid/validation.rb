require 'csvlint'

module Cid

  class Validation

    def self.validate(path)
      result = {}

      paths = Dir.glob("#{path}/**")

      paths.each do |path|
        begin
          schema = Csvlint::Schema.load_from_json_table(File.new(Dir["#{path}/schema.json"][0]))
        rescue
          schema = nil
        end

        Dir["#{path}/*.csv"].each do |csv|
          validator = Csvlint::Validator.new(File.new(csv), nil, schema)
          ref = csv.split("/").last(2).join("/")
          result[ref] = {}

          result[ref][:errors] = validator.errors
          result[ref][:warnings] = validator.warnings
        end
      end

      result
    end

  end

end
