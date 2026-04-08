module Steppable
  def pawn_moves(location, board_array, opponent, game_stats)
    result = []
    rank = location[0]
    file = location[1]
    direction = if opponent == 'white'
                  1
                else
                  -1
                end

    if in_bounds?(rank)
      result.push([rank + direction, file]) if board_array[rank + direction][file].nil?
      if starting_position?(opponent,
                            rank) && space_empty?(board_array, rank + direction,
                                                  file) && space_empty?(board_array, rank + (direction * 2), file)
        result.push([rank + (direction * 2),
                     file])
      end
      if in_bounds?(file - 1) && ((!space_empty?(board_array, rank + direction,
                                                 file - 1) && enemy_piece?(board_array, opponent, rank + direction,
                                                                           file - 1)) || en_passant?(rank + direction,
                                                                                                     file - 1, game_stats))
        result.push([rank + direction,
                     file - 1])
      end
      if in_bounds?(file + 1) && ((!space_empty?(board_array, rank + direction,
                                                 file + 1) && enemy_piece?(board_array, opponent, rank + direction,
                                                                           file + 1)) || en_passant?(rank + direction,
                                                                                                     file + 1, game_stats))
        result.push([rank + direction,
                     file + 1])
      end
    end
    result
  end

  def in_bounds?(position)
    position >= 0 && position <= 7
  end

  def starting_position?(opponent, rank)
    (rank == 6 && opponent == 'black') || (rank == 1 && opponent == 'white')
  end

  def space_empty?(board_array, rank, file)
    board_array[rank][file].nil?
  end

  def enemy_piece?(board_array, opponent, rank, file)
    board_array[rank][file].color == opponent
  end

  def en_passant?(rank, file, game_stats)
    move_to_algebraic([rank, file]) == game_stats[:en_passant][:algebraic]
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

  def king_moves(location, board_array, opponent, game_stats)
    directions = [[-1, 1], [1, 1], [1, -1], [-1, -1], [1, 0], [-1, 0], [0, 1], [0, -1]]
    rank = location[0]
    file = location[1]

    directions.map! do |direction|
      r_direction = direction[0]
      f_direction = direction[1]

      next if [rank + r_direction, file + f_direction].any? { |coordinate| coordinate < 0 || coordinate > 7 }

      if board_array[rank + r_direction][file + f_direction].nil? || board_array[rank + r_direction][file + f_direction].color == opponent
        [rank + r_direction, file + f_direction]
      end
    end

    castle = king_castle(opponent, board_array, game_stats)

    directions += castle unless castle.nil?

    directions
  end

  def king_castle(opponent, board_array, game_stats)
    result = []
    case opponent
    when 'black'
      player = :white
      rank = 7
    when 'white'
      player = :black
      rank = 0
    end

    if !game_stats[:castle][player][:king_side].nil? && board_array[rank][5].nil? &&
       board_array[rank][6].nil? && !check_square?([rank, 5], board_array, player.to_s)
      result << [rank, 6]
    end
    if !game_stats[:castle][player][:queen_side].nil? && board_array[rank][3].nil? &&
       board_array[rank][2].nil? && board_array[rank][1].nil? && !check_square?([rank, 3], board_array, player.to_s)
      result << [rank, 2]
    end
    result
  end

  def check_square?(square, board_array, current_color)
    board_array.flatten.compact.any? do |piece|
      next if piece.color == current_color || piece.possible == []

      piece.possible.include?(square)
    end
  end
end
