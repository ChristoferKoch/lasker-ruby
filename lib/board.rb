class Board
  include DisplayBitboard

  attr_reader :pieces, :white_occupancy, :black_occpancy, :moves

  def initialize
    @pieces = set_board
    occupancy
    @moves = Moves.new(@pieces, @white_occupancy, @black_occupancy)
  end

  def set_board
    white_pieces = {}
    black_pieces = {}
    white_pieces[:pawn] = Pawn.new('white')
    black_pieces[:pawn] = Pawn.new('black')
    white_pieces[:knight] = Knight.new('white')
    black_pieces[:knight] = Knight.new('black')
    white_pieces[:bishop] = Bishop.new('white')
    black_pieces[:bishop] = Bishop.new('black')
    white_pieces[:rook] = Rook.new('white')
    black_pieces[:rook] = Rook.new('black')
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

  def make_move(move, to_move)
    move_data = @moves.get_all(move)
    pieces_index = to_move == 'white' ? 0 : 1
    opp_index = to_move == 'white' ? 1 : 0
    piece = @pieces[pieces_index][move_data[:piece]]
    capture = move_data[:capture] ? @pieces[opp_index][move_data[:capture]] : nil
    promotion = move_data[:promotion] ? @pieces[pieces_index][move_data[:promotion]] : nil
    piece.bitboard ^= 1 << move_data[:origin]
    piece.bitboard |= 1 << move_data[:target] unless promotion
    if capture && !move_data[:en_passant]
      capture.bitboard ^= 1 << move_data[:target]
    elsif move_data[:en_passant]
      shift = to_move == 'white' ? move_data[:target] - 8 : move_data + 8 
      capture.bitboard ^= 1 << shift
    end
    promotion.bitboard |= 1 << move_data[:target] if promotion
    @moves.game_moves.push(move)
  end

  def update(to_move)
    occupancy
    @moves.generate_moves(to_move, @pieces, @white_occupancy, @black_occupancy)
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
