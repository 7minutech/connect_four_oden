# defines a game of connect four through the command line
class ConnectFour
  attr_accessor :board

  def initialize
    @move = nil
    @board = Array.new(6) { Array.new(7) { "\u3007" } }
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

  def display_board
    @board.each do |row|
      row.each do |col|
        print " | "
        print col
      end
      print " | "
      print "\n"
    end
  end
end
