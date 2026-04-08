require 'rubocop'
require 'pry-byebug'
require_relative 'lib/game'

include SaveLoad

print "\e[2J\e[f"
puts 'Welcome to Chess in the Command Line, coded by Kid Calico using Ruby.'
puts 'Please select from the following options:'
puts '[N]ew game / [L]oad a saved game / [F]EN'
game = Game.new
loop do
  print "Please type 'N', 'L' or 'F': "
  choice = gets.chomp
  if choice[0].upcase == 'N'
    game.play_game
    break
  elsif choice[0].upcase == 'L'
    game.load_game
    break
  elsif choice[0].upcase == 'F'
    print 'Enter FEN code: '
    fen = gets.chomp
    game = Game.new(fen)
    game.play_game
    break
  else
    puts 'Invalid input, please try again.'
  end
end
