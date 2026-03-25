require_relative 'moveable'

class Player
  include Moveable

  attr_accessor :color, :captured

  def initialize(color)
    @color = set_color(color)
    @captured = []
  end

  def set_color(color)
    return 'white' if color == 'w'

    'black'
  end

  def turn(board_array)
    possible_moves(get_input('piece'))
    # print possible moves
    get_input('move')
    # make move, end turn
  end

  def get_input(target)
    print "Where is the piece that you'd like to move? " if target == 'piece'
    print 'Where would you like to move? ' if target == 'move'
    algebraic = gets.chomp until !algebraic.nil? && algebraic.length == 2
    algebraic_to_coord(algebraic)
  end

  def algebraic_to_coord(algebraic)
    split = algebraic.split('')
    coord = [(8 - split[1].to_i), (split[0].downcase.ord - 97)]
  end

  def which_piece(coord, board_array)
    piece = board_array[coord[0]][coord[1]]
  end
end

# test = Player.new('w')
# p test.algebraic_to_coord('g5')
# p test.get_input

# def legal_moves(rank, square)
#   case @board_array[rank][square]
#   when 'P' then pawn_moves(rank, square)
#   when 'N' then knight_moves(rank, square)
#   when 'B' then bishop_moves(rank, square)
#   when 'R' then rook_moves(rank, square)
#   when 'Q' then queen_moves(rank, square)
#   when 'K' then king_moves(rank, square)
#   end
# end

# def pawn_moves(rank, square)
# end
