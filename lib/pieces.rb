require 'pry-byebug'

class Pieces
  NEW_GAME = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'.freeze
  # NEW_GAME = '1B6/2n5/p1N1P2R/P1K3N1/4Pk2/1Q2p2p/6nP/1B4R1 w - - 0 1'

  attr_accessor :matrix_notation

  def initialize(fen_code = NEW_GAME)
    fen_notation = split_fen(fen_code)
    @matrix_notation = fen_to_matrix(fen_notation[0])
    @to_play = fen_notation[1]
    @can_castle = fen_notation[2]
    @en_passant = fen_notation[3]
    @halfmove_clock = fen_notation[4]
    @fullmove_num = fen_notation[5]
  end

  def whose_turn
    @to_play = @fen_notation[1]
  end

  def split_fen(fen_code)
    all_pieces = fen_code.split(' ')
    all_pieces[0] = all_pieces[0].split('/')
    all_pieces
  end

  def fen_to_matrix(fen_code)
    board_state = []
    fen_code.each_index do |rank|
      board_state << fen_code[rank].split('')
    end
    num_to_empties(board_state)
  end

  def num_to_empties(matrix)
    board_state = []
    matrix.each_index do |rank|
      board_state << []
      matrix[rank].each do |file|
        file.to_i.times { board_state[rank] << ' ' } if /^[1-8]$/.match?(file)
        board_state[rank] << file unless /^[1-8]$/.match?(file)
      end
    end
    board_state
  end
end
