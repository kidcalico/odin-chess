require 'pry-byebug'
require_relative 'board'
require_relative 'load_game'
require_relative 'player'

class Game
  attr_accessor :board

  def initialize
    @game = Board.new
    load_stats(@game)
    # binding.pry
    # @white = Player.new('w', @piece_matrix)
    # @black = Player.new('b', @piece_matrix)
    # check_status?(@turn)
    # play_game
  end

  def load_stats(game)
    @piece_matrix = @game.board
    @turn = @game.game_stats.turn
    @castle = @game.game_stats.castle
    @en_passant = @game.game_stats.en_passant
    @half_moves = @game.game_stats.half_moves
    @full_moves = @game.game_stats.full_moves
  end

  def play_game
    # unless @check_status(@to_play) == 'Checkmate'
    #   move(@to_play)
    # end
  end

  def move(color)
    # get input and make move (call Player)
    # change turn to other color
    # print board
  end

  def check_status(color)
    @check = false
  end
end

Game.new
