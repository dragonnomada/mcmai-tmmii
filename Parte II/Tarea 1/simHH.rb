# Universidad Autónoma Metropolitana
# Unidad Iztapalapa
# Maestría en Matemáticas Aplicadas e Industriales
# Profesor: Joaquín Delgado Fernández

# Alan Badillo Salas (alan@nomadacode.com)
# Julio, 2025

# Simulador de la Dinámica del Modelo de Hodkin-Huxley

require 'ruby2d'
require_relative 'curve_box'

$w = 800
$h = 400

set width: $w
set height: $h
set title: 'Simulación 10 - Dinámica diferencial'

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

# dv/dt = -a v + b * impulso(t)
# v(t + λt) = v(t) + λt * (-a v(t) + b * impulso(t))


$v = 0.0   # Estado inicial
$a = 1.0   # Decaimiento
$b = 2.0   # Peso del impulso
$dt = 0.05 # Paso temporal

def dinamica(t)
  $v += $dt * (-$a * $v + $b * impulso(t))
  $v
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
  f: method(:dinamica)
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