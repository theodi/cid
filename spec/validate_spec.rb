require 'spec_helper'

describe Cid::Validation do

  it "validates a package with a single file in a single folder" do
    Csvlint::Validator.should_receive(:new).once.and_call_original

    validation = Cid::Validation.validate(File.join(File.dirname(__FILE__), 'fixtures', 'valid'))

    validation["votes/votes-1.csv"][:errors].should == []
    validation["votes/votes-1.csv"][:warnings].should == []
  end

  it "validates a package with multiple files in a single folder" do
    Csvlint::Validator.should_receive(:new).twice.and_call_original

    validation = Cid::Validation.validate(File.join(File.dirname(__FILE__), 'fixtures', 'multiple_files'))

    validation["votes/votes-1.csv"][:errors].should == []
    validation["votes/votes-1.csv"][:warnings].should == []
    validation["votes/votes-2.csv"][:errors].should == []
    validation["votes/votes-2.csv"][:warnings].should == []
  end

  it "validates a package with multiple files in multiple folders" do
    Csvlint::Validator.should_receive(:new).exactly(4).times.and_call_original

    validation = Cid::Validation.validate(File.join(File.dirname(__FILE__), 'fixtures', 'multiple_folders'))

    validation["votes/votes-1.csv"][:errors].should == []
    validation["votes/votes-1.csv"][:warnings].should == []
    validation["votes/votes-2.csv"][:errors].should == []
    validation["votes/votes-2.csv"][:warnings].should == []
    validation["seats/seats-1.csv"][:errors].should == []
    validation["seats/seats-1.csv"][:warnings].should == []
    validation["seats/seats-2.csv"][:errors].should == []
    validation["seats/seats-2.csv"][:warnings].should == []
  end

  it "returns errors for an invalid csv" do
    validation = Cid::Validation.validate(File.join(File.dirname(__FILE__), 'fixtures', 'invalid'))

    validation["votes/votes-1.csv"][:warnings].count.should == 1
    validation["votes/votes-1.csv"][:warnings].first.category.should == :schema
    validation["votes/votes-1.csv"][:warnings].first.column.should == 2
  end

  it "works if there is no schema" do
    Csvlint::Validator.should_receive(:new).once.and_call_original

    validation = Cid::Validation.validate(File.join(File.dirname(__FILE__), 'fixtures', 'no_schema'))

    validation["votes/votes-1.csv"][:errors].should == []
    validation["votes/votes-1.csv"][:warnings].should == []
  end

end
