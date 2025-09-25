 Version = "2025-09-24"

require "./amis_reader"
require 'pry' # ; binding.pry
require 'fileutils'

begin  
  amis = AmisReader.new

  while (!File.exist?("C:\\temp\\end"))
    begin
      amis.run
      sleep 0.5
    rescue StandardError => e
      puts "Error in main loop: #{e.message}"
    end
  end

  puts "DONE"
  
  File.unlink("C:/temp/end")
rescue
  File.unlink("C:/temp/end")
  print "finish by inputting some character(s): "
  gets
end