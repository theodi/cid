require 'spec_helper'

describe Cid::Datapackage do

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
    package["resources"][1]["name"].should == "votes-2"
    package["resources"][1]["path"].should == "votes/votes-2.csv"
    package["resources"][1]["format"].should == "csv"
    package["resources"][1]["mediatype"].should == "text/csv"
    package["resources"][1]["bytes"].should == 1752
    package["resources"][1]["schema"]["fields"].should == JSON.parse(File.new(File.join(File.dirname(__FILE__), 'fixtures', 'multiple_files', 'votes', 'schema.json')).read)["fields"]
  end

end
