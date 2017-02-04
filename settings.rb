require 'pry'

class Settings
  # The default settings
  def set_defaults
    @@debug_mode = 0
    @@horizontal_size = 5
    @@vertical_size = 5
    @@random = Random.new
    @@player_file = ""
    @@player_name = ""
    @@test_mode = 0
  end
  
  # This returns true if running in debug mode
  def debug_mode
    @@debug_mode == 1
  end

  def parse(arguments)
    players = ["human", "ai_up", "ai_left", "ai_diag", "ai_dist"]
    set_defaults
    (0..arguments.length).each do |arg|
      case arguments.at(arg)
      when "-h"
        output = "Usage\n"
        output += "  -h: Show this usage help information\n"
        output += "  -v: Debug Mode\n"
        output += "  -w <int>: Set horizontal dimension of board to <int>\n"
        output += "  -l <int>: Set vertical dimension of board to <int>\n"
        output += "  -r <int>: Set the RNG seed to <int>\n"
        puts output
        return false
      when "-v"
        @@debug_mode = 1
      when "-r"
        if arguments.at(arg+1).to_i
          @@random_seed = arguments.at(arg+1).to_i
          srand(@@random_seed)
          puts "Random Seed set to: #{@@random_seed}" if debug_mode
        else
          puts "Invalid seed for RNG: #{arguments.at(arg+1)}"
        end
      when "-w"
        if arguments.at(arg+1).to_i > 0
          @@vertical_size = arguments.at(arg+1).to_i
        else
          puts "Invalid horizontal size: #{arguments.at(arg+1)}"
        end
      when "-l"
        if arguments.at(arg+1).to_i > 0
          @@horizontal_size = arguments.at(arg+1).to_i
        else
          puts "Invalid vertical size: #{arguments.at(arg+1)}"
        end
      when "-p"
        if arguments.at(arg+1) and players.include?(arguments.at(arg+1))
          @@player_file = arguments.at(arg+1)
        end
      when "-pn"
        if arguments.at(arg+1)
          @@player_name = arguments.at(arg+1)
        end
      when "-test"
        @@test_mode = 1
      end
    end
    output = "Settings intitialized with\n"
    output += "  Debug Mode: #{@@debug_mode}\n"
    puts output if debug_mode
    return true
  end

  def self.debug_mode
    @@debug_mode == 1
  end

  def self.get_horizontal_size
    @@horizontal_size
  end

  def self.get_vertical_size
    @@vertical_size
  end

  def self.get_greater_dimension
    return [@@horizontal_size, @@vertical_size].max
  end

  def self.get_random
    @@random
  end

  def self.get_player_file
    @@player_file
  end

  def self.get_player_name
    @@player_name
  end

  def self.test_mode
    @@test_mode == 1
  end
end
