require_relative 'board_colors'
require_relative 'piece'
require_relative 'rules'

class Board
  include Rules
  using BoardColors

  attr_accessor :board

  def initialize(board_array)
    @board = build_board(board_array)
  end

  def make_move(piece, move, game_stats)
    captured = nil

    if move == game_stats[:en_passant][:move]
      en_passant_pawn = game_stats[:en_passant][:piece]
      captured = board[en_passant_pawn[0]][en_passant_pawn[1]]
      board[en_passant_pawn[0]][en_passant_pawn[1]] = nil
    elsif board[piece[0]][piece[1]].type == 'pawn' && board[piece[0]][piece[1]].color == 'black' && move[0] == 7
      convert_pawn(piece, 'black') unless check?('black', board, game_stats)
    elsif board[piece[0]][piece[1]].type == 'pawn' && board[piece[0]][piece[1]].color == 'white' && move[0] == 0
      convert_pawn(piece, 'white') unless check?('white', board, game_stats)
    elsif board[piece[0]][piece[1]].type == 'king' && (piece[1] - move[1]).abs == 2
      castle_wrap(move, game_stats)
    end
    captured = board[move[0]][move[1]] unless board[move[0]][move[1]].nil?
    board[move[0]][move[1]] = board[piece[0]][piece[1]]
    board[move[0]][move[1]].location = move

    board[piece[0]][piece[1]] = nil

    captured
  end

  def convert_pawn(location, color)
    loop do
      print 'Convert to queen [q], rook [r], bishop [b] or knight [k]? '
      choice = gets.chomp
      next puts 'Please type [q], [r], [b], or [k]' unless %w[q r b k].include?(choice[0].downcase)

      piece = choice[0].downcase
      piece = 'n' if piece == 'k'
      piece = piece.upcase if color == 'white'
      board[location[0]][location[1]] = Piece.new(piece, location)
      break
    end
  end

  def castle_wrap(move, game_stats)
    case move
    when [0, 2] then make_move([0, 0], [0, 3], game_stats)
    when [0, 6] then make_move([0, 7], [0, 5], game_stats)
    when [7, 2] then make_move([7, 0], [7, 3], game_stats)
    when [7, 6] then make_move([7, 7], [7, 5], game_stats)
    end
  end

  def reset_move(piece, move, captured)
    board[piece[0]][piece[1]] = board[move[0]][move[1]]
    board[piece[0]][piece[1]].location = piece
    board[move[0]][move[1]] = captured
    return if captured.nil?

    board[move[0]][move[1]].location = move
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
