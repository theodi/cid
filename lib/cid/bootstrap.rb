module Cid
  class Bootstrap

    attr_accessor :no_remote

    def initialize(options)
      @branch = options[:branch]
      @github_token = options[:github_token]
    end

    def perform
      write
      if @github_token
        encrypt_token
      end
    end

    def encrypt_token
      output = `travis encrypt GITHUB_OAUTH_TOKEN=#{@github_token} --add`
      no_remote = true if output.match /Can't figure out GitHub repo name/
    end

    def write
      File.write(travis_yaml, yaml_string)
    end

    def travis_yaml(dir = Dir.pwd)
      path = File.expand_path('.travis.yml', dir)
    end

    def yaml_string
      {
        'before_script' => 'gem install cid',
        'script' => 'cid validate',
        'after_success' => "[ \"$TRAVIS_BRANCH\" == \"#{@branch}\" ] && [ \"$TRAVIS_PULL_REQUEST\" == \"false\" ] && cid publish"
      }.to_yaml(options = {line_width: -1})
    end

  end
end
