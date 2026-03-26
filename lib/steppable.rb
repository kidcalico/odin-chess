module Steppable
  def pawn_moves(location, board_array, opponent)
    if opponent == 'black' && board_array[location[0]][location[1]].color == 'white'
      return white_pawn_moves(location,
                              board_array, opponent)
    end

    black_pawn_moves(location, board_array, opponent) if opponent == 'white'
  end

  def white_pawn_moves(location, board_array, opponent)
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

  def black_pawn_moves(location, board_array, opponent)
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

  def knight_moves(location, board_array, opponent)
    basic_moves = [[1, 2], [-1, 2], [1, -2], [-1, -2], [2, 1], [2, -1], [-2, 1], [-2, -1]]
    moves = basic_moves.map do |move|
      possible_move = move.map.with_index { |coordinate, index| coordinate + location[index] }
      next if (possible_move[0] < 0 || possible_move[0] > 7) || (possible_move[1] < 0 || possible_move[1] > 7)
      next unless board_array[possible_move[0]][possible_move[1]].nil? ||
                  board_array[possible_move[0]][possible_move[1]].color == opponent

      possible_move
    end.compact
  end

  def king_moves
  end
end
