require 'ruby2d'
require_relative 'curve_box'

$w = 800
$h = 400

set width: $w
set height: $h
set title: 'Simulación 9 - Dinámica del Perceptrón'

$t0 = -3
$c = 1
$t1 = $t0 + $c

def impulso(t)
  (t >= $t0 && t <= $t1) ? 1.0 : 0.0
end

curve1 = CurveBox.new(
  ox: 10,
  oy: 10,
  sx: 380,
  sy: 380,
  tmin: -3,
  tmax: 3,
  ymin: -1.5,
  ymax: 1.5,
  f: method(:impulso)
)

$b0 = 0
$b1 = 1

def perceptron(t)
  u = impulso(t)
  y = 1 / (1 + Math.exp(-($b0 + $b1 * t))) * u
  y
end

curve2 = CurveBox.new(
  ox: 410,
  oy: 10,
  sx: 380,
  sy: 380,
  tmin: -3,
  tmax: 3,
  ymin: -1.5,
  ymax: 1.5,
  f: method(:perceptron)
)

curve1.draw
curve2.draw

update do
  $t0 += 0.01
  $t1 = $t0 + $c

  if $t0 > 3
    $t0 = -3
  end

  curve1.draw
  curve2.draw
end

show