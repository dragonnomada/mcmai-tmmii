require 'ruby2d'
require_relative 'curve_box'

$w = 800
$h = 400

set width: $w
set height: $h
set title: 'Simulación 6 - Curva Seno (con animación)'

$w = 0

curve = CurveBox.new(
  ox: 200,
  oy: 100,
  sx: 400,
  sy: 200,
  tmin: -3,
  tmax: 3,
  ymin: -1,
  ymax: 1,
  f: -> (t) { Math.sin($w * t) }
)

curve.draw

update do
  $w += 0.01
  curve.draw
end

show