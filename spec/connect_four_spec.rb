require_relative "../lib/connect_four"

describe ConnectFour do
  before do
    allow($stdout).to receive(:write) # Suppresses all console output
  end
  describe "#valid_player_move" do
    let(:game_move) { described_class.new }
    context "when user inputs an invalid number and a char then a valid move" do
      before do
        valid_move = "1"
        invalid_move_range = "8"
        invalid_move_char = "a"

        allow(game_move).to receive(:gets).and_return(invalid_move_char, invalid_move_range, valid_move)
      end
      it "returns an error message twice and exits loop" do
        prompt_message = "Please enter number from 1-7 to place in a column or q to quit: "
        error_message = "Move must be between 1 and 7"
        allow(game_move).to receive(:puts).with(prompt_message)
        expect(game_move).to receive(:puts).with(error_message).twice
        game_move.send(:valid_player_move)
      end
    end
    context "when a user inputs one invlaid move and then a valid move" do
      before do
        valid_move = "2"
        invalid_move_range = "0"

        allow(game_move).to receive(:gets).and_return(invalid_move_range, valid_move)
      end
      it "returns an error message once and exits loop" do
        prompt_message = "Please enter number from 1-7 to place in a column or q to quit: "
        error_message = "Move must be between 1 and 7"
        allow(game_move).to receive(:puts).with(prompt_message)
        expect(game_move).to receive(:puts).with(error_message).once
        game_move.send(:valid_player_move)
      end
    end
    context "when a user enters a valid guess first" do
      before do
        valid_move = 3
        allow(game_move).to receive(:gets).and_return(valid_move)
      end
      it "exits loop without printing error message" do
        prompt_message = "Please enter number from 1-7 to place in a column or q to quit: "
        error_message = "Move must be between 1 and 7"
        allow(game_move).to receive(:puts).with(prompt_message)
        expect(game_move).not_to receive(:puts).with(error_message)
        game_move.send(:valid_player_move)
      end
    end
  end
  describe "#place_move" do
    let(:game_place_move) { described_class.new }
    context "when one valid is given" do
      before do
        valid_move = "1"
        allow(game_place_move).to receive(:gets).and_return(valid_move)
      end
      it "places white circle accordingly" do
        player_1_piece = "\u26AA"
        game_place_move.send(:valid_player_move)
        game_place_move.send(:place_move)
        expect(game_place_move.board[5][0]).to eq(player_1_piece)
      end
    end
    context "when two valid moves are given" do
      before do
        valid_move1 = "1"
        valid_move2 = "2"
        allow(game_place_move).to receive(:gets).and_return(valid_move1, valid_move2)
      end
      it "places a white circle and then a black circle accordingly" do
        player_1_piece = "\u26AA"
        player_2_piece = "\u26AB"
        game_place_move.send(:valid_player_move)
        game_place_move.send(:place_move)
        game_place_move.send(:next_round)
        game_place_move.send(:valid_player_move)
        game_place_move.send(:place_move)
        expect(game_place_move.board[5][0]).to eq(player_1_piece)
        expect(game_place_move.board[5][1]).to eq(player_2_piece)
      end
    end
    context "when two valid moves are given for the column" do
      before do
        valid_move1 = "3"
        valid_move2 = "3"
        allow(game_place_move).to receive(:gets).and_return(valid_move1, valid_move2)
      end
      it "places a white circle and then a black circle accordingly" do
        player_1_piece = "\u26AA"
        player_2_piece = "\u26AB"
        game_place_move.send(:valid_player_move)
        game_place_move.send(:place_move)
        game_place_move.send(:next_round)
        game_place_move.send(:valid_player_move)
        game_place_move.send(:place_move)
        expect(game_place_move.board[5][2]).to eq(player_1_piece)
        expect(game_place_move.board[4][2]).to eq(player_2_piece)
      end
    end
  end
  describe "#play_round" do
    let(:game_round) { described_class.new }
    context "when 1 round is played" do
      before do
        valid_move = "2"
        allow(game_round).to receive(:gets).and_return(valid_move)
      end
      it "gets player move and updates the board and round" do
        player_1_piece = "\u26AA"
        game_round.send(:play_round)
        expect(game_round.board[5][1]).to eq(player_1_piece)
        expect(game_round.round).to eq(1)
      end
    end
    context "when 3 rounds have been played" do
      before do
        valid_move1 = "1"
        valid_move2 = "1"
        valid_move3 = "3"
        allow(game_round).to receive(:gets).and_return(valid_move1, valid_move2, valid_move3)
      end
      it "get player moves and update board and round accordingly" do
        player_1_piece = "\u26AA"
        player_2_piece = "\u26AB"
        game_round.send(:play_round)
        game_round.send(:play_round)
        game_round.send(:play_round)
        expect(game_round.board[5][0]).to eq(player_1_piece)
        expect(game_round.board[4][0]).to eq(player_2_piece)
        expect(game_round.board[5][2]).to eq(player_1_piece)
        expect(game_round.round).to eq(3)
      end
    end
  end
  describe "vertical_win?" do
    let(:game_over) { described_class.new }
    context "Once a connect four is reached vertically" do
      before do
        winning_vertical_moves = %w[1 2 1 2 1 2 1]
        allow(game_over).to receive(:gets).and_return(*winning_vertical_moves)
      end
      it "returns true" do
        move_count = 7
        move_count.times { game_over.play_round }
        expect(game_over.vertical_win?).to be true
      end
    end
    context "A connect four has been reached vertically with different pieces in the same column" do
      before do
        winning_vertical_moves = %w[1 1 1 2 1 2 1 2 1]
        allow(game_over).to receive(:gets).and_return(*winning_vertical_moves)
      end
      it "returns true" do
        move_count = 9
        move_count.times { game_over.play_round }
        expect(game_over.vertical_win?).to be true
      end
    end
    context "No connect four has been reached vertcally" do
      before do
        winning_vertical_moves = %w[1 1 1 2 1 3 1 2]
        allow(game_over).to receive(:gets).and_return(*winning_vertical_moves)
      end
      it "returns false" do
        move_count = 8
        move_count.times { game_over.play_round }
        expect(game_over.vertical_win?).to be false
      end
    end
  end
  describe "horizantal_win?" do
    let(:game_over) { described_class.new }
    context "Once a connect four is reached horizantally" do
      before do
        winning_horizantal_moves = %w[1 1 2 2 3 3 4]
        allow(game_over).to receive(:gets).and_return(*winning_horizantal_moves)
      end
      it "returns true" do
        move_count = 7
        move_count.times { game_over.play_round }
        expect(game_over.horizantal_win?).to be true
      end
    end
    context "A connect four has been reached horizantally with different pieces in the same row" do
      before do
        winning_horizantal_moves = %w[1 2 3 4 2 1 3 1 4 5 5]
        allow(game_over).to receive(:gets).and_return(*winning_horizantal_moves)
      end
      it "returns true" do
        move_count = 11
        move_count.times { game_over.play_round }
        expect(game_over.horizantal_win?).to be true
      end
    end
    context "No connect four has been reached horizantally" do
      before do
        winning_horizantal_moves = %w[1 2 3 4 5 1 2]
        allow(game_over).to receive(:gets).and_return(*winning_horizantal_moves)
      end
      it "returns false" do
        move_count = 7
        move_count.times { game_over.play_round }
        expect(game_over.horizantal_win?).to be false
      end
    end
  end

  describe "diagonal_win?" do
    let(:game_over) { described_class.new }
    context "Once a connect four is reached diagonally going right" do
      before do
        winning_diagonal_moves = %w[1 2 2 3 3 4 3 4 4 5 4]
        allow(game_over).to receive(:gets).and_return(*winning_diagonal_moves)
      end
      it "returns true" do
        move_count = 11
        move_count.times { game_over.play_round }
        expect(game_over.diagonal_win?).to be true
      end
    end
    context "Once a connect four is reached diagonally going left" do
      before do
        winning_diagonal_moves = %w[4 3 3 2 2 1 2 1 1 5 1]
        allow(game_over).to receive(:gets).and_return(*winning_diagonal_moves)
      end
      it "returns true" do
        move_count = 11
        move_count.times { game_over.play_round }
        expect(game_over.diagonal_win?).to be true
      end
    end
    context "A connect four has been reached diagonally with different pieces in the same diagonal" do
      before do
        player_1_piece = "\u26AA"
        player_2_piece = "\u26AB"
        game_over.board[0][0] = player_1_piece
        game_over.board[1][1] = player_2_piece
        (2..5).each { |row| game_over.board[row][row] = player_1_piece }
      end
      it "returns true" do
        expect(game_over.diagonal_win?).to be true
      end
    end
    context "No connect four has been reached diagonally" do
      before do
        winning_diagonal_moves = %w[1 2 3 4 5 1 2]
        allow(game_over).to receive(:gets).and_return(*winning_diagonal_moves)
      end
      it "returns false" do
        move_count = 7
        move_count.times { game_over.play_round }
        expect(game_over.diagonal_win?).to be false
      end
    end
  end

  describe "reset" do
    let(:game_reset) { described_class.new }
    context "after a game has finished and they choose to play again" do
      before do
        winning_horizantal_moves = %w[1 1 2 2 3 3]
        allow(game_reset).to receive(:gets).and_return(*winning_horizantal_moves)
      end
      it "returns game back to init state" do
        moves = 6
        player_1_piece = "\u26AA"
        player_2_piece = "\u26AB"
        moves.times { game_reset.send(:play_round) }
        game_reset.send(:reset)
        expect(game_reset.round).to eq(0)
        expect(game_reset.board).not_to include(player_1_piece, player_2_piece)
      end
    end
  end

  describe "#game_over_message" do
    let(:game_over) { described_class.new }
    context "if player 1 wins" do
      before do
        moves = %w[1 1 2 2 3 3 4]
        allow(game_over).to receive(:gets).and_return(*moves)
      end
      it "returns win message for player 1" do
        prompt_message = "Please enter number from 1-7 to place in a column or q to quit: "
        player_1_message = "Player 1 wins!!!"
        turn_message1 = "Player 1 turn"
        turn_message2 = "Player 2 turn"
        allow(game_over).to receive(:puts).with(prompt_message)
        allow(game_over).to receive(:puts).with(turn_message1)
        allow(game_over).to receive(:puts).with(turn_message2)

        expect(game_over).to receive(:puts).with(player_1_message)
        game_over.send(:play_game)
      end
    end
    context "if player 2 wins" do
      before do
        moves = %w[1 1 2 2 3 3 5 4 6 4]
        allow(game_over).to receive(:gets).and_return(*moves)
      end
      it "returns win message for player 2" do
        prompt_message = "Please enter number from 1-7 to place in a column or q to quit: "
        player_2_message = "Player 2 wins!!!"
        turn_message1 = "Player 1 turn"
        turn_message2 = "Player 2 turn"
        allow(game_over).to receive(:puts).with(prompt_message)
        allow(game_over).to receive(:puts).with(turn_message1)
        allow(game_over).to receive(:puts).with(turn_message2)
        expect(game_over).to receive(:puts).with(player_2_message)
        game_over.send(:play_game)
      end
    end
  end
end
