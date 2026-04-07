require 'pry-byebug'
require_relative 'board_colors'
require_relative 'board'
require_relative 'player'
require_relative 'rules'
require_relative 'save_load'

class Game
  NEW_GAME = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'.freeze

  using BoardColors
  include Rules
  include SaveLoad

  attr_accessor :game_array, :game_stats, :board, :white, :black

  def initialize(fen_code = NEW_GAME)
    @game_array = load_fen(fen_code)
    @board = Board.new(game_array[0])
    @game_stats = load_stats
    @white = Player.new('w')
    @black = Player.new('b')
  end

  def play_game
    start_game
    board_with_moves(board.board)
    current_player = set_current_player
    until checkmate?(current_player, game_stats) || stalemate?(current_player, game_stats)

      half_turn(current_player)
      print "\e[2J\e[f"
      game_stats[:full_moves] += 1 if current_player.color == 'black'

      current_player = set_current_player
    end
    end_game(current_player)
  end

  def set_current_player
    return white if game_stats[:turn] == 'white'

    black
  end

  def half_turn(current_player)
    turn_prompt(current_player)
    notify_check(current_player.color) if check?(current_player.color, board.board, game_stats)
    sleep 0.3
    choose_and_move(current_player)
    sleep 1
    game_stats[:turn] = current_player.opponent
  end

  def turn_prompt(current_player)
    board.print_board(current_player.color)
    if current_player.captured.length > 0
      print "#{current_player.color.capitalize} has captured: "
      current_player.captured.each { |piece| print piece.symbol.red_piece }
      print "\n"
    end
    print "#{current_player.color.capitalize} to play: "
  end

  def choose_and_move(current_player)
    captured = nil
    loop do
      piece = select_piece(current_player)
      save_game(board.board, game_stats) if piece == 'save'
      possible = possible_moves(piece, board.board, current_player.opponent, game_stats)
      board.display_moves(current_player.color, possible)

      if possible == []
        puts "You cannot move that #{board.board[piece[0]][piece[1]].type}."
        next
      end

      move = select_move(current_player, possible)

      captured = board.make_move(piece, move, game_stats)

      unless check?(current_player.color, board.board, game_stats)
        en_passant_tracker(piece, move, game_stats)
        castle_tracker(piece, move, game_stats)
        board_with_moves(board.board)
        break
      end

      board.reset_move(piece, move, captured)

      board.print_board(current_player.color)
      puts 'That puts you in check! Try another move.'
    end
    board.print_board(current_player.color)

    return if captured.nil?

    puts "#{current_player.color.capitalize} captured a #{current_player.opponent} #{captured.type}!"
    current_player.captured.push(captured)
  end

  def select_piece(current_player)
    loop do
      piece = current_player.get_input('piece')
      return piece if piece == 'save'
      unless board.board[piece[0]][piece[1]].nil? || board.board[piece[0]][piece[1]].color != current_player.color
        return piece
      end

      puts "Please select a #{current_player.color} piece."
    end
  end

  def select_move(current_player, possible)
    loop do
      move = current_player.get_input('move')
      return move if possible.include?(move)

      puts 'You cannot move there, please select from the given options.'
    end
  end

  def load_fen(fen_code)
    result = fen_code.split(' ')
    result[0] = num_to_empties(result[0].split('/').map { |block| block.split('') })
    result
  end

  def load_stats
    { turn: load_turn(game_array[1]), castle: castle_stats(game_array[2]), en_passant: { algebraic: game_array[3], move: '-', piece: '-' },
      half_moves: game_array[4].to_i, full_moves: game_array[5].to_i }
  end

  def load_turn(turn)
    return 'white' if turn == 'w'

    'black'
  end

  def num_to_empties(fen_code)
    fen_code.map do |rank|
      rank.map do |square|
        next [nil] * square.to_i if /^[1-8]$/.match?(square)

        square
      end.flatten
    end
  end

  def start_game
    print "\e[2J\e[f"
    puts 'Welcome to Chess in the Terminal, coded in Ruby.'
    puts 'Game to be played using algebraic coordinates:'
    puts 'Enter your moves using a letter (a-h) followed by a number (1-8).'
    puts "For example: 'd2' (to select piece), then 'd3' (move to d3)."
    puts "'save' => save and exit"
    puts "'exit' => exit game without saving"
    puts 'Enjoy your game :)'
    sleep 1
  end

  def board_with_moves(board)
    board.flatten.each do |square|
      next if square.nil?

      square.possible = if square.color == 'white'
                          possible_moves(square.location, board, 'black', game_stats)
                        else
                          possible_moves(square.location, board, 'white', game_stats)
                        end
    end
  end

  def end_game(current_player)
    if check?(current_player.color, board.board, game_stats)
      puts "#{current_player.opponent.capitalize} is the winner! Congratulations!!!"
    else
      puts 'Stalemate. Maybe you want a rematch?'
    end
  end
end

# test = Game.new
# test.play_game
