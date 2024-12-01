class Moves
  include BitManipulations, Encode
  attr_reader :move_list, :game_moves

  def initialize(pieces, white_occupancy, black_occupancy)
    generate_moves('white', pieces, white_occupancy, black_occupancy)
    @game_moves = []
  end

  def generate_moves(color, pieces, white_occupancy, black_occupancy)
    opp_pieces = color == 'white' ? pieces[1] : pieces[0]
    pieces = color == 'white' ? pieces[0] : pieces[1]
    same_occupancy = color == 'white' ? white_occupancy : black_occupancy
    diff_occupancy = color == 'white' ? black_occupancy : white_occupancy
    moves = []
    if !pieces[:king].in_double_check
      pieces.each do |type, piece|
        if type != :king
          data = pieces[type].moves(same_occupancy, diff_occupancy, opp_pieces, pieces[:king])
          moves += encode_moves(data)
        end
      end
    end
    data = pieces[:king].moves(same_occupancy, diff_occupancy, opp_pieces)
    moves += encode_moves(data)
    moves.flatten!
    @move_list = moves
  end
end
