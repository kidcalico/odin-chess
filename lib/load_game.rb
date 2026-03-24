require 'pry-byebug'

class LoadGame
  NEW_GAME = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'.freeze
  TEST_GAME = '1r6/5pp1/R1R4p/1r1pP3/2pkQPP1/7P/1P6/2K5 w - - 0 41'
  SAVED_GAME = 'r1bqkbnr/ppp2ppp/2np4/4p3/3PP3/5N2/PPP2PPP/RNBQKB1R w KQkq - 2 4'

  attr_accessor :matrix_notation, :game_stats, :fen_notation

  def initialize(fen_code = TEST_GAME)
    @fen_notation = fen_to_array(fen_code)
    # @matrix_notation = fen_to_matrix(fen_notation[0])
    @game_stats = load_stats
  end

  def load_stats
    { turn: fen_notation[1], castle: fen_notation[2], en_passant: fen_notation[3],
      half_moves: fen_notation[4], full_moves: fen_notation[5] }
  end

  def fen_to_array(fen_code)
    all_pieces = fen_code.split(' ')
    all_pieces[0] = num_to_empties(all_pieces[0].split('/').map { |block| block.split('') })
    all_pieces
  end

  def num_to_empties(matrix)
    matrix.map do |rank|
      rank.map do |square|
        next [nil] * square.to_i if /^[1-8]$/.match?(square)

        square
      end.flatten
    end
  end
end
