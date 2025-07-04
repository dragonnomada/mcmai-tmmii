require 'ruby2d'

class CurveBox
  attr_accessor :ox, :oy, :sx, :sy, :tmin, :tmax, :ymin, :ymax, :w

  def initialize(ox:, oy:, sx:, sy:, tmin:, tmax:, ymin:, ymax:, f:)
    @ox = ox
    @oy = oy
    @sx = sx
    @sy = sy
    @tmin = tmin
    @tmax = tmax
    @ymin = ymin
    @ymax = ymax
    @w = 1.0
    @f = f

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

    (-180..180).step(5) do |deg|
      t = deg * Math::PI / 180
      x = @ox + (t - @tmin) / (@tmax - @tmin) * @sx
      y = @oy + @sy - (@f.call(t) - @ymin) / (@ymax - @ymin) * @sy

      next if x > @ox + @sx
      next if x < @ox
      next if y > @oy + @sy
      next if y < @oy

      points << [x, y]
    end

    points.each_cons(2) do |(x1, y1), (x2, y2)|
      @lines << Line.new(
        x1: x1,
        y1: y1,
        x2: x2,
        y2: y2,
        width: 2,
        color: [0.5, 1 - y1 / (@sy / 2), 0.5, 1]  # Nota: 400 era $h
      )
    end
  end

  def draw_axes
    @lines << Line.new(
      x1: @ox,
      y1: @oy + (@sy / 2),
      x2: @ox + @sx,
      y2: @oy + (@sy / 2),
      width: 1,
      color: 'gray'
    )
    @lines << Line.new(
      x1: @ox + (@sx / 2),
      y1: @oy,
      x2: @ox + (@sx / 2),
      y2: @oy + @sy,
      width: 1,
      color: 'gray'
    )
  end

  def clear
    @lines.each(&:remove)
    @lines.clear

    @rectangles.each(&:remove)
    @rectangles.clear
  end
end