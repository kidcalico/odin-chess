require_relative 'board_colors'
require_relative 'piece'

class Board
  using BoardColors

  attr_accessor :board, :game_stats

  def initialize(board_array)
    @board = build_board(board_array)
  end

  def make_move(piece, move)
    captured = nil

    captured = board[move[0]][move[1]] unless board[move[0]][move[1]].nil?
    board[move[0]][move[1]] = board[piece[0]][piece[1]]
    board[piece[0]][piece[1]] = nil

    captured
  end

  def build_board(board_array)
    board_array = board_array.map.with_index do |rank, r_index|
      rank.map.with_index do |piece, s_index|
        piece = Piece.new(piece, [r_index, s_index]) unless piece.nil?
      end
    end
  end

  def display_moves(color, moves)
    print_ready = array_print_ready(board)
    bullet = "\u2022 "
    print_ready = print_ready.map.with_index do |rank, r_index|
      rank.map.with_index do |file, f_index|
        next file unless moves.any? { |move| move == [r_index, f_index] }

        next bullet.red_piece if file == '  '

        "#{file[10]} ".red_piece
      end
    end
    print_array(color, print_ready)
  end

  def print_board(color)
    print_ready = array_print_ready(board)
    print_array(color, print_ready)
  end

  def print_array(color, array)
    if color == 'white'
      print "   a  b  c  d  e  f  g  h\n"
      array.each_with_index { |pieces, rank| print_rank(8 - rank, pieces, color) }
      print "   a  b  c  d  e  f  g  h\n"
    else
      print "   h  g  f  e  d  c  b  a\n"
      array.reverse.each_with_index { |pieces, rank| print_rank(rank + 1, pieces, color) }
      print "   h  g  f  e  d  c  b  a\n"
    end
  end

  def print_rank(num, array, color)
    print "#{num} "

    board = piece_with_square(array, num)

    board.each { |square| print square } if color == 'white'
    board.reverse.each { |square| print square } if color == 'black'

    print " #{num}\n"
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
