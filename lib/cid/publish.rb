require 'git'

module Cid

  class Publish

    include Cid::Helpers::Github

    GITHUB_REPO_REGEX = /github.com[:\/]([^\/]*)\/([^\.]*)/

    def initialize(path, oauth_token)
      g = Git.open(path)
      @path = path
      @git_url = g.config["remote.origin.url"]
      @oauth_token = oauth_token
    end

    def publish
      name, content = "datapackage.json", File.read("#{@path}/datapackage.json")
      blob_sha = create_blob(content)
      tree_sha = add_blob_to_tree(blob_sha, name)
      commit_sha = commit(tree_sha)
      push(commit_sha)
    end

  end

end
