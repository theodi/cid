require 'spec_helper'

describe Cid::Datapackage do

  context "when a schema is contained within a folder" do

    it "recrates the original datapackage.rb" do
      datapackage = Cid::Datapackage.new(File.join(File.dirname(__FILE__), 'fixtures', 'valid'))
      datapackage.create

      JSON.parse(datapackage.json).should == JSON.parse(File.read(File.join(File.dirname(__FILE__), 'fixtures', 'valid', 'datapackage.json')))
    end

    it "creates a datapackage.rb with a new file" do
      datapackage = Cid::Datapackage.new(File.join(File.dirname(__FILE__), 'fixtures', 'multiple_files'))
      datapackage.create

      package = JSON.parse(datapackage.json)

      package["resources"].count.should == 2
      package["resources"].flat_map(&:to_a).should include(["name", "votes-2"])
      package["resources"].flat_map(&:to_a).should include(["path", "votes/votes-2.csv"])
    end

  end

  context "when a schema is contained in the datapackage" do

    it "recrates the original datapackage.rb" do
      datapackage = Cid::Datapackage.new(File.join(File.dirname(__FILE__), 'fixtures', 'datapackage_valid'))
      datapackage.create

      JSON.parse(datapackage.json).should == JSON.parse(File.read(File.join(File.dirname(__FILE__), 'fixtures', 'valid', 'datapackage.json')))
    end

    it "creates a datapackage.rb with a new file" do
      datapackage = Cid::Datapackage.new(File.join(File.dirname(__FILE__), 'fixtures', 'multiple_files'))
      datapackage.create

      package = JSON.parse(datapackage.json)

      package["resources"].count.should == 2
      package["resources"].flat_map(&:to_a).should include(["name", "votes-2"])
      package["resources"].flat_map(&:to_a).should include(["path", "votes/votes-2.csv"])
    end

  end

end
