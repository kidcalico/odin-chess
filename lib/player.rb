# require_relative 'pieces'

class Player
  WHITE_PIECES = %w[K Q R B N P]
  BLACK_PIECES = %w[k q r b n p]

  def initialize(color, board_array = nil)
    @board_array = board_array
    @moveable = WHITE_PIECES if color == 'w'
    @moveable = BLACK_PIECES if color == 'b'
    @legal_moves = []
  end

  def get_input
    print "Where is the piece that you'd like to move? "
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

  def find_pieces(player)
    @board_array.each do |rank|
      rank.each do |square|
        legal_moves(rank, square) if pieces.include?(square)
      end
    end
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
