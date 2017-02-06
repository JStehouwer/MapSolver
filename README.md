This is just a fun little AI Map Solving project written in ruby.

To add a new AI player, simply create a player object that inherits from Player (for human-controlled players) and/or AIPlayer (for AI-controlled or AI-aided players).  New players must be required in 'main.rb' and must be added to the players array in 'settings.rb'.  The player that is run is chosen using the command line argument '-p <player>'.

Alternatively, a player can be written in any other language.  This player must be able to be executed by a terminal command, with the map state and player data passed as a json argument to the player.  See 'other_player.rb' for this implementation.  To submit a move, these players must return 0 (up), 1 (left), 2 (down), or 3 (right) to choose a valid move, or submit -1 to quit.

For additional instructions, run 'ruby main.rb -h'
