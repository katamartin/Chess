require_relative 'sliding_piece'

class Queen < SlidingPiece
  def initialize(board, pos, color)
    super
    @symbol = "♛"
  end

  def move_dirs
    DIAG_DELTAS + CART_DELTAS
  end
end
