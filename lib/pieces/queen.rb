class Queen < Piece
  def initialize(color)
    @color = color
    if color == "white"
      @bitboard = 0b00010000
    else
      @bitboard = 0b0001000000000000000000000000000000000000000000000000000000000000
    end
  end
end
