module Slideable
  def bishop_moves(location, board_array, opponent)
    diagonal_slide(location, board_array, opponent)
  end

  def diagonal_slide(location, board_array, opponent)
    result = []

    rank = location[0]
    file = location[1]

    directions = [[-1, +1], [+1, +1], [+1, -1], [-1, -1]]

    directions.each do |direction|
      x = direction[0]
      y = direction[1]
      loop do
        break if (rank + x < 0 || rank + x > 7) || (file + y < 0 || file + y > 7)

        if board_array[rank + x][file + y].nil? || board_array[rank + x][file + y].color == opponent
          result << [rank + x,
                     file + y]
        end
        break unless board_array[rank + x][file + y].nil?

        x += direction[0]
        y += direction[1]
      end
    end
    result
  end

  def rook_moves
    result = []
  end

  def queen_moves
  end
end
