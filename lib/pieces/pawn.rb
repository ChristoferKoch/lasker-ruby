class Pawn < Piece
  NOT_A_FILE = 0b111111101111111011111110111111101111111011111110111111101111111
  NOT_H_FILE = 0b1111111011111110111111101111111011111110111111101111111011111110
  
  def initialize(color)
    if color == "white"
      @bitboard = 0b1111111100000000
      @token = "\u2659"
    else
      @bitboard = 0b11111111000000000000000000000000000000000000000000000000
      @token = "\u265F"
    end
    super
  end

  # Generate attack tables
  def attack_mask
    attacks = 0
    if @color == "white"
      attacks = attacks | ((@bitboard << 7) & NOT_A_FILE)
      attacks = attacks | ((@bitboard << 9) & NOT_H_FILE)
    else
      attacks = attacks | ((@bitboard >> 7) & NOT_H_FILE)
      attacks = attacks | ((@bitboard >> 9) & NOT_A_FILE)
    end
  end
end
