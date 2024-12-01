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

game = Game.new
game.game_loop
