#opens the file and puts togethere al the lines into a array
lines = File.readlines("captions.sbv")
# joins all the elements of the array lines into a text variable
text = lines.join

#substituting new line with a comma
remove_paragraph_break = text.gsub(/\n/, ',')

#cleans up comma redundancy
remove_doublecomma = remove_paragraph_break.gsub(/,,/, ', ')

#spaces out on its own line each timecode in, timecode out, and text from the following one.
sentences_in_one_line = remove_doublecomma.gsub(/, /, ", \n")


#text shown on terminal to reassure that it's working on it
puts 'exporting to csv...'

#this line below shows in the terminal the formatted output for preview, comment it out if you don't need to see it all in terminal
puts sentences_in_one_line

#this final line saves the output as a csv file, you can change the extension to .txt if you want to
File.open("transcriptions.csv", "w") do |f|
  f.puts sentences_in_one_line
end


puts 'export finished'
