class Knight < Piece
  def initialize(color)
    @color = color
    if color == "white"
      @bitboard = 0b01000010
    else
      @bitboard = 0b0100001000000000000000000000000000000000000000000000000000000000
    end
  end
end
