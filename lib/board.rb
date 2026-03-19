require_relative 'board_colors'
require_relative 'pieces'

class Board
  using BoardColors

  def initialize
    @pieces = Pieces.new
    @piece_matrix = @pieces.matrix_notation
    print_board
  end

  def print_board
    @piece_matrix.each_with_index do |pieces, rank|
      rank = 8 - rank
      print_rank(rank, pieces)
    end
    print "   a  b  c  d  e  f  g  h\n"
    # @piece_matrix.each { |row| p row }
  end

  def print_rank(num, array)
    print "#{num} "

    output = array.map do |char|
      char_to_piece(char)
    end

    output.each_with_index do |piece, file|
      if num.odd?
        print " #{piece}".black_square if file.even?
        print " #{piece}".white_square if file.odd?
      else
        print " #{piece}".white_square if file.even?
        print " #{piece}".black_square if file.odd?
      end
    end

    print "\n"
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
