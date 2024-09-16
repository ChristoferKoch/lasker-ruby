class Board
  include DisplayBitboard

  attr_reader :white_pawns, :black_pawns, :white_knights, :black_knights, :white_bishops, :black_bishops, :white_rooks, :black_rooks, :white_queen, :black_queen, :white_king, :black_king, :white_occupancy, :black_occpancy

  def initialize
    @white_pawns = Pawn.new('white')
    @black_pawns = Pawn.new('black')
    @white_knights = Knight.new('white')
    @black_knights = Knight.new('black')
    @white_bishops = Bishop.new('white')
    @black_bishops = Bishop.new('black')
    @white_rooks = Rook.new('white')
    @black_rooks = Rook.new('black')
    @white_queen = Queen.new('white')
    @black_queen = Queen.new('black')
    @white_king = King.new('white')
    @black_king = King.new('black')
    occupancy
  end

  def occupancy
    @white_occupancy = @white_pawns.bitboard
    @white_occupancy |= @white_knights.bitboard
    @white_occupancy |= @white_bishops.bitboard
    @white_occupancy |= @white_rooks.bitboard
    @white_occupancy |= @white_queen.bitboard
    @white_occupancy |= @white_king.bitboard
    @black_occupancy = @black_pawns.bitboard
    @black_occupancy |= @black_knights.bitboard
    @black_occupancy |= @black_bishops.bitboard
    @black_occupancy |= @black_rooks.bitboard
    @black_occupancy |= @black_queen.bitboard
    @black_occupancy |= @black_king.bitboard
  end

  def display_gameboard
    @gameboard = Array.new(64, ' ')
    place_tokens(@white_pawns)
    place_tokens(@black_pawns)
    place_tokens(@white_knights)
    place_tokens(@black_knights)
    place_tokens(@white_bishops)
    place_tokens(@black_bishops)
    place_tokens(@white_rooks)
    place_tokens(@black_rooks)
    place_tokens(@white_queen)
    place_tokens(@black_queen)
    place_tokens(@white_king)
    place_tokens(@black_king)
    print_gameboard
  end

  def place_tokens(pieces)
    indicies = pieces.get_indicies
    indicies.each { |piece| @gameboard[piece] = pieces.token}
  end

  def print_gameboard
    index = 56
    rank = 8

    puts "   +---+---+---+---+---+---+---+---+"
    
    while rank > 0
      line = line_spacing(@gameboard[index, 8].reverse.join, false)
      puts "#{rank}  | #{line} |"
      puts "   +---+---+---+---+---+---+---+---+"
      index -= 8
      rank -= 1
    end

    puts "\n     a   b   c   d   e   f   g   h"
  end
end
