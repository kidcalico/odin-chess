require_relative 'slideable'
require_relative 'steppable'
require_relative 'board_colors'

module Rules
  include Slideable
  include Steppable
  using BoardColors

  def possible_moves(location, board_array, opponent, game_stats)
    case board_array[location[0]][location[1]].type
    when 'pawn' then pawn_moves(location, board_array, opponent, game_stats)
    when 'knight' then knight_moves(location, board_array, opponent)
    when 'bishop' then bishop_moves(location, board_array, opponent)
    when 'rook' then rook_moves(location, board_array, opponent)
    when 'queen' then queen_moves(location, board_array, opponent)
    when 'king' then king_moves(location, board_array, opponent, game_stats)
    end
  end

  def half_move_tracker(move, captured, board_array, game_stats)
    if board_array[move[0]][move[1]].type == 'pawn' || !captured.nil?
      game_stats[:half_moves] = 0
    else
      game_stats[:half_moves] += 1
    end
  end

  def castle_stats(stats)
    { white: { king_side: stats[0], queen_side: stats[1] }, black: { king_side: stats[2], queen_side: stats[3] } }
  end

  def castle_tracker(origin, move, game_stats)
    piece = board.board[move[0]][move[1]]

    if piece.type == 'king'
      if piece.color == 'white'
        game_stats[:castle][:white][:king_side] = nil
        game_stats[:castle][:white][:queen_side] = nil
      else
        game_stats[:castle][:black][:king_side] = nil
        game_stats[:castle][:black][:queen_side] = nil
      end
    elsif piece.type == 'rook'
      game_stats[:castle][:white][:king_side] = nil if origin == [7, 7]
      game_stats[:castle][:white][:queen_side] = nil if origin == [7, 0]
      game_stats[:castle][:black][:king_side] = nil if origin == [0, 7]
      game_stats[:castle][:black][:queen_side] = nil if origin == [0, 0]
    end
  end

  def en_passant_tracker(piece, move, game_stats)
    game_stats[:en_passant] = { algebraic: '-', piece: '-', move: '-' } if game_stats[:en_passant][:algebraic] != '-'
    return unless board.board[move[0]][move[1]].type == 'pawn' && (piece[0] - move[0]).abs == 2

    en_passant_square(move, game_stats)
  end

  def en_passant_square(move, game_stats)
    algebraic = move_to_algebraic(move)
    i = 1 if algebraic[1] == '5'
    i = -1 if algebraic[1] == '4'
    algebraic[1] = (algebraic[1].to_i + i).to_s
    game_stats[:en_passant] = { algebraic: algebraic, move: [move[0] - i, move[1]], piece: move }
  end

  def move_to_algebraic(move)
    [(move[1] + 97).chr + (8 - move[0]).to_s].join
  end

  def check?(current_color, board, game_stats)
    board.each_with_index do |rank, r_index|
      rank.each_with_index do |piece, f_index|
        next if piece.nil? || piece.color == current_color

        moves = possible_moves([r_index, f_index], board, current_color, game_stats)

        next if moves == []

        moves.any? do |move|
          next if move.nil?
          next if board[move[0]][move[1]].nil?

          return true if board[move[0]][move[1]].type == 'king' && board[move[0]][move[1]].color == current_color
        end
      end
    end
    false
  end

  def notify_check(opponent)
    puts "Warning! The #{opponent} king is in check.".red_piece
  end

  def checkmate?(current_player, game_stats)
    return true if check?(current_player.color, board.board, game_stats) && mate?(current_player, game_stats)

    false
  end

  def stalemate?(current_player, game_stats)
    return true if mate?(current_player, game_stats) && cannot_move?(current_player)

    false
  end

  def cannot_move?(current_player)
    current_pieces = board.board.flatten.filter_map { |piece| piece if piece && piece.color == current_player.color }
    current_pieces.reject! { |piece| piece.type == 'king' }
    current_pieces.all? { |piece| piece.possible == [] }
  end

  def mate?(current_player, game_stats)
    king_location = find_king(current_player.color)
    moves = board.board[king_location[0]][king_location[1]].possible

    moves.compact.all? do |move|
      captured = board.make_move(king_location, move, game_stats)
      boolean = check?(current_player.color, board.board, game_stats)
      board.reset_move(king_location, move, captured)
      boolean
    end
  end

  def find_king(color)
    board.board.flatten.compact.each do |piece|
      return piece.location if piece.type == 'king' && piece.color == color
    end
  end
end
