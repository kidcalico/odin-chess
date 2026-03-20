require_relative 'board_colors'
# require_relative 'pieces'
# •
# BULLET
# Unicode: U+2022, UTF-8: E2 80 A2

class Board
  using BoardColors

  def initialize(piece_matrix)
    @piece_matrix = piece_matrix
    # print_board
  end

  def print_board_white
    @piece_matrix.each_with_index { |pieces, rank| print_rank(8 - rank, pieces, 'w') }
    print "   a  b  c  d  e  f  g  h\n"
    # @piece_matrix.each { |row| p row }
  end

  def print_board_black
    @piece_matrix.reverse.each_with_index { |pieces, rank| print_rank(rank + 1, pieces, 'b') }
    print "   h  g  f  e  d  c  b  a\n"
    # @piece_matrix.each { |row| p row }
  end

  def print_rank(num, array, color)
    print "#{num} "

    output = array.map do |char|
      char_to_piece(char)
    end

    board = piece_with_square(output, num)

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

  def char_to_piece(char)
    case char
    when ' '
      '  '
    when 'k'
      "\u265A ".black_piece
    when 'K'
      "\u265A ".white_piece
    when 'q'
      "\u265B ".black_piece
    when 'Q'
      "\u265B ".white_piece
    when 'r'
      "\u265C ".black_piece
    when 'R'
      "\u265C ".white_piece
    when 'b'
      "\u265D ".black_piece
    when 'B'
      "\u265D ".white_piece
    when 'n'
      "\u265E ".black_piece
    when 'N'
      "\u265E ".white_piece
    when 'p'
      "\u265F ".black_piece
    when 'P'
      "\u265F ".white_piece
    end
  end
end
