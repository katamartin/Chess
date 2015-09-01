require_relative 'pieces'
require_relative 'empty_square'
require_relative 'errors'
require 'colorize'
require 'io/console'

class Board
  attr_reader :teams

  def initialize(pop = true)
    @grid = Array.new(8) { Array.new(8) { EmptySquare.new } }
    @cursor = [0, 0]
    @end_cursor = nil
    @teams = {:white => [], :black => []}
    populate if pop
  end

  def [](pos)
    x, y = pos
    grid[x][y]
  end

  def []=(pos, value)
    x, y = pos
    grid[x][y] = value
  end

  def on_board?(pos)
    pos.all? { |coord| coord.between?(0, 7) }
  end

  def same_color?(color, pos)
    self[pos].color == color
  end

  def render(turn_color)
    system("clear")
    puts "   #{("a".."h").to_a.join("  ")}"
    grid.each_with_index do |row, i|
      print "#{8 - i} "
      row.each_with_index do |el, j|
        color = (i + j).even? ? :red : :light_black
        color = :green if [i, j] == cursor
        unless self[cursor].empty?
          if self[cursor].moves.include?([i, j]) && self[cursor].color == turn_color
            color = :yellow
          end
        end
        color = :green if [i, j] == end_cursor
        print " #{el.to_s} ".colorize(:background => color)
      end
      puts ""
    end
    display_check
    nil
  end

  def in_check?(color)
    king = teams[color].find { |piece| piece.is_king? }
    opponent_pieces = teams[opposite_color(color)]

    opponent_pieces.any? { |piece| piece.moves.include?(king.pos) }
  end

  def checkmate?(color)
    return false unless in_check?(color)
    return false if teams[color].any? do |piece|
      piece.moves.any? { |move| valid_move?(piece.pos, move) }
    end

    true
  end

  def opposite_color(color)
    return :black if color == :white
    return :white if color == :black
    nil
  end

  def position_selection(turn_color)
    start_pos = respond_to_input(turn_color)
    self.end_cursor = start_pos.dup
    end_pos = respond_to_input(turn_color)
    self.end_cursor = nil
    return [start_pos, end_pos]
  end

  def move(start, end_pos)
    raise InvalidSelection if self[start].empty?
    piece = self[start]
    raise InvalidSelection unless piece.moves.include?(end_pos)
    raise CheckError unless valid_move?(start, end_pos)
    move!(start, end_pos)
  end

  def move!(start, end_pos)
    piece = self[start]
    remove_piece(self[end_pos])
    self[end_pos] = piece
    self[start] = EmptySquare.new
    piece.pos = end_pos
    self
  end

  protected
  attr_reader :grid

  private
  attr_accessor :cursor, :end_cursor

  def move_cursor(turn_color, pos)
    this_cursor = !!end_cursor ? end_cursor : cursor
    new_position = [this_cursor[0] + pos[0], this_cursor[1] + pos[1]]
    if on_board?(new_position)
      this_cursor[0], this_cursor[1] = new_position[0], new_position[1]
    end
    render(turn_color)
  end

  def deep_dup
    new_board = Board.new(false)
    self.grid.each_with_index do |row, i|
      row.each_with_index do |el, j|
        unless el.empty?
          new_piece = el.dup(new_board)
          new_board[[i, j]] = new_piece
          new_board.teams[new_piece.color] << new_piece
        end
      end
    end

    new_board
  end

  def valid_move?(start_pos, end_pos)
    duped = deep_dup
    color = self[start_pos].color
    return false if duped.move!(start_pos, end_pos).in_check?(color)

    true
  end

  def populate
    populate_big_row(:black, 0)
    populate_pawn_row(:black, 1)
    populate_big_row(:white, 7)
    populate_pawn_row(:white, 6)
  end

  def populate_big_row(color, row)
    big_row = []
    class_names = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
    class_names.each_with_index do |class_name, col|
      big_row << class_name.new(self, [row,col], color)
    end
    teams[color] += big_row
    grid[row] = big_row
  end

  def populate_pawn_row(color, row)
    pawns = grid[row].map!.with_index { |_, i| Pawn.new(self, [row, i], color) }
    teams[color] += pawns
  end

  def read_char
    STDIN.echo = false
    STDIN.raw!

    input = STDIN.getc.chr
    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
    end

  ensure
    STDIN.echo = true
    STDIN.cooked!

    return input
  end

  def display_check
    puts "White in check!" if in_check?(:white)
    puts "Black in check!" if in_check?(:black)
  end

  def remove_piece(piece)
    teams[piece.color].delete(piece) unless piece.empty?
  end

  # original case statement from:
  # http://www.alecjacobson.com/weblog/?p=75
  def respond_to_input(turn_color)
    loop do
      c = read_char
      case c
      when "\r"
        return end_cursor || cursor
      when "\e[A"
        move_cursor(turn_color, [-1, 0])
      when "\e[B"
        move_cursor(turn_color, [1, 0])
      when "\e[C"
        move_cursor(turn_color, [0, 1])
      when "\e[D"
        move_cursor(turn_color, [0, -1])
      when "\u0003"
        raise Interrupt
      end
    end
  end


end
