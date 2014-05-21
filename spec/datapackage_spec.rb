require 'spec_helper'

describe Cid::Datapackage do

  it "recrates the original datapackage.rb" do
    datapackage = Cid::Datapackage.create(File.join(File.dirname(__FILE__), 'fixtures', 'valid'))

    JSON.parse(datapackage).should == JSON.parse(File.new(File.join(File.dirname(__FILE__), 'fixtures', 'valid', 'datapackage.json')).read)
  end

  it "creates a datapackage.rb with a new file" do
    datapackage = JSON.parse(Cid::Datapackage.create(File.join(File.dirname(__FILE__), 'fixtures', 'multiple_files')))

    datapackage["resources"].count.should == 2
    datapackage["resources"][1]["name"].should == "votes-2"
    datapackage["resources"][1]["path"].should == "votes/votes-2.csv"
    datapackage["resources"][1]["format"].should == "csv"
    datapackage["resources"][1]["mediatype"].should == "text/csv"
    datapackage["resources"][1]["bytes"].should == 1752
    datapackage["resources"][1]["schema"]["fields"].should == JSON.parse(File.new(File.join(File.dirname(__FILE__), 'fixtures', 'multiple_files', 'votes', 'schema.json')).read)["fields"]
  end

end
