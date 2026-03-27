module Steppable
  def pawn_moves(location, board_array, opponent)
    result = []
    rank = location[0]
    file = location[1]
    direction = if opponent == 'white'
                  1
                else
                  -1
                end

    if rank > 0 && rank < 7
      result.push([rank + direction, file]) if board_array[rank + direction][file].nil?
      if ((rank == 6 && opponent = 'black') || (rank == 1 && opponent == 'white')) && board_array[rank + direction][file].nil? && board_array[rank + (direction * 2)][file].nil?
        result.push([rank + (direction * 2),
                     file])
      end
      if file - 1 >= 0 && !board_array[rank + direction][file - 1].nil? && board_array[rank + direction][file - 1].color == opponent
        result.push([rank + direction,
                     file - 1])
      end
      if file + 1 <= 7 && !board_array[rank + direction][file + 1].nil? && board_array[rank + direction][file + 1].color == opponent
        result.push([rank + direction,
                     file + 1])
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

  def king_moves(location, board_array, opponent)
    directions = [[-1, 1], [1, 1], [1, -1], [-1, -1], [1, 0], [-1, 0], [0, 1], [0, -1]]
    rank = location[0]
    file = location[1]

    results = directions.map do |direction|
      r_direction = direction[0]
      f_direction = direction[1]

      next if [rank + r_direction, file + f_direction].any? { |coordinate| coordinate < 0 || coordinate > 7 }

      if board_array[rank + r_direction][file + f_direction].nil? || board_array[rank + r_direction][file + f_direction].color == opponent
        [rank + r_direction, file + f_direction]
      end
    end
  end
end
