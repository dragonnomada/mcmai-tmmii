require 'ruby2d'
require_relative 'curve_box'

$w = 800
$h = 400

set width: $w
set height: $h
set title: 'Simulación 7 - Función impulso de t0 a t1'

$t0 = -3
$t1 = 1

def impulso(t)
  (t >= $t0 && t <= $t1) ? 1.0 : 0.0
end

curve = CurveBox.new(
  ox: 200,
  oy: 100,
  sx: 400,
  sy: 200,
  tmin: -3,
  tmax: 3,
  ymin: -1.5,
  ymax: 1.5,
  f: method(:impulso)
)

curve.draw

update do
  $t0 += 0.01
  $t1 = $t0 + 1
  curve.draw
end

show