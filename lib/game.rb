require_relative 'board'
require_relative 'load_game'
require_relative 'player'

class Game
  attr_accessor :board

  def initialize(game = LoadGame.new)
    @game = game
    load_stats(@game)
    @board = Board.new(@piece_matrix)
    @white = Player.new('w', @piece_matrix)
    @black = Player.new('b', @piece_matrix)
    # check_status?(@turn)
    # play_game
  end

  def load_stats(game)
    @piece_matrix = @game.matrix_notation
    @to_play = @white if game.to_play == 'w'
    @to_play = @black if game.to_play == 'b'
    @castle = game.can_castle
    @en_passant = game.en_passant
    @halfmove_clock = game.halfmove_clock
    @fullmove_num = game.fullmove_num
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
