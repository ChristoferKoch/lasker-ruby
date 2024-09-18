class Board
  include DisplayBitboard

  attr_reader :pieces, :white_occupancy, :black_occpancy

  #:white_pawns, :black_pawns, :white_knights, :black_knights, :white_bishops, :black_bishops, :white_rooks, :black_rooks, :white_queen, :black_queen, :white_king, :black_king

  def initialize
    @pieces = set_board
    occupancy
  end

  def set_board
    white_pieces = []
    black_pieces = []
    white_pieces << white_pawns = Pawn.new('white')
    black_pieces << black_pawns = Pawn.new('black')
    white_pieces << white_knights = Knight.new('white')
    black_pieces << black_knights = Knight.new('black')
    white_pieces << white_bishops = Bishop.new('white')
    black_pieces << black_bishops = Bishop.new('black')
    white_pieces << white_rooks = Rook.new('white')
    black_pieces << black_rooks = Rook.new('black')
    white_pieces << white_queen = Queen.new('white')
    black_pieces << black_queen = Queen.new('black')
    white_pieces << white_king = King.new('white')
    black_pieces << black_king = King.new('black')
    [white_pieces, black_pieces]
  end
  
  def occupancy
    @white_occupancy = 0
    @pieces[0].each { |piece| @white_occupancy |= piece.bitboard }
    @black_occupancy = 0
    @pieces[1].each { |piece| @black_occupancy |= piece.bitboard }
  end

  def display_gameboard
    @gameboard = Array.new(64, ' ')
    @pieces[0].each do |pieces|
      indicies = pieces.get_indicies
      indicies.each { |piece| @gameboard[piece] = pieces.token }
    end    
    @pieces[1].each do |pieces|
      indicies = pieces.get_indicies
      indicies.each { |piece| @gameboard[piece] = pieces.token }
    end
    print_gameboard
  end

  def print_gameboard
    index = 56
    rank = 8

    puts "   +---+---+---+---+---+---+---+---+"
    
    while rank > 0
      line = line_spacing(@gameboard[index, 8].reverse.join, false)
      puts "#{rank}  | #{line} |"
      puts "   +---+---+---+---+---+---+---+---+"
      index -= 8
      rank -= 1
    end

    puts "\n     a   b   c   d   e   f   g   h"
  end
end
