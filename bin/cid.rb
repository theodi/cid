#!/usr/bin/env ruby
$:.unshift File.join( File.dirname(__FILE__), "..", "lib")

require 'cid'
require 'colorize'

def print_error(index, error, color=:red)
  location = ""
  location += error.row.to_s if error.row
  location += "#{error.row ? "," : ""}#{error.column.to_s}" if error.column
  if error.row || error.column
    location = "#{error.row ? "Row" : "Column"}: #{location}"
  end
  puts "#{index+1}. #{error.type}. #{location}".colorize(color)
end

if ARGV[0] == "validate"

  if ARGV[1]
    source = ARGV[1]
  else
    source = "."
  end

  validation = Cid::Validation.validate(source)

  code = 0

  validation.each do |k,v|

    puts "#{k} is #{(v[:errors] + v[:warnings]).count == 0 ? "VALID".green : "INVALID".red}"

    if v[:errors].length > 0
      v[:errors].each_with_index do |error, i|
        print_error(i, error)
      end
    end

    if v[:warnings].length > 0
      v[:warnings].each_with_index do |error, i|
        print_error(i, error)
      end
    end

    code = 1 if (v[:errors] + v[:warnings]).count > 0

  end

  exit code

end
