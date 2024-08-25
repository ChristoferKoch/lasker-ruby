require_relative './lib/spacing.rb'
require_relative './lib/piece.rb'
require_relative './lib/pieces/pawn.rb'
require_relative './lib/pieces/rook.rb'
require_relative './lib/pieces/knight.rb'
require_relative './lib/pieces/bishop.rb'
require_relative './lib/pieces/queen.rb'
require_relative './lib/pieces/king.rb'

pawn = King.new('black')

pawn.display_bitboard(pawn.bitboard)
pawn.display_bitboard(pawn.attackboard)
