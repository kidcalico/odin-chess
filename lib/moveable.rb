module Moveable
  def possible_moves(location, board_array, turn)
    case board_array[location[0]][location[1]].type
    when 'pawn' then pawn_moves(location, board_array, turn)
    when 'knight' then knight_moves(location, board_array, turn)
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

  def pawn_moves(location, board_array, turn)
    if turn == 'white' && board_array[location[0]][location[1]].color == 'white'
      return white_pawn_moves(location,
                              board_array, turn)
    end

    black_pawn_moves(location, board_array, turn) if turn == 'black'
  end

  def white_pawn_moves(location, board_array, turn)
    result = []
    if location[0] > 0
      result.push([location[0] - 1, location[1]]) if board_array[location[0] - 1][location[1]].nil?
      if location[0] == 6 && board_array[location[0] - 1][location[1]].nil? && board_array[location[0] - 1][location[1]].nil?
        result.push([location[0] - 2,
                     location[1]])
      end
      if location[1] - 1 > 0 && !board_array[location[0] - 1][location[1] - 1].nil? && board_array[location[0] - 1][location[1] - 1].color == 'black'
        result.push([location[0] - 1,
                     location[1] - 1])
      end
      if location[1] + 1 < 7 && !board_array[location[0] - 1][location[1] + 1].nil? && board_array[location[0] - 1][location[1] + 1].color == 'black'
        result.push([location[0] - 1,
                     location[1] + 1])
      end
    end
    result
  end

  def black_pawn_moves(location, board_array, turn)
    result = []
    if location[0] < 7
      result.push([location[0] + 1, location[1]]) if board_array[location[0] + 1][location[1]].nil?
      if location[0] == 1 && board_array[location[0] + 1][location[1]].nil? && board_array[location[0] + 2][location[1]].nil?
        result.push([location[0] + 2,
                     location[1]])
      end
      if location[1] - 1 > 0 && !board_array[location[0] + 1][location[1] - 1].nil? && board_array[location[0] + 1][location[1] - 1].color == 'white'
        result.push([location[0] + 1,
                     location[1] - 1])
      end
      if location[1] + 1 < 7 && !board_array[location[0] + 1][location[1] + 1].nil? && board_array[location[0] + 1][location[1] + 1].color == 'white'
        result.push([location[0] + 1,
                     location[1] + 1])
      end
    end
    result
  end

  def knight_moves(location, board_array, turn)
    all_knight_moves(location).map do |move|
      move if board_array[move[0]][move[1]].nil? || board_array[move[0]][move[1]].color != turn
    end.compact
  end

  def all_knight_moves(location)
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
