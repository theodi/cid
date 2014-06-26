module Cid::Helpers::File

  def clean_file(file)
    clean_file = file.gsub @path, ""
    clean_file.gsub! /^\//, ""
  end

end
