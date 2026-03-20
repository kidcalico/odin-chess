require 'rubocop'
require 'pry-byebug'
require_relative 'lib/game'

test = Game.new

test.board.print_board_white
test.board.print_board_black
