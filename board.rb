require_relative 'pieces'
require_relative 'empty_square'
require 'colorize'
require 'io/console'

class Board
  attr_reader :grid, :teams
  attr_accessor :cursor, :end_cursor
  def initialize
    @grid = Array.new(8) { Array.new(8) { EmptySquare.new } }
    @cursor = [0, 0]
    @end_cursor = nil
    @teams = {:white => [], :black => []}
    populate
  end

  def populate_big_row(color, row)
    big_row = []
    big_row << Rook.new(self, [row, 0], color)
    big_row << Knight.new(self, [row, 1], color)
    big_row << Bishop.new(self, [row, 2], color)
    big_row << King.new(self, [row, 3], color)
    big_row << Queen.new(self, [row, 4], color)
    big_row << Bishop.new(self, [row, 5], color)
    big_row << Knight.new(self, [row, 6], color)
    big_row << Rook.new(self, [row, 7], color)
    teams[color] += big_row
    grid[row] = big_row
  end

  def populate_pawn_row(color, row)
    pawns = grid[row].map!.with_index { |_, i| Pawn.new(self, [row, i], color) }
    teams[color] += pawns
  end

  def populate
    populate_big_row(:black, 0)
    populate_pawn_row(:black, 1)
    populate_big_row(:white, 7)
    populate_pawn_row(:white, 6)
  end

  def [](pos)
    x, y = pos
    grid[x][y]
  end

  def []=(pos, value)
    x, y = pos
    grid[x][y] = value
  end

  def valid_move?(color, pos)
    return false unless on_board?(pos)
    return true if self[pos].empty?

    !same_color?(color, pos)
  end

  def on_board?(pos)
    pos.all? { |coord| coord.between?(0, 7) }
  end

  def same_color?(color, pos)
    self[pos].color == color
  end

  def move_cursor(pos)
    this_cursor = !!end_cursor ? end_cursor : cursor
    new_position = [this_cursor[0] + pos[0], this_cursor[1] + pos[1]]
    if on_board?(new_position)
      this_cursor[0], this_cursor[1] = new_position[0], new_position[1]
    end
    system("clear")
    render
  end

  def render
    puts "   #{("a".."h").to_a.join("  ")}"
    grid.each_with_index do |row, i|
      print "#{i} "
      row.each_with_index do |el, j|
        color = (i + j).even? ? :cyan : :light_red
        color = :yellow if [i, j] == cursor
        unless self[cursor].empty?
          color = :light_green if self[cursor].moves.include?([i, j])
        end
        color = :yellow if [i, j] == end_cursor
        print " #{el.to_s} ".colorize(:background => color)
      end
      puts ""
    end
    nil
  end

  def in_check?(color)
    king = teams[color].find { |piece| piece.is_king? }
    opponent_pieces = teams[opposite_color(color)]

    opponent_pieces.any? { |piece| piece.moves.include?(king.pos) }
  end

  def opposite_color(color)
    return :black if color == :white
    return :white if color == :black
    nil
  end

  def make_move
    begin
      start_pos = respond_to_input
      self.end_cursor = start_pos.dup
      end_pos = respond_to_input
      move(start_pos, end_pos)
      self.end_cursor = nil
    rescue
      puts "Invalid move!"
      retry
    end
    system("clear")
    render
  end

  def move(start, end_pos)
    raise "empty_space" if self[start].empty?
    piece = self[start]
    raise "not a valid move" unless piece.valid_move?(end_pos)
    self[end_pos] = piece
    self[start] = EmptySquare.new
    piece.pos = end_pos
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

  # oringal case statement from:
  # http://www.alecjacobson.com/weblog/?p=75
  def respond_to_input
    loop do
      c = read_char
      case c
      when "\r"
        return end_cursor || cursor
      when "\e[A"
        move_cursor([-1, 0])
      when "\e[B"
        move_cursor([1, 0])
      when "\e[C"
        move_cursor([0, 1])
      when "\e[D"
        move_cursor([0, -1])
      when "\u0003"
        raise Interrupt
      end
    end
  end


end


b = Board.new
b.render
while true
  b.make_move
end
