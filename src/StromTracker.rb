 Version = "2025-09-24"

require "./amis_reader"
require 'pry' # ; binding.pry
require 'fileutils'

begin  
  amis = AmisReader.new

  while (!File.exist?("C:\\temp\\end"))
    amis.run
    sleep 0.5
  end

  puts "DONE"
  
  File.unlink("C:/temp/end")
rescue
  File.unlink("C:/temp/end")
end