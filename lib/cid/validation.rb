require 'csvlint'

module Cid

  class Validation

    def self.validate(root_path, ignore = [])
      result = {}

      paths = Dir.glob("#{root_path}/*/")

      paths.each do |path|
        next if ignore.include?(path.split("/").last)

        if File.file?("#{path}schema.json")
          schema = Csvlint::Schema.load_from_json_table(File.new(Dir["#{path}schema.json"][0]))
        else
          schema = nil
        end

        Dir["#{path}*.csv"].each do |csv|
          ref = csv.split("/").last(2).join("/")

          schema = Cid::Datapackage.new(root_path).schema_for_file(ref) if schema.nil?

          validator = Csvlint::Validator.new(File.new(csv), nil, schema)

          result[ref] = {}

          result[ref][:errors] = validator.errors
          result[ref][:warnings] = validator.warnings
        end
      end

      result
    end

  end

end
