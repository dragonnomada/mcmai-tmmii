require 'ruby2d'

w = 800
h = 400

set width: w
set height: h
set title: 'Simulación 3 - Curva (fija)'

points = []

(0..800).step(1) do |x|
  y = h / 2 - 200 * Math.sin(0.01 * x)

  points << [x, y]
end

points.each_cons(2) do |(x1, y1), (x2, y2)|
  Line.new(
    x1: x1,
    y1: y1,
    x2: x2,
    y2: y2,
    width: 2,
    color: [0.5, 1 - y1 / h, 0.5, 1]
  )
end

show
