require 'pry-byebug'
require_relative 'board_colors'
require_relative 'board'
require_relative 'player'
require_relative 'rules'

class Game
  NEW_GAME = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'.freeze
  TEST_GAME = '1r6/5pp1/R1R4p/1r1pP3/2pkQPP1/7P/1P6/2K5 w - - 0 41'
  SAVED_GAME = 'r1bqkbnr/ppp2ppp/2np4/4p3/3PP3/5N2/PPP2PPP/RNBQKB1R w KQkq - 2 4'

  using BoardColors
  include Rules

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
    until checkmate?(game_stats[:turn]) == true || stalemate?(game_stats[:turn]) == true
      notify_check if check?(game_stats[:turn]) == true

      current_player = if game_stats[:turn] == 'white'
                         white
                       else
                         black
                       end

      half_turn(current_player)
      game_stats[:full_moves] += 1 if current_player.color == 'black'

    end
    end_game
  end

  def half_turn(current_player)
    turn_prompt(current_player)
    sleep 0.1
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
    piece = select_piece(current_player)
    possible = possible_moves(piece, board.board, current_player.opponent)
    board.display_moves(current_player.color, possible)
    move = select_move(current_player, possible)
    captured = board.make_move(piece, move)
    board.print_board(current_player.color)
    en_passant_tracker(piece, move)
    return if captured.nil?

    puts "#{current_player.color.capitalize} captured a #{current_player.opponent} #{captured.type}!"
    current_player.captured.push(captured)
  end

  def select_piece(current_player)
    loop do
      piece = current_player.get_input('piece')
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
    { turn: load_turn(game_array[1]), castle: game_array[2], en_passant: game_array[3],
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
    puts "\e[2J\e[fWelcome to Chess in the Terminal, coded in Ruby."
    puts 'Game to be played using algebraic coordinates:'
    puts 'Enter your moves using a letter (a-h) followed by a number (1-8).'
    puts "For example: 'd2' (to select piece) and 'd3' (move to d3)."
    puts 'Enjoy your game :)'
    sleep 1
  end

  def end_game
  end
end

test = Game.new
p test.game_stats
test.play_game
