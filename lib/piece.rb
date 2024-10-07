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
    indicies = get_indicies
    indicies.each do |index|
      if !pinned?(same_occupancy | diff_occupancy, opp_pieces, king.bitboard, index)
        moveboard = move_mask(1 << index)
        same_blockerboard = moveboard & same_occupancy
        diff_blockerboard = moveboard & diff_occupancy
        blockerboard = same_blockerboard | diff_blockerboard
        moves = blockerboard > 0 ? unblocked_moves(same_blockerboard, diff_blockerboard) : moveboard
        moves = king.in_check ? moves & king.checkboard : moves
      end
    end
  end

  def pinned?(occupancy, attackers, king_position, pieceboard)
    attackers.each_value do |piece|
      if piece.is_a?(Rook) || piece.is_a?(Bishop) || piece.is_a?(Queen)
        if piece.attackboard & king_position > 0
          rayboard = get_ray(piece.attackboard, king_position)
          if rayboard & pieceboard > 0
            rayboard = get_ray(piece.bitboard, pieceboard)
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
