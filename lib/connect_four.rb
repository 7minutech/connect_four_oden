require "pry-byebug"

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
    puts "Please enter number from 1-7 to place in a column or q to quit: "
    @move = gets.to_s.chomp
    return unless @move == "q"

    abort "Exiting game..."
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
    display_board
  end

  def vertical_win?
    bottom_row = 5
    columns = 0..6
    columns.each do |col|
      next unless @board[bottom_row][col] != EMPTY_CIRCLE

      white_circle_count = 0
      black_circle_count = 0
      row = bottom_row
      while (row > -1) && @board[row][col] != EMPTY_CIRCLE
        if @board[row][col] == WHITE_CIRCLE
          white_circle_count += 1
          black_circle_count -= 1
        else
          black_circle_count += 1
          white_circle_count -= 1
        end
        row -= 1
      end

      return true if white_circle_count > 3 || black_circle_count > 3
    end
    false
  end

  def horizantal_win?
    row = 5
    columns = 0..6
    columns.each do |col|
      next unless @board[row][col] != EMPTY_CIRCLE

      white_circle_count = 0
      black_circle_count = 0
      while (col < 7) && @board[row][col] != EMPTY_CIRCLE
        if @board[row][col] == WHITE_CIRCLE
          white_circle_count += 1
          black_circle_count -= 1
        else
          black_circle_count += 1
          white_circle_count -= 1
        end
        col += 1
      end
      row -= 1

      return true if white_circle_count > 3 || black_circle_count > 3
    end
    false
  end
end
