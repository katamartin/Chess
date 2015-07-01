require_relative 'stepping_piece'

class King < SteppingPiece
  def initialize(board, pos, color)
    super
    @symbol = "♚"
  end

  def delta_set
    deltas = DIAG_DELTAS + CART_DELTAS
  end

  def is_king?
    true
  end
end
