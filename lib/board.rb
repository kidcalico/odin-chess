require_relative 'board_colors'
require_relative 'load_game'
require_relative 'piece'

# •
# BULLET
# Unicode: U+2022, UTF-8: E2 80 A2

class Board
  using BoardColors

  attr_accessor :board, :game_stats

  def initialize(board_array)
    @board = build_board(board_array)
  end

  def build_board(board_array)
    board_array = board_array.map.with_index do |rank, r_index|
      rank.map.with_index do |file, f_index|
        file = Piece.new(file, [r_index, f_index]) unless file.nil?
      end
    end
  end

  def print_board(color)
    print_ready = array_print_ready(@board)
    if color == 'w'
      print_ready.each_with_index { |pieces, rank| print_rank(8 - rank, pieces, color) }
      print "   a  b  c  d  e  f  g  h\n"
    else
      print_ready.reverse.each_with_index { |pieces, rank| print_rank(rank + 1, pieces, color) }
      print "   h  g  f  e  d  c  b  a\n"
    end
  end

  def print_rank(num, array, color)
    print "#{num} "

    board = piece_with_square(array, num)

    board.each { |square| print square } if color == 'w'
    board.reverse.each { |square| print square } if color == 'b'

    print "\n"
  end

  def piece_with_square(output, num)
    squares = []

    output.each_with_index do |piece, file|
      if num.odd?
        squares << " #{piece}".black_square if file.even?
        squares << " #{piece}".white_square if file.odd?
      else
        squares << " #{piece}".white_square if file.even?
        squares << " #{piece}".black_square if file.odd?
      end
    end
    squares
  end

  def array_print_ready(nested_array)
    result = nested_array.map { |array| array.map { |char| char_to_piece(char) } }
  end

  def char_to_piece(char)
    if char.nil?
      '  '
    elsif char.class == Piece && char.color == 'white'
      "#{char.symbol} ".white_piece
    elsif char.class == Piece && char.color == 'black'
      "#{char.symbol} ".black_piece
    end
  end
end
