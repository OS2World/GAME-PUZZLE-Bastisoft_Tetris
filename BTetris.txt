This is the README file for Bastisoft Tetris for OS/2.

This software is released under the GNU General Public License in
September 2002. At this point, I haven't worked on it for about five
years. I hope that all files necessary to compile the program are
included; I don't have any possibility anymore to try it out.

For the terms under which you may use and distribute this software,
the GNU General Public License, please see the file copy.txt

To compile the program, you need a Pascal compiler. It was developed
using the Virtual Pascal compiler, version 1. Virtual Pascal
development is being continued by Allan Mertner, see
<http://www.vpascal.com>.

The game was originally released in German language. These are the
translations of the strings that appear on the screen:

'Naechstes Teil:' - 'Next block:'
'Punkte:' - 'Score:'
'Level:' - (obvious)
'Startlevel:' - (ditto)
'Neues Spiel' - 'New game'
'Pause' - (obvious)
'Weiter' - 'Resume'
'Beenden' - 'Quit'
'Die besten Zehn!' - 'The top ten!'
'Unglaublich!' - 'Unbelievable!'
'Neuer Hi-Score!' - 'New highscore'
'Bitte geben Sie Ihren Namen ein:' - 'Please enter your name:'
'Das Spiel ist beendet.' - 'The game is over.'
'Sie haben es bis Level X geschafft.' - 'You have made it to level X.'
'Ihr Punktestand betraegt X.' - 'Your score is X.'
'Wollen Sie X wirklich beenden?' - 'Do you really want to quit X?'
'Moment mal...' - 'Wait a minute...'

What follows is a slightly reworked version of the README file that
was originally included in the archive.

------------------------------------------------------------------------

Bastisoft Tetris for OS/2 (v1.02)

It should generally be known how Tetris is played. Just for the
unlikely case you don't know Tetris I'll give a short description:

Blocks are falling into some kind of well and pile up on the ground.
The player has to rotate and direct the blocks so that they fill the
gaps. Every time a row is complete, this row is deleted and all blocks
above that row fall down one row. Your score increases with every
block that you are able to position somehow and with every row that is
deleted. After some time, the speed with which the blocks fall down
(also called the "level") increases.

The game is controlled using the arrow keys (or the numpad).

Left arrow:  The block moves one unit to the left
Right arrow: The block moves one unit to the right
Up arrow:    The block rotates 90 degrees anti-clockwise
Down arrow:  The block falls down immediately

You can define the start level using the two arrow buttons on the
right. A running game can be paused by clicking on the "Pause" button
and resumed by clicking on the same button a second time.

In addition, the following keyboard commands are recognized:

'+': Increase start speed
'-': Decrease start speed
'n': Start a new game
'p': Pause game
'h': Show highscore list
'q': Quit

2002-09-26, Sebastian Koppehel
