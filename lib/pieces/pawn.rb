class Pawn < Piece
  def initialize(color)
    @color = color
    if color == "white"
      @bitboard = 0b1111111100000000
    else
      @bitboard = 0b11111111000000000000000000000000000000000000000000000000
    end
  end
end
