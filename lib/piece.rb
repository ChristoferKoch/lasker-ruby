class Piece
  include DisplayBitboard

  attr_accessor :bitboard
  attr_reader :color, :attackboard, :token

  NOT_A_FILE = 0b0111111101111111011111110111111101111111011111110111111101111111
  NOT_H_FILE = 0b1111111011111110111111101111111011111110111111101111111011111110
  COMPARISON = 0b1111111111111111111111111111111111111111111111111111111111111111
  NUMERIC_CODE = {
    pawn: 1,
    knight: 2,
    bishop: 3,
    rook: 4,
    queen: 5,
    king: 6
  }
 
  def initialize(color)
    @color = color
    @attackboard = attack_mask
  end

  # Works only for sliding pieces. Knights, pawns, and kings need unique functions
  def moves(same_occupancy, diff_occupancy, opp_pieces, king)
    moves = []
    indicies = get_indicies
    indicies.each do |index|
      moveboard = move_mask(1 << index, index)
      pin_check = pinned(same_occupancy | diff_occupancy, opp_pieces, king, index)
      if !pin_check
        same_blockerboard = moveboard & same_occupancy
        diff_blockerboard = moveboard & diff_occupancy
        blockerboard = same_blockerboard | diff_blockerboard
        moveboard = blockerboard > 0 ? unblocked_moves(1 << index, index, blockerboard, same_blockerboard) : moveboard
        moveboard = king.in_check ? moveboard & king.checkboard : moveboard
      elsif moveboard > 0
        moveboard |= get_ray(king.bitboard, index) ^ king.bitboard
        moveboard = king.in_check ? 0 : pin_check | moveboard
      end
      moves += encode_moves(moveboard, index, diff_occupancy, opp_pieces)
    end
    return moves
  end

  # Determines if piece is pinned
  def pinned(occupancy, attackers, king, index)
    attackers.each_value do |piece|
      if piece.is_a?(Rook) || piece.is_a?(Bishop) || piece.is_a?(Queen)
        if piece.attackboard & king.bitboard > 0
          rayboard = get_ray(piece.get_indicies, king.get_indicies[0])
          pieceboard = 1 << index
          if rayboard & pieceboard > 0
            rayboard = get_ray(piece.bitboard, index)
            if rayboard & occupancy == 0
              return rayboard
            end
          end
        end
      end
    end
    return nil
  end

  # Generates moves as a bit representation
  # Standard representation:
  # 0000 0000 0000 0000 0011 1111 Origin square
  # 0000 0000 0000 1111 1100 0000 Target square
  # 0000 0000 0111 0000 0000 0000 Piece type
  # 0000 0011 1000 0000 0000 0000 Capture piece type
  # 0001 1100 0000 0000 0000 0000 Promotion piece
  # 0010 0000 0000 0000 0000 0000 En passant
  # 0100 0000 0000 0000 0000 0000 Castle
  # 1000 0000 0000 0000 0000 0000 Check
  def encode_moves(moveboard, origin_square, occupancy, opp_pieces, castle = false, promotion = nil, en_passant = false)
    moves = []
    type = NUMERIC_CODE[self.class.to_s.downcase.to_sym]
    if castle
      
    end
    indicies = get_indicies(moveboard)
    indicies.each do |target|
      move = origin_square
      move |= target << 6
      move |= type << 12
      move |= get_type(opp_pieces, 1 << target) << 15 if (1 << target) & occupancy > 0
      move |= promotion << 18 if promotion
      move |= 1 << 21 if en_passant
      p move.to_s(2)
    end
  end

  def get_type(pieces, targetboard)
    pieces.each do |type, piece|
      if targetboard & piece.bitboard > 0
        return NUMERIC_CODE[type.to_sym]
      end
    end
    return nil
  end
end
