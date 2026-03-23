require 'pry-byebug'

class LoadGame
  NEW_GAME = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'.freeze
  SAVED_GAME = 'rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2'

  attr_accessor :matrix_notation, :game_stats, :fen_notation

  def initialize(fen_code = SAVED_GAME)
    @fen_notation = split_fen(fen_code)
    @matrix_notation = fen_to_matrix(@fen_notation[0])
    load_stats
  end

  def load_stats
    @game_stats = { turn: @fen_notation[1], castle: @fen_notation[2], en_passant: @fen_notation[3],
                    half_moves: @fen_notation[4], full_moves: @fen_notation[5] }
  end

  def split_fen(fen_code)
    all_pieces = fen_code.split(' ')
    all_pieces[0] = all_pieces[0].split('/')
    all_pieces
  end

  def fen_to_matrix(fen_code)
    result = []
    fen_code.each_index do |rank|
      result << fen_code[rank].split('')
    end
    num_to_empties(result)
  end

  def num_to_empties(matrix)
    matrix.map do |rank|
      rank.map do |square|
        if /^[1-8]$/.match?(square)
          [nil] * square.to_i
        else
          square
        end
      end.flatten
    end
  end
end
