class Piece
  DIAG_DELTAS = [ [1, 1], [-1, 1], [1, -1], [-1, -1] ]
  CART_DELTAS = [ [0, 1], [0, -1], [1, 0], [-1, 0] ]
  attr_reader :board, :pos, :color, :symbol
  def initialize(board, pos, color)
    @board = board
    @pos = pos
    @color = color
    @symbol = "X"
  end

  def is_king?
    false
  end

  def empty?
    false
  end

  def to_s
    symbol.colorize(color)
  end

  def fail_method
    raise NotImplementedError
  end

  def moves
    fail_method
  end

  def move_dirs
    fail_method
  end

  def pos=(value)
    @pos = value
  end

  def valid_move?(next_pos)
    #board.valid_move?(self.color, pos, next_pos)
    return false unless board.on_board?(next_pos)
    return true if board[next_pos].empty?

    !board.same_color?(color, next_pos)
  end

  def dup(duped_board)
    self.class.new(duped_board, pos, color)
  end

end
