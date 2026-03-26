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

  def check?(color)
  end

  def checkmate?(color)
  end
end
