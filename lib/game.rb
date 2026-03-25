require 'pry-byebug'
require_relative 'board'
require_relative 'load_game'
require_relative 'player'

class Game
  NEW_GAME = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1'.freeze
  TEST_GAME = '1r6/5pp1/R1R4p/1r1pP3/2pkQPP1/7P/1P6/2K5 w - - 0 41'
  # SAVED_GAME = 'r1bqkbnr/ppp2ppp/2np4/4p3/3PP3/5N2/PPP2PPP/RNBQKB1R w KQkq - 2 4'

  attr_accessor :game, :game_stats, :board_array, :board

  def initialize(fen_code = TEST_GAME)
    @game_array = load_fen(fen_code)
    @board_array = @game[0]
    @board = Board.new(board_array)
    @game_stats = load_stats
  end

  def load_fen(fen_code)
    result = fen_code.split(' ')
    result[0] = num_to_empties(result[0].split('/').map { |block| block.split('') })
    result
  end

  def load_stats
    { turn: game[1], castle: game[2], en_passant: game[3],
      half_moves: game[4], full_moves: game[5] }
  end

  def num_to_empties(fen_code)
    fen_code.map do |rank|
      rank.map do |square|
        next [nil] * square.to_i if /^[1-8]$/.match?(square)

        square
      end.flatten
    end
  end

  def play_game
  end

  def move(color)
  end

  def check?(color)
  end

  def checkmate?(color)
  end
end

test = Game.new

p test.board_array
p test.board
test.board.print_board('w')
p test.game_stats
