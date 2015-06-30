require_relative 'sliding_piece'

class Bishop < SlidingPiece

  def initialize(board, pos, color)
    super
    @symbol = "♝"
  end

  def move_dirs
    DIAG_DELTAS
  end
end
