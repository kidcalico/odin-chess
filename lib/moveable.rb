module Moveable
  def possible_moves(board_array)
    case type
    when 'pawn' then pawn_moves(board_array)
    when 'knight' then knight_moves(board_array)
    when 'bishop' then bishop_moves(board_array)
    when 'rook' then rook_moves(board_array)
    when 'queen' then queen_moves(board_array)
    when 'king' then king_moves(board_array)
    end
  end

  private

  def check_moves
    # accepts array of possible moves, removing any that are blocked
  end

  def attacks
    # checks for attack possibilities,
  end

  def pawn_moves(board_array)
    return white_pawn_moves if color == 'white'

    black_pawn_moves
  end

  def white_pawn_moves(board_array)
    result = []
    if location[0] == 6
      result.push([location[0] - 1, location[1]],
                  [location[0] - 2, location[1]])
    elsif location[0] > 0
      result = [location[0] - 1, location[1]]
      unless location[1] - 1 < 0 && board_array[location[0] - 1][location[1] - 1].nil? && board_array[location[0] - 1][location[1] - 1].color == 'white'
        result.push([location[0] - 1,
                     location[1] - 1])
      end
      unless location[1] + 1 > 7 && board_array[location[0] - 1][location[1] + 1].nil? && board_array[location[0] - 1][location[1] + 1].color == 'white'
        result.push([location[0] - 1,
                     location[1] + 1])
      end
    end
    result
  end

  def black_pawn_moves(board_array)
    result = []
    if location[0] == 1
      result.push([location[0] + 1, location[1]],
                  [location[0] + 2, location[1]])
    elsif location[0] < 7
      result = [location[0] + 1, location[1]]
      unless location[1] - 1 < 0 && board_array[location[0] + 1][location[1] - 1].nil? && board_array[location[0] + 1][location[1] - 1].color == 'black'
        result.push([location[0] + 1,
                     location[1] - 1])
      end
      unless location[1] + 1 > 7 && board_array[location[0] + 1][location[1] + 1].nil? && board_array[location[0] + 1][location[1] + 1].color == 'black'
        result.push([location[0] + 1,
                     location[1] + 1])
      end
    end
    result
  end

  def knight_moves
    [
      [location[0] + 1, location[1] + 2], [location[0] - 1, location[1] + 2],
      [location[0] + 1, location[1] - 2], [location[0] - 1, location[1] - 2],
      [location[0] + 2, location[1] + 1], [location[0] + 2, location[1] - 1],
      [location[0] - 2, location[1] + 1], [location[0] - 2, location[1] - 1]
    ].reject { |move| move.any? { |v| v < 0 || v > 7 } }
  end

  def bishop_moves
    result = []
  end

  def rook_moves
    result = []
  end

  def queen_moves
  end

  def king_moves
  end
end
