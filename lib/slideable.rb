module Slideable
  DIAGONAL_DIRECTIONS = [[-1, 1], [1, 1], [1, -1], [-1, -1]]
  LATERAL_DIRECTIONS = [[1, 0], [-1, 0], [0, 1], [0, -1]]

  def bishop_moves(location, board_array, opponent)
    directions = DIAGONAL_DIRECTIONS
    slide(location, board_array, opponent, directions)
  end

  def rook_moves(location, board_array, opponent)
    directions = LATERAL_DIRECTIONS
    slide(location, board_array, opponent, directions)
  end

  def queen_moves(location, board_array, opponent)
    directions = LATERAL_DIRECTIONS + DIAGONAL_DIRECTIONS
    slide(location, board_array, opponent, directions)
  end

  private

  def slide(location, board_array, opponent, directions)
    result = []

    rank = location[0]
    file = location[1]

    directions.each do |direction|
      r_direction = direction[0]
      f_direction = direction[1]
      loop do
        if (rank + r_direction < 0 || rank + r_direction > 7) || (file + f_direction < 0 || file + f_direction > 7)
          break
        end

        if board_array[rank + r_direction][file + f_direction].nil? || board_array[rank + r_direction][file + f_direction].color == opponent
          result << [rank + r_direction,
                     file + f_direction]
        end
        break unless board_array[rank + r_direction][file + f_direction].nil?

        r_direction += direction[0]
        f_direction += direction[1]
      end
    end
    result
  end
end
