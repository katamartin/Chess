require_relative 'piece'

class Pawn < Piece
  attr_reader :origin, :heading
  attr_accessor :origin
  def initialize(board, pos, color)
    super
    @origin = pos
    @heading = color == :white ? -1 : 1
    @symbol = "♟"
  end

  def moves
    move_set = []
    delta_set.each do |delta|
      move = [pos[0] + delta[0], pos[1] + delta[1]]
       valid_move?(move) ? move_set << move : break
    end
    attack_set.each do |attack|
      move = [pos[0] + attack[0], pos[1] + attack[1]]
      move_set << move if valid_attack?(move)
    end

    move_set
  end

  def valid_move?(move)
    return false unless board.on_board?(move)
    return false unless board[move].empty?

    true
  end

  def valid_attack?(move)
    return false unless board.on_board?(move)
    return false unless !board[move].empty?
    return false if board.same_color?(color, move)
    # return false if board.deep_dup.move!(pos, move).in_check?(color)

    true
  end

  def delta_set
    deltas = [[heading, 0]]
    deltas << [heading * 2, 0] if origin == pos
    deltas
  end

  def attack_set
    [[heading, -1], [heading, 1]]
  end

  def dup(board)
    new_pawn = super
    new_pawn.origin = origin

    new_pawn
  end

end
