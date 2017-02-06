require 'json'
require_relative 'player'

class OtherPlayer < Player
  #Creates a new ai player
  def initialize(goal_location: [0,0], my_location: [4,4], map: nil, wall_break: 0, executable: "")
    super(goal_location: goal_location,
          my_location: my_location,
          map: map,
          wall_break: wall_break)
    @executable = executable
  end

  def ask_for_move(map:)
    puts "Asking player '#{@executable}' for its next move, hit <enter> to continue"
    moves = [[-1,0],[0,-1],[1,0],[0,1]] # Up, Left, Down, Right

    # Call the player by running a terminal command with appropriate arguments
    arguments = convert_state_to_string(map)
    command = "#{@executable} #{arguments}"
    choice  =`#{command}`.gsub("\n","").to_i
    if choice == -1
      return -1
    elsif choice >= 0 and choice < 4
      return moves[choice]
    else
      puts "Player #{executable} returned an invalid move\nThe command used to run the player was #{command}"
      exit
    end
  end

  def convert_state_to_string(map)
    # Must pass goal, me, wall_break, since_last_wall_break, steps, map
    data = {
             "goal"=>@goal_location,
             "location"=>@my_location,
             "wall_break"=>@wall_break,
             "since_last_wall_break_receive"=>@since_last_wall_break_receive,
             "steps"=>@steps,
             "map"=>map.to_string_for_json
           }
    output = data.to_json
    return output
  end
end
