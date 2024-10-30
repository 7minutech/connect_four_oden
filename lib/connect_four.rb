# defines a game of connect four through the command line
class ConnectFour
  attr_accessor :board, :round

  EMPTY_CIRCLE = "\u3007".freeze
  WHITE_CIRCLE = "\u26AA".freeze
  BLACK_CIRCLE = "\u26AB".freeze
  def initialize
    @move = nil
    @board = Array.new(6) { Array.new(7) { "\u3007" } }
    @round = 0
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

  def place_move
    col = @move -= 1
    row = 5
    row -= 1 until @board[row][col] == EMPTY_CIRCLE
    @board[row][col] = if @round.even?
                         WHITE_CIRCLE
                       else
                         BLACK_CIRCLE
                       end
  end

  def next_round
    @round += 1
  end

  def play_round
    valid_player_move
    place_move
    next_round
  end
end
