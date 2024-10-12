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
    moves = 0
    indicies = get_indicies
    indicies.each do |index|
      if !pinned?(same_occupancy | diff_occupancy, opp_pieces, king, index)
        moveboard = move_mask(1 << index)
        same_blockerboard = moveboard & same_occupancy
        diff_blockerboard = moveboard & diff_occupancy
        blockerboard = same_blockerboard | diff_blockerboard
        moves |= blockerboard > 0 ? unblocked_moves(same_blockerboard, diff_blockerboard) : moveboard
        moves |= king.in_check ? moves & king.checkboard : moves
      end
    end
    return moves
  end

  # Determines if piece is pinned
  def pinned?(occupancy, attackers, king, index)
    attackers.each_value do |piece|
      if piece.is_a?(Rook) || piece.is_a?(Bishop) || piece.is_a?(Queen)
        if piece.attackboard & king.bitboard > 0
          rayboard = get_ray(piece.get_indicies, king.get_indicies[0])
          pieceboard = 1 << index
          if rayboard & pieceboard > 0
            rayboard = get_ray(piece.bitboard, index)
            if rayboard & occupancy == 0
              return true
            end
          end
        end
      end
    end
    return false
  end

end
