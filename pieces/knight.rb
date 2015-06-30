require_relative 'stepping_piece'

class Knight < SteppingPiece
  def initialize(board, pos, color)
    super
    @symbol = "♞"
  end

  def delta_set
    deltas = [[1, 2], [-1, 2],
              [-1, -2], [1, -2],
              [2, 1], [2, -1],
              [-2, 1], [-2, -1]]
  end
end
