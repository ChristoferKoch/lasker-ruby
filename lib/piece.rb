class Piece
  include BitManipulations

  attr_accessor :bitboard, :attackboard
  attr_reader :color, :token

  NOT_A_FILE = 0b0111111101111111011111110111111101111111011111110111111101111111
  NOT_H_FILE = 0b1111111011111110111111101111111011111110111111101111111011111110
  COMPARISON = 0b1111111111111111111111111111111111111111111111111111111111111111
 
  def initialize(color)
    @color = color
    @attackboard = attack_mask
  end

  # Works only for sliding pieces. Knights, pawns, and kings need unique functions
  def moves(same_occupancy, diff_occupancy, opp_pieces, king, squares = nil)
    moves = []
    indicies = squares ? get_indicies(squares) : get_indicies
    indicies.each do |index|
      moveboard = move_mask(1 << index, index)
      pin_check = pinned(same_occupancy | diff_occupancy, opp_pieces, king, index)
      if !pin_check
        same_blockerboard = moveboard & same_occupancy
        diff_blockerboard = moveboard & diff_occupancy
        blockerboard = same_blockerboard | diff_blockerboard
        moveboard = unblocked_moves(1 << index, index, blockerboard, same_blockerboard) if
          blockerboard > 0
        moveboard = moveboard & king.checkboard if king.in_check
      elsif moveboard > 0
        moveboard |= get_ray(king.bitboard, index) ^ king.bitboard
        moveboard = king.in_check ? 0 : pin_check | moveboard
      end
      moves.push({
        moveboard: moveboard,
        code_type: self.class.to_s.downcase.to_sym,
        origin_square: index,
        occupancy: diff_occupancy,
        opp_pieces: opp_pieces,
        castle: nil,
        promotion: nil,
        en_passant: false        
      }) if moveboard > 0
    end
    return moves
  end

  # Determines if piece is pinned
  def pinned(occupancy, attackers, king, index)
    attackers.each_value do |piece|
      if piece.is_a?(Rook) || piece.is_a?(Bishop) || piece.is_a?(Queen)
        if piece.attackboard & king.bitboard > 0
          rayboard = piece.get_ray(piece.get_indicies, king.get_indicies[0])
          pieceboard = 1 << index
          if rayboard & pieceboard > 0
            rayboard = piece.get_ray(piece.get_indicies, index)
            if count_bits(rayboard & occupancy) == 1
              return rayboard
            end
          end
        end
      end
    end
    return nil
  end
end
