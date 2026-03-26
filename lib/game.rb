require 'pry-byebug'
require_relative 'board'
require_relative 'player'
require_relative 'rules'

class Game
  NEW_GAME = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'.freeze
  TEST_GAME = '1r6/5pp1/R1R4p/1r1pP3/2pkQPP1/7P/1P6/2K5 w - - 0 41'
  SAVED_GAME = 'r1bqkbnr/ppp2ppp/2np4/4p3/3PP3/5N2/PPP2PPP/RNBQKB1R w KQkq - 2 4'

  include Rules

  attr_accessor :game_array, :game_stats, :board, :white, :black

  def initialize(fen_code = SAVED_GAME)
    @game_array = load_fen(fen_code)
    @board = Board.new(game_array[0])
    @game_stats = load_stats
    @white = Player.new('w')
    @black = Player.new('b')
  end

  def test
    move = white.get_input('piece')
    possible_moves(move, board.board, 'black')
  end

  def play_game
    until checkmate?(game_stats[:turn]) == true
      check_prompt if check?(game_stats[:turn]) == true

      if game_stats[:turn] == 'w'
        board.print_board('w')
        white.turn(board)
      else
        board.print_board('b')
        black.turn(board)
      end
    end
    end_game
  end

  def load_fen(fen_code)
    result = fen_code.split(' ')
    result[0] = num_to_empties(result[0].split('/').map { |block| block.split('') })
    result
  end

  def load_stats
    { turn: game_array[1], castle: game_array[2], en_passant: game_array[3],
      half_moves: game_array[4], full_moves: game_array[5] }
  end

  def num_to_empties(fen_code)
    fen_code.map do |rank|
      rank.map do |square|
        next [nil] * square.to_i if /^[1-8]$/.match?(square)

        square
      end.flatten
    end
  end

  def end_game
  end
end
