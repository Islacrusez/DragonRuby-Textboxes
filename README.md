# DragonRuby-Textboxes
Multiline textboxes for use with DragonRuby

DragonRuby by default does not suppport multi-line text boxes, and these must be constructed by hand from multiple single-line outputs.labels invocations. This repository provides a basic functionality for creation of textboxes, accepting a string that may or may not have linebreaks in it and converting it into an array of labels to be pushed directly into the output.

Please see main.rb comments for details and example usage.

The following method names are used by this repository:
tick (not required)
textbox, get_length, get_height, string_to_lines, list_to_lines

Usage:

Copy or require the code into your project, and call
Minimum:
args.outputs.labels << textbox("Text", x, y, w)
where "Text" is the string you wish to turn into a textbox
x and y are the xy pixel coordinate of the top left corner of your textbox
and w is the width, in pixels, of the textbox you wish to create.

All supported:
args.outputs.labels << textbox("Text", x, y, w, size, font)
In line with the .labels output and args.gtk.calcstringbox, textbox supports:
size (as a positive or negative integer, with default 0)
font (a string of the font name, default "default")

Logic suggestions, troubleshooting and other support has been kindly lent to this project by the DragonRuby Discord community. They're an awesome bunch and you should come visit sometime. We look forward to seeing your creations!
