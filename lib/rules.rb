require_relative 'slideable'
require_relative 'steppable'

module Rules
  include Slideable
  include Steppable

  def possible_moves(location, board_array, opponent)
    case board_array[location[0]][location[1]].type
    when 'pawn' then pawn_moves(location, board_array, opponent)
    when 'knight' then knight_moves(location, board_array, opponent)
    when 'bishop' then bishop_moves(location, board_array, opponent)
    when 'rook' then rook_moves(location, board_array, opponent)
    when 'queen' then queen_moves(location, board_array, opponent)
    when 'king' then king_moves(location, board_array, opponent)
    end
  end

  def castle?(color)
  end

  def castle_tracker(color)
  end

  def en_passant_tracker(piece, move)
    return unless board.board[piece[0]][piece[1]].type == 'pawn' && (piece[0] - move[0]).abs == 2

    en_passant_square(move)
  end

  def en_passant_square(move)
    algebraic = move_to_algebraic(move)
    i = 1 if algebraic[1] == '5'
    i = -1 if algebraic[1] == '4'
    algebraic[1] = (algebraic[1].to_i + i).to_s
    game_stats[:en_passant] = algebraic
  end

  def move_to_algebraic(move)
    [(move[1] + 97).chr + (8 - move[0])].join
  end

  def check?(color)
    false
  end

  def checkmate?(color)
    false
  end

  def stalemate?(color)
    false
  end
end
