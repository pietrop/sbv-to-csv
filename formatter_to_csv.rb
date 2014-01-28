require 'csv'
#opens the file , puts togethere all the lines into a array
#["0:00:00.570,0:00:05.060\nbecause I didn't see if there was little\nwould close with as well", "\n0:00:05.060,0:00:08.690\nthe that and mixtures", "\n0:00:08.690,0:00:10.900\nit",]
lines = File.readlines("captions.sbv")

# joins the elemnets of the array lines into one string as a variable.
# "0:00:00.570,0:00:05.060\nbecause I didn't see if there was little\nwould close with as well\n\n0:00:05.060,0:00:08.690\nthe that and mixtures\n\n0:00:08.690,0:00:10.900\nit\n"
text = lines.join

#sets a $ sign at the end of each line timecode in, timecode out, and text.
# "0:00:00.570,0:00:05.060\nbecause I didn't see if there was little\nwould close with as well$\n0:00:05.060,0:00:08.690\nthe that and mixtures$\n0:00:08.690,0:00:10.900\nit$\n"
isolate_lines = text.gsub(/\n$/, '$')

#back into an array, each line tc in tc out and text togethere into one element of the array
#["0:00:00.570,0:00:05.060\nbecause I didn't see if there was little\nwould close with as well", "\n0:00:05.060,0:00:08.690\nthe that and mixtures", "\n0:00:08.690,0:00:10.900\nit",]
lines = isolate_lines.split("$")


#creates csv file, names it transcriptions.csv and uses local variable csv to put things into it.
CSV.open("transcriptions.csv", "wb") do |csv|
#before the loop that fills in the csv file rows to set the first row titles
csv << [ "N", "Time Code In", "Time Code Out", "Transcribed Speech" ]
#sets line number count to zero 
n = 0

# uses collect rather then each, as collect modifies the array. and we loop through like this
=begin
 "0:00:00.570,0:00:05.060\nbecause I didn't see if there was little\nwould close with as well"
 "\n0:00:05.060,0:00:08.690\nthe that and mixtures"
 "\n0:00:08.690,0:00:10.900\nit"
=end 
array_of_lines = lines.collect do | line |

#to increment the count of lines each time ad 1 to n to increment for each iteration
n  = n.to_i + 1  

#for every line, creates a line array like this ["\n0:09:42.339", "0:09:46.970\nno and"] 
line_array=line.split(",")  

#tc_in to get first element of the line array string like "\n0:00:00.570" 
tc_in = line_array[0]
#remove the new line \n separation to show as "0:00:00.570" 
tc_in = tc_in.gsub(/\n/, '')

#isolate tc out and line array like this into a string "0:09:46.970\nno and" fyi array counts of elements starts from zero
line_array_tc_out_and_text = line_array[1]

#splits tc_out and text into array like this ["0:00:05.060", "because I didn't see if there was little", "would close with as well"] 
array_line_array_tc_out_and_text = line_array_tc_out_and_text.split("\n")

#gets tc out from array as string like this "0:00:05.060" 
tc_out = array_line_array_tc_out_and_text[0]

#gets text out as string, from array ["0:00:05.060", "because I didn't see if there was little", "would close with as well"] 
#like this "because I didn't see if there was little" 
text = array_line_array_tc_out_and_text[1..3]

#unite all text elements part of array into one string replacing separations with spaces
text = text.join(" ")


#save onto the csv file, each csv << is a new row, and because it's inside the loop it will save all the rows and number them
csv << [ n, tc_in, tc_out, text ]
  

#close loop
end
#close csv file
end 

#final sucesfull export notice
puts "export finished..."

