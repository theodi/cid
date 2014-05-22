require 'base64'
require 'github_api'
require 'memoist'

module Cid::Helpers::Github

  extend Memoist

  GITHUB_REPO_REGEX = /github.com[:\/]([^\/]*)\/([^\.]*)/

  def github
    Github.new oauth_token: @oauth_token
  end
  memoize :github

  def user
    match = @git_url.match GITHUB_REPO_REGEX
    match ? match[1] : nil
  end
  memoize :user

  def repo
    match = @git_url.match GITHUB_REPO_REGEX
    match ? match[2] : nil
  end
  memoize :repo

  def default_branch
    repository = github.repos.get user, repo
    repository.default_branch
  end
  memoize :default_branch

  def latest_commit(branch_name)
    branch_data = github.repos.branch user, repo, branch_name
    branch_data['commit']['sha']
  end
  memoize :latest_commit

  def tree(branch)
    github.git_data.trees.get user, repo, branch
  end
  memoize :tree

  def blob_shas(branch, path)
    tree = tree branch
    Hash[tree['tree'].select{|x| x['path'] =~ /^#{path}$/ && x['type'] == 'blob'}.map{|x| [x.path, x.sha]}]
  end
  memoize :blob_shas

  def blob_content(sha)
    blob = github.git_data.blobs.get user, repo, sha
    if blob['encoding'] == 'base64'
      Base64.decode64(blob['content'])
    else
      blob['content']
    end
  end
  memoize :blob_content


  def create_blob(content)
    blob = github.git_data.blobs.create user, repo, "content" => content, "encoding" => "utf-8"
    blob['sha']
  end

  def add_blob_to_tree(sha, filename)
    tree = tree default_branch
    new_tree = github.git_data.trees.create user, repo, "base_tree" => tree['sha'], "tree" => [
      "path" => filename,
      "mode" => "100644",
      "type" => "blob",
      "sha" => sha
    ]
    new_tree['sha']
  end

  def commit(sha)
    parent = latest_commit(default_branch)
    commit = github.git_data.commits.create user, repo, "message" => "Updated datapackage.json [ci skip]",
              "parents" => [parent],
              "tree" => sha
    commit['sha']
  end

  def push(sha)
    branch = github.git_data.references.update user, repo, "heads/#{default_branch}", "sha" => sha
    branch['ref']
  end

end
