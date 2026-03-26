require_relative '../lib/game'
require_relative '../lib/piece'

describe Game do
  subject(:game) { described_class.new }
  describe '#possible_moves' do
    let(:board_array) { Array.new(8) { Array.new(8) } }

    context 'when the piece to be moved is a bishop' do
      let(:white_piece) { Piece.new('N', [3, 3]) }
      let(:black_piece) { Piece.new('p', [5, 2]) }

      context 'given a location and an empty board array' do
        let(:bishop) { Piece.new('b', [5, 4]) }

        before do
          board_array[5][4] = bishop
        end
        it 'returns all legal moves constrained by board edges' do
          opponent = 'white'
          result = game.possible_moves(bishop.location, board_array, opponent)
          expected = [[4, 5], [3, 6], [2, 7], [6, 5], [7, 6],
                      [6, 3], [7, 2], [4, 3], [3, 2], [2, 1], [1, 0]]
          expect(result).to match_array(expected)
        end
      end

      context 'given a location and a board array where the move is blocked by the same color' do
        let(:bishop) { Piece.new('B', [2, 2]) }

        before do
          board_array[2][2] = bishop
          board_array[3][3] = white_piece
        end
        it 'returns all legal moves, stopping where it is blocked' do
          opponent = 'black'
          result = game.possible_moves(bishop.location, board_array, opponent)
          expected = [[1, 1], [0, 0], [1, 3], [0, 4], [3, 1], [4, 0]]
          expect(result).to match_array(expected)
        end
      end

      context 'given a location and a board array where the possible moves include a capture' do
        let(:bishop) { Piece.new('B', [7, 0]) }

        before do
          board_array[7][0] = bishop
          board_array[5][2] = black_piece
        end

        it 'returns all legal moves, including capture' do
          opponent = 'black'
          result = game.possible_moves(bishop.location, board_array, opponent)
          expected = [[6, 1], [5, 2]]
          expect(result).to match_array(expected)
        end
      end

      context 'if bishop is blocked and has capture opportunities' do
        let(:bishop) { Piece.new('b', [4, 4]) }
        let(:own_piece) { Piece.new('p', [2, 6]) }

        before do
          board_array[4][4] = bishop
          board_array[2][2] = white_piece
          board_array[2][6] = own_piece
        end

        it 'returns legal moves, including capture, excluding own piece' do
          opponent = 'white'
          result = game.possible_moves(bishop.location, board_array, opponent)
          expected = [[3, 3], [2, 2], [5, 3], [6, 2], [7, 1], [5, 5], [6, 6], [7, 7], [3, 5]]
          expect(result).to match_array(expected)
        end
      end
    end
    context 'when piece to be moved is a rook' do
      let(:white_piece) { Piece.new('P', [5, 0]) }
      let(:black_piece) { Piece.new('n', [3, 2]) }

      context 'if rook has no pieces in its path' do
        let(:rook) { Piece.new('R', [0, 4]) }
        xit 'returns an array of all possible moves' do
          opponent = 'black'
          result = game.possible_moves(rook.location, board_array, opponent)
          expected = [[0, 3], [0, 2], [0, 1], [0, 0], [0, 5], [0, 6], [0, 7],
                      [4, 1], [4, 2], [4, 3], [4, 4], [4, 5], [4, 6], [4, 7]]
          expect(result).to match_array(expected)
        end
      end
    end
  end
end
