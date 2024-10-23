require_relative './lib/display_bitboard.rb'
require_relative './lib/piece.rb'
require_relative './lib/pieces/pawn.rb'
require_relative './lib/pieces/rook.rb'
require_relative './lib/pieces/knight.rb'
require_relative './lib/pieces/bishop.rb'
require_relative './lib/pieces/queen.rb'
require_relative './lib/pieces/king.rb'
require_relative './lib/board.rb'
require_relative './lib/game.rb'

game = Game.new
game.game_loop
loop do
  board.board.display_gameboard
  p board.board.move_list
  puts "Move:"
  move = gets
  move = move.to_i
  while !board.board.move_list.include?(move)
    puts "Illegal move, please try again:"
    move = gets
    move = move.to_i
  end
  break
end

