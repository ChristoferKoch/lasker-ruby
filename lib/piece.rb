class Piece
  include DisplayBitboard

  attr_accessor :bitboard
  attr_reader :color, :attackboard, :token

  NOT_A_FILE = 0b0111111101111111011111110111111101111111011111110111111101111111
  NOT_H_FILE = 0b1111111011111110111111101111111011111110111111101111111011111110
  COMPARISON = 0b1111111111111111111111111111111111111111111111111111111111111111
 
  def initialize(color)
    @color = color
    @attackboard = attack_mask
  end

  # Works only for sliding pieces. Knights, pawns, and kings need unique functions
  def moves(same_occupancy, diff_occupancy, opp_pieces, king)
    if pinned?(same_occupancy | diff_occupancy, opp_pieces, king.bitboard)
      return 0
    end
    same_blockerboard = @attackboard & same_occupancy
    diff_blockerboard = @attackboard & diff_occupancy
    blockerboard = same_blockerboard | diff_blockerboard
    moves = blockerboard > 0 ? unblocked_moves(same_blockerboard, diff_blockerboard) : @attackboard
    moves = king.in_check ? moves & king.chekboard : moves
  end
end
