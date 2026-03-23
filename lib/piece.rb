class Piece
  attr_reader :color, :type, :symbol, :location

  def initialize(type, location)
    @color = which_color(type)
    @type = which_type(type.downcase)
    @symbol = to_symbol(@type)
    @location = location
  end

  def which_color(type)
    return 'white' if type == type.upcase

    'black'
  end

  def which_type(type)
    case type
    when 'p' then 'pawn'
    when 'n' then 'knight'
    when 'b' then 'bishop'
    when 'r' then 'rook'
    when 'q' then 'queen'
    when 'k' then 'king'
    end
  end

  def to_symbol(type)
    case type
    when 'pawn' then "\u265F"
    when 'knight' then "\u265E"
    when 'bishop' then "\u265D"
    when 'rook' then "\u265C"
    when 'queen' then "\u265B"
    when 'king' then "\u265A"
    end
  end

  def legal_moves
    case type
    when 'pawn' then pawn_moves
    when 'knight' then knight_moves
    when 'bishop' then bishop_moves
    when 'rook' then rook_moves
    when 'queen' then queen_moves
    when 'king' then king_moves
    end
  end

  private

  def pawn_moves
    result = []
    if location[0] == 6 && color == 'white'
      result.push([location[0] - 1, location[1]],
                  [location[0] - 2, location[1]])
    elsif location[0] == 1 && color == 'black'
      result.push([location[0] + 1, location[1]],
                  [location[0] + 2, location[1]])
    elsif color == 'white'
      result = [location[0] - 1, location[1]]
    elsif color == 'black'
      result = [location[0] + 1, location[1]]
    end
    # add attack conditions, limit results to board coordinates and occupied squares for non attacks
    result
  end

  def knight_moves(square)
    [
      [square[0] + 1, square[1] + 2], [square[0] - 1, square[1] + 2],
      [square[0] + 1, square[1] - 2], [square[0] - 1, square[1] - 2],
      [square[0] + 2, square[1] + 1], [square[0] + 2, square[1] - 1],
      [square[0] - 2, square[1] + 1], [square[0] - 2, square[1] - 1]
    ]
  end

  def bishop_moves
  end

  def rook_moves
  end

  def queen_moves
  end

  def king_moves
  end
end
