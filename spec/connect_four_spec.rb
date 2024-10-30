require_relative "../lib/connect_four"

describe ConnectFour do
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
        prompt_message = "Please enter number from 1-7 to place in a column: "
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
        prompt_message = "Please enter number from 1-7 to place in a column: "
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
        prompt_message = "Please enter number from 1-7 to place in a column: "
        error_message = "Move must be between 1 and 7"
        allow(game_move).to receive(:puts).with(prompt_message)
        expect(game_move).not_to receive(:puts).with(error_message)
        game_move.send(:valid_player_move)
      end
    end
  end
end
