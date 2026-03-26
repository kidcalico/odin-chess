module Moveable
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

  # private

  def check_moves
    # accepts array of possible moves, removing any that are blocked
  end

  def attacks
    # checks for attack possibilities,
  end

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
    all_knight_moves(location).map do |move|
      move if board_array[move[0]][move[1]].nil? || board_array[move[0]][move[1]].color == opponent
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

  def bishop_moves(location, board_array, opponent)
    result = []
    result.concat(bishop_ne(location, board_array, opponent),
                  bishop_se(location, board_array, opponent),
                  bishop_sw(location, board_array, opponent),
                  bishop_nw(location, board_array, opponent))
  end

  def bishop_ne(location, board_array, opponent)
    result = []
    i = 1
    loop do
      break if location[0] - i < 0 || location[1] + i > 7

      unless board_array[location[0] - i][location[1] + i].nil?
        if board_array[location[0] - i][location[1] + i].color == opponent
          result << [location[0] - i, location[1] + i]
          break
        elsif board_array[location[0] - i][location[1] + i].color != opponent
          break
        end
      end
      result << [location[0] - i, location[1] + i]
      i += 1
      break if location[0] - i < 0 || location[1] + i > 7
    end
    result
  end

  def bishop_se(location, board_array, opponent)
    result = []
    i = 1
    loop do
      break if location[0] + i > 7 || location[1] + i > 7

      unless board_array[location[0] + i][location[1] + i].nil?
        if board_array[location[0] + i][location[1] + i].color == opponent
          result << [location[0] + i, location[1] + i]
          break
        elsif board_array[location[0] + i][location[1] + i].color != opponent
          break
        end
      end
      result << [location[0] + i, location[1] + i]
      i += 1
      break if location[0] + i > 7 || location[1] + i > 7
    end
    result
  end

  def bishop_sw(location, board_array, opponent)
    result = []
    i = 1
    loop do
      break if location[0] + i > 7 || location[1] - i < 0

      unless board_array[location[0] + i][location[1] - i].nil?
        if board_array[location[0] + i][location[1] - i].color == opponent
          result << [location[0] + i, location[1] - i]
          break
        elsif board_array[location[0] + i][location[1] - i].color != opponent
          break
        end
      end
      result << [location[0] + i, location[1] - i]
      i += 1
      break if location[0] + i > 7 || location[1] - i < 0
    end
    result
  end

  def bishop_nw(location, board_array, opponent)
    result = []
    i = 1
    loop do
      break if location[0] - i < 0 || location[1] - i < 0

      unless board_array[location[0] - i][location[1] - i].nil?
        if board_array[location[0] - i][location[1] - i].color == opponent
          result << [location[0] - i, location[1] - i]
          break
        elsif board_array[location[0] - i][location[1] - i].color != opponent
          break
        end
      end
      result << [location[0] - i, location[1] - i]
      i += 1
      break if location[0] - i < 0 || location[1] - i < 0
    end
    result
  end

  def rook_moves
    result = []
  end

  def queen_moves
  end

  def king_moves
  end
end
