#!/usr/bin/ruby

require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "./png-to-jpg [--quality STRING] source-directory destination-directory"
  options[:usage] = opts.banner

  opts.on("-q", "--quality STRING", "JPG compression quality. Number 1 - 100.") do |d|
    options[:quality] = d
  end

end.parse!

def printUsageAndExit(options)
    puts "    " + options[:usage]
    puts "    --help for help"
    exit()
end

def validateOptions(options)
  # if options[:destination]
  #   if !File.directory? options[:destination]
  #     puts "ERROR: #{options[:destination]} is not a directory"
  #     printUsageAndExit(options)
  #   end
  # end

  if options[:quality].nil?
    puts "ERROR: quality required"
    printUsageAndExit(options)
  end

  if ARGV[0].nil?
    puts "ERROR: Directory not entered"
    printUsageAndExit(options)
  end

  if ARGV[1].nil?
    puts "ERROR: Destination not entered"
    printUsageAndExit(options)
  end
end



validateOptions(options)

#simplify the variable names
directoryName = ARGV[0]
destinationName = ARGV[1]

extension = ".png"
replacementExtension = ".jpg"

#isolate files with given extension
files = Dir.entries(directoryName)
images = files.reject {|filename| !filename.match(extension)}

#replace extensions
imagesHash = Hash.new
images.each do |file|
  renamedFile = file.dup;
  if file.match(extension)
    renamedFile[extension] = replacementExtension
  end
  imagesHash[file] = renamedFile
end

#convert that shit
imagesHash.each do |orig, renamed|
  renamedPath = destinationName + "/" + renamed
  origPath = directoryName + "/" + orig

  command = "convert -quality #{options[:quality]} \"#{origPath}\" \"#{renamedPath}\""
  puts command
  `#{command}`
end











