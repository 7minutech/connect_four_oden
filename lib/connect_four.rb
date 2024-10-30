class ConnectFour
  def initialize
    @move = nil
  end

  def valid_player_move
    player_input
    until  Integer(@move, exception: false) && @move.to_i.between?(1, 7)
      puts "Move must be between 1 and 7"
      player_input
    end
    convert_move
  end

  def convert_move
    @move = @move.to_i
  end

  def player_input
    puts "Please enter number from 1-7 to place in a column: "
    @move = gets.to_s.chomp
  end
end
