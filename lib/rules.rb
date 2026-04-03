require_relative 'slideable'
require_relative 'steppable'

module Rules
  include Slideable
  include Steppable
  using BoardColors

  def possible_moves(location, board_array, opponent)
    case board_array[location[0]][location[1]].type
    when 'pawn' then pawn_moves(location, board_array, opponent)
    when 'knight' then knight_moves(location, board_array, opponent)
    when 'bishop' then bishop_moves(location, board_array, opponent)
    when 'rook' then rook_moves(location, board_array, opponent)
    when 'queen' then queen_moves(location, board_array, opponent)
    when 'king' then king_moves(location, board_array, opponent)
    end
  end

  def castle_stats(stats)
    { white: { king_side: stats[0], queen_side: stats[1] }, black: { king_side: stats[2], queen_side: stats[3] } }
  end

  def castle_tracker(color)
  end

  def en_passant_tracker(piece, move)
    game_stats[:en_passant] = { algebraic: '-', piece: '-', move: '-' } if game_stats[:en_passant][:algebraic] != '-'
    return unless board.board[move[0]][move[1]].type == 'pawn' && (piece[0] - move[0]).abs == 2

    en_passant_square(move)
  end

  def en_passant_square(move)
    algebraic = move_to_algebraic(move)
    i = 1 if algebraic[1] == '5'
    i = -1 if algebraic[1] == '4'
    algebraic[1] = (algebraic[1].to_i + i).to_s
    game_stats[:en_passant] = { algebraic: algebraic, move: [move[0] - i, move[1]], piece: move }
  end

  def move_to_algebraic(move)
    [(move[1] + 97).chr + (8 - move[0]).to_s].join
  end

  def check?(current_color)
    board.board.each_with_index do |rank, r_index|
      rank.each_with_index do |piece, f_index|
        next if piece.nil? || piece.color == current_color

        moves = possible_moves([r_index, f_index], board.board, current_color)

        next if moves == []

        moves.any? do |move|
          next if move.nil?
          next if board.board[move[0]][move[1]].nil?

          if board.board[move[0]][move[1]].type == 'king' && board.board[move[0]][move[1]].color == current_color
            return true
          end
        end
      end
    end
    false
  end

  def check_square?(square, current_color)
    board.board.each_with_index do |rank, r_index|
      rank.each_with_index do |piece, f_index|
        next if piece.nil? || piece.color == current_color

        moves = possible_moves([r_index, f_index], board.board, current_color)

        next if moves == []

        return true if moves.include?(square)
      end
    end
    false
  end

  def notify_check(opponent)
    puts "Warning! The #{opponent} king is in check.".red_piece
  end

  def checkmate?(color)
    false
  end

  def stalemate?(current_color)
    king = find_king(current_color)
    moves = possible_moves(king, board.board, current_color)
    moves.all? { |move| check_square?(move, current_color) }
  end

  def find_king(color)
    location = nil
    board.board.each do |rank|
      rank.each do |piece|
        location = piece.location if !piece.nil? && piece.type == 'king' && piece.color == color
      end
    end
    location
  end
end
