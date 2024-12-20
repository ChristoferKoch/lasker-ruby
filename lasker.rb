require_relative './lib/display_elements.rb'
require_relative './lib/bit_manipulations.rb'
require_relative './lib/encode.rb'
require_relative './lib/piece.rb'
require_relative './lib/pieces/pawn.rb'
require_relative './lib/pieces/rook.rb'
require_relative './lib/pieces/knight.rb'
require_relative './lib/pieces/bishop.rb'
require_relative './lib/pieces/queen.rb'
require_relative './lib/pieces/king.rb'
require_relative './lib/moves.rb'
require_relative './lib/board.rb'
require_relative './lib/game.rb'

include DisplayElements

system("clear")
print_header
print_decorative_board
print_menu
game_type = gets.chomp
while game_type != '1' && game_type != '2'
  print "\tInvalid input (1 or 2): "
  game_type = gets.chomp
end
if game_type == '1'
  game = Game.new
else
  system("clear")
  print_header
  print_decorative_board
  print_color_select
  color = gets.chomp
  while color != '1' && color != '2'
    print "\tInvalid input (1 or 2): "
    color = gets.chomp
  end
  game = Game.new(color)
end

game.game_loop
