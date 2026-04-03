require_relative '../lib/game'
require_relative '../lib/piece'

describe Game do
  subject(:game) { described_class.new }
  let(:board_array) { Array.new(8) { Array.new(8) } }

  describe '#possible_moves' do
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

        before do
          board_array[0][4] = rook
        end

        it 'returns an array of all possible moves' do
          opponent = 'black'
          result = game.possible_moves(rook.location, board_array, opponent)
          expected = [[0, 3], [0, 2], [0, 1], [0, 0], [0, 5], [0, 6], [0, 7],
                      [1, 4], [2, 4], [3, 4], [4, 4], [5, 4], [6, 4], [7, 4]]
          expect(result).to match_array(expected)
        end
      end
    end
  end

  describe '#check?' do
    let(:black_king) { Piece.new('k', [0, 0]) }
    let(:white_rook) { Piece.new('R', [0, 6]) }
    let(:white_bishop) { Piece.new('B', [0, 6]) }

    context 'when a white piece puts the black king in check' do
      before do
        board_array[0][0] = black_king
        board_array[0][6] = white_rook
        allow(game.board).to receive(:board).and_return(board_array)
      end
      it 'returns true' do
        color = 'black'
        result = game.check?(color)
        expected = true
        expect(result).to be(expected)
      end
    end

    context 'when the black king is not in check' do
      before do
        board_array[0][0] = black_king
        board_array[0][6] = white_bishop
        allow(game.board).to receive(:board).and_return(board_array)
      end
      it 'returns false' do
        color = 'black'
        result = game.check?(color)
        expected = false
        expect(result).to be(expected)
      end
    end
  end

  describe '#check_square?' do
    let(:black_rook) { Piece.new('r', [7, 0]) }
    before do
      board_array[7][0] = black_rook
      allow(game.board).to receive(:board).and_return(board_array)
    end
    it 'returns false if square is not vulnerable to attack' do
      square = [3, 4]
      color = 'white'
      result = game.check_square?(square, color)
      expected = false
      expect(result).to be(expected)
    end
    it 'returns true if square is vulnerable to attack' do
      square = [0, 0]
      color = 'white'
      result = game.check_square?(square, color)
      expected = true
      expect(result).to be(expected)
    end
  end

  describe '#stalemate?' do
    context 'if the king is not in check but cannot move because the neighboring squares are controlled by the opponent' do
      let(:white_king) { Piece.new('K', [0, 4]) }
      let(:black_queen) { Piece.new('q', [1, 2]) }
      let(:black_rook) { Piece.new('r', [1, 5]) }

      before do
        board_array[0][4] = white_king
        board_array[1][2] = black_queen
        board_array[1][5] = black_rook
        allow(game.board).to receive(:board).and_return(board_array)
      end
      it 'returns true' do
        color = 'white'
        result = game.stalemate?(color)
        expected = true
        expect(result).to be(expected)
      end
    end
  end

  describe '#find_king' do
    context 'given a color it finds the location of the king of that color' do
      let(:black_king) { Piece.new('k', [0, 4]) }

      before do
        board_array[0][4] = black_king
        allow(game.board).to receive(:board).and_return(board_array)
      end

      it 'returns the black king' do
        color = 'black'
        expected = [0, 4]
        result = game.find_king(color)
        expect(result).to eq(expected)
      end
    end
  end
end
