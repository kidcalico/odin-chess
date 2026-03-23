require 'pry-byebug'
require_relative 'board'
require_relative 'load_game'
require_relative 'player'

class Game
  attr_accessor :board, :game_stats

  def initialize
    @game = LoadGame.new
    @board = Board.new(@game.matrix_notation)
    @game_stats = @game.game_stats
    load_stats
  end

  def load_stats
    @turn = @game_stats[:turn]
    @castle = @game_stats[:castle]
    @en_passant = @game_stats[:en_passant]
    @half_moves = @game_stats[:half_moves]
    @full_moves = @game_stats[:full_moves]
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
test.board.print_board('b')
p test.board.board[7][3].symbol
p test.board.board[1][0].legal_moves
