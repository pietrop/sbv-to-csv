require 'csv'
require 'timecode'

#run from terminal as $ ruby sbv_to_csv_v1.rb Captions.sbv
#converts sbv file from youtube into csv file, doing also timecode conversion using timecode gem. from ie 0:09:07.730 to  00:09:07:18


class Line
  attr_accessor :n, :tc_in, :tc_out, :text, :tc_in_converted, :tc_out_converted
    def initialize(tc_in, tc_out, text, n)
     @tc_in, @tc_out, @text,@n = tc_in, tc_out, text, n
    end

    def tc_convert(tc)
      if !tc.nil?
      Timecode.parse("0"+tc, fps = 25)
    end#if end
    end
end

=begin
#troubles in getting user input, but ideally would like to prompt for: reel, tc_meta, clip_name

print "what's the reel name in the metadata?"
reel = gets.chomp

print "what's TC start for this file in the metadata? \n ie 00:49:04:20 "
tc_meta = gets.chomp
print "what's filename of the clip? ie CC0027_01.MOV"
clip_name = gets.chomp
=end




#when running in terminal, writing $ ruby sbv_to_csv_v1.rb captions.sbv 
#this gets the  the terminal argument, as the name of the sbv file and puts it into filename variable
filename = ARGV.first

#initialize an empty array to collect text in, and a n counter for the line numbers
text_chunks =[]
n = 0

#the actual file, can now be opened into a variable I've called sbvfile
sbvfile = File.open(filename)


#get all the lines from the sbv file into a line array
lines =[]
sbvfile.each do |line|
  lines << line
end #end of sbvfile.each

#join all the lines into the array 
lines = lines.join

#create an array where every tc in, tc out, and text is in one element.
lines = lines.split("\n\n")
# puts lines.inspect

#setup to create a csv file with the same name of the sbv file
CSV.open( "#{filename.split('.')[0]}.csv", "wb") do |csv|
#give header/first row default names
csv << [ "N", "Time Code In", "Time Code Out", "Transcribed Speech" ]

#iterate over lines
lines.each do |l|
  n+=1
 #splitting at \n allow to isolate tc, and collect two block of texts
  tc, text1,text2 = l.split("\n")
  #work around when text2 is nil is to check for it and set it to space
    if text2.nil?
      text2 =" "
    end
    #add text togethere
    text = text1 + text2
    #divide tc into tc in and tc out
    tc_in,tc_out = tc.split(',')
    # puts tc_in
    # puts tc_out
    # puts text.inspect
    #using line object to create instance of line, to do the conversion of TC later on 
    ln = Line.new(tc_in, tc_out, text, n)
    # puts ln.inspect
 # puts ln.tc_convert(ln.tc_in)
 # puts ln.tc_in
# puts ln.tc_convert("0:09:07.730")

#creating CSV File
# using line object tc_convert method and passing in ln tc_in to get it re formatted from ie 0:09:07.730 to  00:09:07:18
csv << [ n, ln.tc_convert(ln.tc_in), ln.tc_convert(ln.tc_out), text ] #, reel.upcase, tc_meta.upcase, clip_name.upcase

#print preview in terminal
puts "#{n}\t|  #{ln.tc_convert(ln.tc_in)}  |  #{ln.tc_convert(ln.tc_out)}  |   #{text}\n"


end#close lines looping

end #close CSV

#print name of csv file saved
puts "csv file saved: " + "#{filename.split('.')[0]}.csv"
