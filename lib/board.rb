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

  def display_game_board
    
  end
end
