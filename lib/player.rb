class Player
  attr_accessor :color, :opponent, :captured

  def initialize(color)
    @color = set_color(color)
    @opponent = set_opponent(color)
    @captured = []
  end

  def set_color(color)
    return 'white' if color == 'w'

    'black'
  end

  def set_opponent(color)
    return 'white' if color == 'b'

    'black'
  end

  def get_input(target)
    algebraic = nil
    loop do
      print "Where is the piece that you'd like to move? " if target == 'piece'
      print 'Where would you like to move? ' if target == 'move'
      algebraic = gets.chomp
      break if input_valid?(algebraic)
    end
    algebraic_to_coord(algebraic)
  end

  def input_valid?(input)
    return true if input.length == 2 && input[0].match?(/[a-h]/i) && input[1].match?(/^[1-8]$/)

    false
  end

  def algebraic_to_coord(algebraic)
    split = algebraic.split('')
    coord = [(8 - split[1].to_i), (split[0].downcase.ord - 97)]
  end

  def which_piece(coord, board_array)
    piece = board_array[coord[0]][coord[1]]
  end
end
