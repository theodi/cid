require 'spec_helper'
require 'dotenv'

Dotenv.load

describe Cid::Publish, :vcr do

  before :each do
    tmpdir = Dir.mktmpdir
    Git.clone("https://github.com/theodi/cid-test.git", tmpdir)
    @remote = Cid::Publish.new(tmpdir, ENV['GITHUB_OAUTH_TOKEN'])
  end

  it "should be able to fetch the default branch for a repo" do
    @remote.default_branch.should == 'master'
  end

  it "should be able to get latest commit SHA on a branch" do
    @remote.latest_commit('master').should == '357b6cbb632a533bf20657975b6100a0b837b15c'
  end

  it "should be able to get a blob sha for a file on a branch" do
    @remote.blob_shas('master', 'datapackage.json').should == { "datapackage.json" => 'c22d8945fac6a4ce4be188002dcd09656bd85898' }
  end

  it "should be able to create a new blob" do
    blob_sha = @remote.create_blob('new blob content')
    blob_sha.should == '28b552e7359c5c3bbe947749aab70d18e3ea554b'
  end

  it "should be able to create a tree with the new blob in it given a filename" do
    tree_sha = @remote.add_blob_to_tree('28b552e7359c5c3bbe947749aab70d18e3ea554b', 'datapackage.json')
    tree_sha.should == 'f56a5cd26fa6c67ff51fcc4994ad9b1057e5095c'
  end

  it "should be able to create a new commit from a tree" do
    commit_sha = @remote.commit('f56a5cd26fa6c67ff51fcc4994ad9b1057e5095c')
    commit_sha.should == 'a2dcc1d78ea67007f87b19f07e01dddb8c73bef6'
  end

  it "should push to the default branch" do
    @remote.publish.should == "refs/heads/master"
  end

end
