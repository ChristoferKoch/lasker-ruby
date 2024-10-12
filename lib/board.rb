class Board
  include DisplayBitboard

  attr_reader :pieces, :white_occupancy, :black_occpancy, :move_list

  def initialize
    @pieces = set_board
    occupancy    
    @move_list = generate_moves('black')
  end

  def set_board
    white_pieces = {}
    black_pieces = {}
    white_pieces[:pawns] = Pawn.new('white')
    black_pieces[:pawns] = Pawn.new('black')
    white_pieces[:knights] = Knight.new('white')
    black_pieces[:knights] = Knight.new('black')
    white_pieces[:bishops] = Bishop.new('white')
    black_pieces[:bishops] = Bishop.new('black')
    white_pieces[:rooks] = Rook.new('white')
    black_pieces[:rooks] = Rook.new('black')
    white_pieces[:queen] = Queen.new('white')
    black_pieces[:queen] = Queen.new('black')
    white_pieces[:king] = King.new('white')
    black_pieces[:king] = King.new('black')
    [white_pieces, black_pieces]
  end
  
  def occupancy
    @white_occupancy = 0
    @pieces[0].each_value { |piece| @white_occupancy |= piece.bitboard }
    @black_occupancy = 0
    @pieces[1].each_value { |piece| @black_occupancy |= piece.bitboard }
  end

  def generate_moves(color)
    pieces = color == 'white' ? @pieces[0] : @pieces[1]
    opp_pieces = color == 'white' ? @pieces[1] : @pieces[0]
    same_occupancy = color == 'white' ? @white_occupancy : @black_occupancy
    diff_occupancy = color == 'white' ? @black_occupancy : @white_occupancy
    legal_moves = []
    if !pieces[:king].in_double_check
      pieces.each do |type, piece|
        if type != :king && type != :pawns
          legal_moves += pieces[type].moves(same_occupancy, diff_occupancy, opp_pieces, pieces[:king])
        end
      end
    end
  end

  def display_gameboard
    @gameboard = Array.new(64, ' ')
    @pieces[0].each_value do |pieces|
      indicies = pieces.get_indicies
      indicies.each { |piece| @gameboard[piece] = pieces.token }
    end    
    @pieces[1].each_value do |pieces|
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
