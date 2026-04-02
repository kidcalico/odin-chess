require_relative 'rules'

class Piece
  include Rules

  attr_reader :color, :type, :symbol
  attr_accessor :location, :game_stats

  def initialize(type, location)
    @color = which_color(type)
    @type = which_type(type.downcase)
    @symbol = to_symbol(@type)
    @location = location
    @possible = []
    @game_stats = nil
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

  def possible(board_array, opponent, stats)
    @game_stats = stats
    possible_moves(location, board_array, opponent)
  end
end
