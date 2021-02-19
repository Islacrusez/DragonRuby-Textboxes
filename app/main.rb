def tick args
	args.state.text_size ||= -4
	args.state.text_font ||= "default"

	args.state.text ||= 

"In Unity, to render a collection of sprites that fly across the screen and wrap around, you need to know about C#, static constructors,  classes, inheritance, MonoBehavior life cycles, GameObject instantiation, adding components/scripts through the IDE, Vector3, Quaternion.identity, Camera.main, transform, Time.deltaTime, how to create a prefab, and how to associate a sprite to a prefab using the ide. This doesn't include putting the current framerate on the screen.
	
The claim is :::this is how you should do it because it sets you up for success and a good architecture:::. Which isn't necessarily false, but I'm not ever going to get to that :::pit of success::: if I can't even get up and running.
It's like saying :::Oh don't use if/else statements, you should just go straight to using the strategy pattern. Every time.::: When in reality, understanding the Strategy Pattern includes the progression to the :::perfect::: solution: if/else statements, multiple if/elsif statements, consolidation of logic so case statements can be used, generalization of case statement to a Hash of Procs, then maybe the full blown strategy pattern"

	args.state.box_size ||= [20, 700, 200]

	args.state.text_box ||= textbox(args.state.text, *args.state.box_size, h=0, args.state.text_size, args.state.text_font)
	args.state.text_height ||= get_height(args.state.text, args.state.text_size, args.state.text_font) * args.state.text_box.length
	args.outputs.labels << args.state.text_box
	args.outputs.borders << [*args.state.box_size, args.state.text_height].anchor_rect(0,1)
end

def textbox(string, x, y, w, h=0, size=0, font="default")
	text = string_to_lines(string, w, size, font)
	height_offset = get_height(string, size, font)
	text.map!.with_index do |line, idx|
		[x, y - idx * height_offset, line, size, font]
	end
end

def get_length(string, size=0, font="default")
	$gtk.args.gtk.calcstringbox(string, size, font).x
end

def get_height(string, size=0, font="default")
	$gtk.args.gtk.calcstringbox(string, size, font).y
end

def string_to_lines(string, box_x, size, font)
	return string unless get_length(string, size, font) > box_x
	string.gsub!("\r", '')
	strings_with_linebreaks = string.split("\n")
	list_of_strings = strings_with_linebreaks.map do |line| 
		next if line == ""
		line.split
	end
	list_to_lines(list_of_strings, box_x, size, font)
end

def list_to_lines(strings, box_x, size, font)
	line = ""
	lines = []
	strings.map!{|string| string << ""}.flatten!.pop
	strings.each do |word|
		if word.empty? || !word
			lines.push line.dup unless line.empty?
			lines.push " " if line.empty?
			line.clear
		elsif get_length(line + " " + word, size, font) <= box_x
			line << " " if line.length > 0
			line << word
		else
			lines.push line.dup
			line.clear
			line << word
		end
	end
	lines.push line.dup
	lines
end