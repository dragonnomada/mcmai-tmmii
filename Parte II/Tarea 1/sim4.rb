require 'ruby2d'

$w = 800
$h = 400

set width: $w
set height: $h
set title: 'Simulación 4 - Curva envuelta'

def f(t)
  y = Math.sin(t)
end

$lines = []
$rectangles = []

def curve(ox, oy, sx, sy, tmin, tmax, ymin, ymax)
  $lines.each(&:remove)
  $lines.clear

  $rectangles.each(&:remove)
  $rectangles.clear

  $rectangles << Rectangle.new(
    x: ox,
    y: oy,
    width: sx,
    height: sy,
    color: 'white'
  )

  points = []
  (-180..180).step(5) do |deg|
    t = deg * Math::PI / 180
    x = ox + (t - tmin) / (tmax - tmin) * sx
    y = oy + (f(t) - ymin) / (ymax - ymin) * sy
    # x = x.clamp(ox, ox + sx)
    # y = y.clamp(oy, oy + sx)
    next if x > ox + sx
    next if x < ox
    next if y > oy + sy
    next if y < oy
    points << [x, y]
  end

  points.each_cons(2) do |(x1, y1), (x2, y2)|
    $lines << Line.new(
      x1: x1,
      y1: y1,
      x2: x2,
      y2: y2,
      width: 2,
      color: [0.5, 1 - y1 / $h, 0.5, 1]
    )
  end
end

curve(200, 100, 400, 200, -3, 3, -1, 1)

show
