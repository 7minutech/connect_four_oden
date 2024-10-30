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
end
