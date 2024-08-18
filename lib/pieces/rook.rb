class Rook < Piece
  def initialize(color)
    @color = color
    if color == "white"
      @bitboard = 0b10000001
    else
      @bitboard = 0b1000000100000000000000000000000000000000000000000000000000000000
    end
  end
end
