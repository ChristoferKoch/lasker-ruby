class King < Piece
  def initialize(color)
    @color = color
    if color == "white"
      @bitboard = 0b00001000
    else
      @bitboard = 0b0000100000000000000000000000000000000000000000000000000000000000
    end
  end
end
