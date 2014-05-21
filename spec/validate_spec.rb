require 'spec_helper'

describe Cid::Validation do

  it "validates a package with a single file in a single folder" do
    Csvlint::Validator.should_receive(:new).once.and_call_original

    validation = Cid::Validation.validate(File.join(File.dirname(__FILE__), 'fixtures', 'valid'))

    validation[:errors]["votes/votes-1.csv"].should == []
    validation[:warnings]["votes/votes-1.csv"].should == []
  end

  it "validates a package with multiple files in a single folder" do
    Csvlint::Validator.should_receive(:new).twice.and_call_original

    validation = Cid::Validation.validate(File.join(File.dirname(__FILE__), 'fixtures', 'multiple_files'))

    validation[:errors]["votes/votes-1.csv"].should == []
    validation[:warnings]["votes/votes-1.csv"].should == []
    validation[:errors]["votes/votes-2.csv"].should == []
    validation[:warnings]["votes/votes-2.csv"].should == []
  end

  it "validates a package with multiple files in multiple folders" do
    Csvlint::Validator.should_receive(:new).exactly(4).times.and_call_original

    validation = Cid::Validation.validate(File.join(File.dirname(__FILE__), 'fixtures', 'multiple_folders'))

    validation[:errors]["votes/votes-1.csv"].should == []
    validation[:warnings]["votes/votes-1.csv"].should == []
    validation[:errors]["votes/votes-2.csv"].should == []
    validation[:warnings]["votes/votes-2.csv"].should == []
    validation[:errors]["seats/seats-1.csv"].should == []
    validation[:warnings]["seats/seats-1.csv"].should == []
    validation[:errors]["seats/seats-2.csv"].should == []
    validation[:warnings]["seats/seats-2.csv"].should == []
  end

  it "returns errors for an invalid csv" do
    validation = Cid::Validation.validate(File.join(File.dirname(__FILE__), 'fixtures', 'invalid'))

    validation[:warnings]["votes/votes-1.csv"].count.should == 1
    validation[:warnings]["votes/votes-1.csv"].first.category.should == :schema
    validation[:warnings]["votes/votes-1.csv"].first.column.should == 2
  end

end
