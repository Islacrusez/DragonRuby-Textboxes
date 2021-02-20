def tick args # example of use
	args.state.text_size ||= -4			# change this and restart DR to change displayed and calculated text size
	args.state.text_font ||= "default"	# change this and restart DR to change displayed and calculated text font

	args.state.text ||= # change this text (internal " must be escaped \"), and restart DR to change displayed and calculated text

"# DragonRuby-Textboxes
Multiline textboxes for use with DragonRuby

DragonRuby by default does not suppport multi-line text boxes, and these must be constructed by hand from multiple single-line outputs.labels invocations. This repository provides a basic functionality for creation of textboxes, accepting a string that may or may not have linebreaks in it and converting it into an array of labels to be pushed directly into the output.

Please see main.rb comments for details and example usage.

The following method names are used by this repository:
tick (not required)
textbox, get_length, get_height, string_to_lines, list_to_lines

Usage:

Copy or require the code into your project, and call
Minimum:
args.outputs.labels << textbox(\"Text\", x, y, w)
where \"Text\" is the string you wish to turn into a textbox
x and y are the xy pixel coordinate of the top left corner of your textbox
and w is the width, in pixels, of the textbox you wish to create.

All supported:
args.outputs.labels << textbox(\"Text\", x, y, w, size, font)
In line with the .labels output and args.gtk.calcstringbox, textbox supports:
size (as a positive or negative integer, with default 0)
font (a string of the font name, default \"default\")

Logic suggestions, troubleshooting and other support has been kindly lent to this project by the DragonRuby Discord community. They're an awesome bunch and you should come visit sometime. We look forward to seeing your creations!"

	args.state.box_size ||= [20, 700, 200]	# change this and restart DR to change target textbox size and location

	args.state.text_box ||= textbox(args.state.text, *args.state.box_size, args.state.text_size, args.state.text_font)
	args.state.text_height ||= get_height(args.state.text, args.state.text_size, args.state.text_font) * args.state.text_box.length
	args.outputs.labels << args.state.text_box
	args.outputs.borders << [*args.state.box_size, args.state.text_height].anchor_rect(0,1)
end

=begin ## Textbox Method ##
#
# Requires, at minimum:
# String  - a string to be processed, may contain linebreaks
# x and y - x/y coordinate for the top left of the textbox
# w		  - the width, in pixels, of the intended textbox, used to calculate line splits
# 
# Accepts, optionally:
# size	  - the size, an integer for DR's outputs.label
# font	  - font, a string for DR's outputs.label
#
# Does not support (yet):
# h		  - the height of the textbox, in pixels, for automatic cutoff and scrolling textboxes
#
# Returns:
# An array of arrays suitable for pushing to outputs.label
=end

def textbox(string, x, y, w, size=0, font="default")	# <==<< # THIS METHOD TO BE USED
	text = string_to_lines(string, w, size, font)				# Accepts string and returns array of strings of desired length
	height_offset = get_height(string, size, font)				# Gets maximum height of any given line from the given string
	text.map!.with_index do |line, idx|							# Converts array of string into array suitable for
		[x, y - idx * height_offset, line, size, font]			# args.outputs.lables << textbox()
	end
end

def get_length(string, size=0, font="default")	# Internal method utilising calcstringbox to return string box length
	$gtk.args.gtk.calcstringbox(string, size, font).x
end

def get_height(string, size=0, font="default")	# Internal method utilising calcstringbox to return string box height
	$gtk.args.gtk.calcstringbox(string, size, font).y
end

def string_to_lines(string, box_x, size, font)
	return string unless get_length(string, size, font) > box_x
	string.gsub!("\r", '')										# Removes carriage returns, leaving only line breaks
	strings_with_linebreaks = string.split("\n")				# splits string into array at linebreak
	list_of_strings = strings_with_linebreaks.map do |line| 
		next if line == ""										# Ignores blank strings, as caused by consecutive linebreaks
		line.split												# Splits strings into arrays of words at any whitespace
																# Results in nested array, [[],[]]!
	end
	list_to_lines(list_of_strings, box_x, size, font)
end

def list_to_lines(strings, box_x, size, font)
	line = ""													# Define string
	lines = []													# Define array
	strings.map!{|string| string << ""}.flatten!.pop			# Adds a blank 'word' to the end of each outer array, to trigger newline code
	strings.each do |word|
		if word.empty? || !word									# Handling of blank 'words' and Nil entries in arrays 
			lines.push line.dup unless line.empty?				# Adds existing accumulated words to the current line
			lines.push " " if line.empty?						# Adds a space if no words accrued
			line.clear											# Clears the accumulator
		elsif get_length(line + " " + word, size, font) <= box_x	# "If current word fits on the end of the current line, do"
			line << " " if line.length > 0						# Inserts a space into accumulator if the line isn't blank
			line << word										# Adds the current word to the accumulator
		else														# "If the word doesn't fit, instead do"
			lines.push line.dup									# Adds accumulator to current line
			line.clear											# Clears accumulator
			line << word										# Adds current word to accumulator
		end
	end															# Once all words in all strings are processed
	lines.push line.dup											# Add accumulator to current line, as it's possible for accumulator to not have been committed
	return lines												# Return array of lines, explicitly to be safe.
end