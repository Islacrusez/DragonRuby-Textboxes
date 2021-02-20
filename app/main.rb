def tick args # example of use
	args.state.text_size ||= -4			# change this and restart DR to change displayed and calculated text size
	args.state.text_font ||= "default"	# change this and restart DR to change displayed and calculated text font

	args.state.text ||= # change this text (internal " must be escaped \"), and restart DR to change displayed and calculated text

"In Unity, to render a collection of sprites that fly across the screen and wrap around, you need to know about C#, static constructors,  classes, inheritance, MonoBehavior life cycles, GameObject instantiation, adding components/scripts through the IDE, Vector3, Quaternion.identity, Camera.main, transform, Time.deltaTime, how to create a prefab, and how to associate a sprite to a prefab using the ide. This doesn't include putting the current framerate on the screen.
	
The claim is \"this is how you should do it because it sets you up for success and a good architecture:::. Which isn't necessarily false, but I'm not ever going to get to that \"pit of success\" if I can't even get up and running.
It's like saying \"Oh don't use if/else statements, you should just go straight to using the strategy pattern. Every time.\" When in reality, understanding the Strategy Pattern includes the progression to the \"perfect\" solution: if/else statements, multiple if/elsif statements, consolidation of logic so case statements can be used, generalization of case statement to a Hash of Procs, then maybe the full blown strategy pattern"

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
# w       - the width, in pixels, of the intended textbox, used to calculate line splits
# 
# Accepts, optionally:
# size    - the size, an integer for DR's outputs.label
# font    - font, a string for DR's outputs.label
#
# Does not support (yet):
# h       - the height of the textbox, in pixels, for automatic cutoff and scrolling textboxes
#
# Returns:
# An array of arrays suitable for pushing to outputs.label
=end

def textbox(string, x, y, w, size=0, font="default")	# <==<<	# THIS METHOD TO BE USED
	text = string_to_lines(string, w, size, font)				# Accepts string and returns array of strings of desired length
	height_offset = get_height(string, size, font)				# Gets maximum height of any given line from the given string
	text.map!.with_index do |line, idx|							# Converts array of string into array suitable for
		[x, y - idx * height_offset, line, size, font]			# args.outputs.lables << textbox()
	end
end

def get_length(string, size=0, font="default") # Internal method utilising calcstringbox to return string box length
	$gtk.args.gtk.calcstringbox(string, size, font).x
end

def get_height(string, size=0, font="default") # Internal method utilising calcstringbox to return string box height
	$gtk.args.gtk.calcstringbox(string, size, font).y
end

def string_to_lines(string, box_x, size, font)
	return string unless get_length(string, size, font) > box_x
	string.gsub!("\r", '')                                      # Removes carriage returns, leaving only line breaks
	strings_with_linebreaks = string.split("\n")                # splits string into array at linebreak
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