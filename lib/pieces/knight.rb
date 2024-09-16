class Knight < Piece
  NOT_AB_FILE = 0b11111100111111001111110011111100111111001111110011111100111111
  NOT_GH_FILE = 0b1111110011111100111111001111110011111100111111001111110011111100
  
  def initialize(color)
    if color == "white"
      @bitboard = 0b01000010
      @token = "\u2658"
    else
      @bitboard = 0b0100001000000000000000000000000000000000000000000000000000000000
      @token = "\u265E"
    end
    super
  end

  def attack_mask
    attacks = 0
    attacks = attacks | ((@bitboard << 15) & NOT_A_FILE)
    attacks = attacks | ((@bitboard << 17) & NOT_H_FILE)
    attacks = attacks | ((@bitboard << 10) & NOT_GH_FILE)
    attacks = attacks | ((@bitboard << 6) & NOT_AB_FILE)
    attacks = attacks | ((@bitboard >> 15) & NOT_H_FILE)
    attacks = attacks | ((@bitboard >> 17) & NOT_A_FILE)
    attacks = attacks | ((@bitboard >> 10) & NOT_AB_FILE)
    attacks = attacks | ((@bitboard >> 6) & NOT_GH_FILE)
  end
end
