class Bishop < Piece
  def initialize(color)
    @color = color
    if color == "white"
      @bitboard = 0b00100100
    else
      @bitboard = 0b0010010000000000000000000000000000000000000000000000000000000000
    end
  end
end
