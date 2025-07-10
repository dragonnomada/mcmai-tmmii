require 'ruby2d'

class PointBox
  attr_accessor :ox, :oy, :sx, :sy, :tmin, :tmax, :ymin, :ymax, :w, :p

  def initialize(ox:, oy:, sx:, sy:, tmin:, tmax:, ymin:, ymax:, p:)
    @ox = ox
    @oy = oy
    @sx = sx
    @sy = sy
    @tmin = tmin
    @tmax = tmax
    @ymin = ymin
    @ymax = ymax
    @w = 1.0
    @p = p

    @points = []
    @lines = []
    @rectangles = []
  end

  def draw
    clear

    @rectangles << Rectangle.new(
      x: @ox,
      y: @oy,
      width: @sx,
      height: @sy,
      color: 'white'
    )

    draw_axes

    points = []

    d = (@tmax - @tmin) / 200.0

    @p.each do |(t, s, c)|
      x = @ox + (1.0 * t - @tmin) / (@tmax - @tmin) * @sx
      y = @oy + @sy - (1.0 * s - @ymin) / (@ymax - @ymin) * @sy

      next if x > @ox + @sx
      next if x < @ox
      next if y > @oy + @sy
      next if y < @oy

      points << [x, y, c]
    end

    points.each do |(x1, y1, c)|
      @points << Circle.new(
        x: x1,
        y: y1,
        radius: 5,
        color: [1 - c, 0.5, c, 1]  # Nota: 400 era $h
      )
    end
  end

  def draw_axes
    # @lines << Line.new(
    #   x1: @ox,
    #   y1: @oy + (@sy / 2),
    #   x2: @ox + @sx,
    #   y2: @oy + (@sy / 2),
    #   width: 1,
    #   color: 'gray'
    # )
    # @lines << Line.new(
    #   x1: @ox + (@sx / 2),
    #   y1: @oy,
    #   x2: @ox + (@sx / 2),
    #   y2: @oy + @sy,
    #   width: 1,
    #   color: 'gray'
    # )
    x0 = @ox + (0.0 - @tmin) / (@tmax - @tmin) * @sx
    y0 = @oy + @sy - (0.0 - @ymin) / (@ymax - @ymin) * @sy
    @lines << Line.new(
      x1: @ox,
      y1: y0,
      x2: @ox + @sx,
      y2: y0,
      width: 1,
      color: 'yellow'
    )
    @lines << Line.new(
      x1: x0,
      y1: @oy,
      x2: x0,
      y2: @oy + @sy,
      width: 1,
      color: 'yellow'
    )
  end

  def clear
    @points.each(&:remove)
    @points.clear

    @lines.each(&:remove)
    @lines.clear

    @rectangles.each(&:remove)
    @rectangles.clear
  end
end