require_relative '../lib/game'
require_relative '../lib/piece'

describe Game do
  subject(:game) { described_class.new }
  describe '#bishop_moves' do
    let(:board_array) { Array.new(8) { Array.new(8) } }
    let(:white_piece) { Piece.new('N', [3, 3]) }
    let(:black_piece) { Piece.new('b', [5, 2]) }

    context 'given a location and an empty board array' do
      it 'returns all legal moves constrained by board edges' do
        location = [5, 4]
        opponent = 'white'
        result = game.bishop_moves(location, board_array, opponent)
        expected = [[4, 5], [3, 6], [2, 7], [6, 5], [7, 6],
                    [6, 3], [7, 2], [4, 3], [3, 2], [2, 1], [1, 0]]
        expect(result).to match_array(expected)
      end
    end

    context 'given a location and a board array where the move is blocked by the same color' do
      before do
        board_array[3][3] = white_piece
      end
      it 'returns all legal moves, stopping where it is blocked' do
        location = [2, 2]
        opponent = 'black'
        result = game.bishop_moves(location, board_array, opponent)
        expected = [[1, 1], [0, 0], [1, 3], [0, 4], [3, 1], [4, 0]]
        expect(result).to match_array(expected)
      end
    end

    context 'given a location and a board array where the possible moves include a capture' do
      before do
        board_array[5][2] = black_piece
      end

      it 'returns all legal moves, including capture' do
        location = [7, 0]
        opponent = 'black'
        result = game.bishop_moves(location, board_array, opponent)
        expected = [[6, 1], [5, 2]]
        expect(result).to match_array(expected)
      end
    end
  end
end
