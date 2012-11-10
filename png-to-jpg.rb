#!/usr/bin/ruby

# /scale_images.rb images \
# --suffix -ipad \
# --replacement illustration \
# --extension .png \
# --destination images/output \
# --scale 30%"

require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "./scale_images.rb images \
                  --suffix -ipad \
                  --replacement illustration \
                  --extension .png \
                  --destination images/output \
                  --scale 30%"
  options[:usage] = opts.banner

  opts.on("-s", "--scale FLOAT", "Scale") do |s|
    options[:scale] = s
  end

  opts.on("-u", "--suffix STRING", "Suffix") do |u|
    options[:suffix] = u
  end

  opts.on("-t", "--replacement STRING", "Suffix to be replaced") do |u|
    options[:replacementSuffix] = u
  end

  opts.on("-e", "--extension STRING", "Extension to be targeted") do |u|
    options[:extension] = u
  end

  opts.on("-d", "--destination STRING", "Destination directory") do |d|
    options[:destination] = d
  end
end.parse!

def printUsageAndExit(options)
    puts "    " + options[:usage]
    puts "    --help for help"
    exit()
end

def validateOptions(options)
  if options[:scale].nil?
    puts "ERROR: scale required"
    printUsageAndExit(options)
  end

  if options[:extension].nil?
    puts "ERROR: extension required"
    printUsageAndExit(options)
  end

  if options[:suffix].nil?
    puts "ERROR: suffix required"
    printUsageAndExit(options)
  end

  if options[:destination]
    if !File.directory? options[:destination]
      puts "ERROR: #{options[:destination]} is not a directory"
      printUsageAndExit(options)
    end
  end

  if ARGV[0].nil?
    puts "ERROR: Directory not entered"
    printUsageAndExit(options)
  end
end



validateOptions(options)

#simplify the variable names
directoryName = ARGV[0]
extension = options[:extension]

replacementSuffix = options[:replacementSuffix] + extension if options[:replacementSuffix]
suffix = options[:suffix] + extension
#TODO: see if extension has period in it or not

#isolate files with given extension
files = Dir.entries(directoryName)
images = files.reject {|filename| !filename.match(extension)}

#replace suffixes
imagesHash = Hash.new
images.each do |file|
  renamedFile = file.dup;
  if replacementSuffix && file.match(replacementSuffix)
    renamedFile[replacementSuffix] = suffix
  elsif suffix
    renamedFile[extension] = suffix
  end
  imagesHash[file] = renamedFile
end

#convert that shit
imagesHash.each do |orig, renamed|
  if options[:destination]
    renamedPath = options[:destination] + "/" + renamed
  else
    renamedPath = directoryName + "/" + renamed
  end
  origPath = directoryName + "/" + orig

  command = "convert \"#{origPath}\" -scale #{options[:scale]} -interpolate bicubic \"#{renamedPath}\""
  puts command
  `#{command}`
end











