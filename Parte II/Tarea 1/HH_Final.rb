# Universidad Autónoma Metropolitana
# Unidad Iztapalapa
# Maestría en Matemáticas Aplicadas e Industriales
# Profesor: Joaquín Delgado Fernández

# Alan Badillo Salas (alan@nomadacode.com)
# Julio, 2025

# Simulador de la Dinámica del Modelo de Hodkin-Huxley

require 'ruby2d'
require_relative 'curve_box'
require_relative 'point_box'

$w = 1200
$h = 600

set width: $w
set height: $h
set title: 'HH - Dinámica de Hodkin-Huxley'

Cm = 1; 
ENa = 115; gNa = 120;
EK = -12; gK = 36;
EL = 10.6; gL = 0.3;

an = ->(u) { (0.1 - 0.01 * u) / (Math.exp(1 - 0.1 * u) - 1) }
am = ->(u) { (2.5 - 0.1 * u) / (Math.exp(2.5 - 0.1 * u) - 1) }
ah = ->(u) { 0.07 * Math.exp(-u / 20) }

bn = ->(u) { 0.125 * Math.exp(-u / 80) }
bm = ->(u) { 4 * Math.exp(-u / 18) }
bh = ->(u) { 1 / (Math.exp(3 - 0.1 * u) + 1) }

$dI2 = 0.5   # 0..6 (0.1)
$a = 0     # 0..15 (1)
$I2 = 0.5  # 0..8 (0.1)

Unit = ->(t) { (t >= 0) ? 1.0 : 0.0 }

J = ->(t) { $I2 + $dI2 * Unit.call(t - $a) }

Du = ->(t, u, m, n, h) { (-gNa * m ** 3 * h * (u - ENa) - gK * n ** 4 * (u - EK) - gL * (u - EL) + J.call(t)) / Cm }
Dn = ->(t, u, m, n, h) { an.call(u) * (1 - n) - bn.call(u) * n }
Dm = ->(t, u, m, n, h) { am.call(u) * (1 - m) - bm.call(u) * m }
Dh = ->(t, u, m, n, h) { ah.call(u) * (1 - h) - bh.call(u) * h }

$tmin = -10
$tmax = 100

$ymin = -30
$ymax = 80

def solver(t)

    t0 = $tmin
    dt = 0.01

    st = t0

    u = 0.0
    m = 0.0
    n = 0.0
    h = 0.0

    while st < t
        du_val = Du.call(st, u, m, n, h)
        dn_val = Dn.call(st, u, m, n, h)
        dm_val = Dm.call(st, u, m, n, h)
        dh_val = Dh.call(st, u, m, n, h)

        u += dt * du_val
        n += dt * dn_val
        m += dt * dm_val
        h += dt * dh_val

        st += dt
    end

    #print("#{st} #{u} ")

    u

end

curve1 = CurveBox.new(
  ox: 10,
  oy: 10,
  sx: 780,
  sy: 380,
  tmin: $tmin,
  tmax: $tmax,
  ymin: $ymin,
  ymax: $ymax,
  f: method(:solver)
)

curve2 = CurveBox.new(
  ox: 10,
  oy: 410,
  sx: 780,
  sy: 180,
  tmin: $tmin,
  tmax: $tmax,
  ymin: -0.5,
  ymax: 1.5,
  f: J
)

$points = []

# $points << [4, 4]

curve3 = PointBox.new(
  ox: 810,
  oy: 10,
  sx: 380,
  sy: 580,
  tmin: 0,
  tmax: 8,
  ymin: 0,
  ymax: 6,
  p: $points
)

curve1.draw
curve2.draw
curve3.draw

on :mouse_down do |event|
  if event.x >= 810 && event.x <= 1180 && event.y >= 10 && event.y <= 580
    # print("(#{event.x}, #{event.y}) ")
    xr = (event.x - 810.0) / (1180.0 - 810.0)
    yr = 1 - (event.y - 10.0) / (580.0 - 10.0)

    x = xr * 8
    y = yr * 6

    (1..10).step(1) do |i|

      $I2 = x + rand * 2 - 1
      $dI2 = y + rand * 2 - 1

      c = 0

      delta = ($tmax - $tmin) / 100.0

      ($tmin...$tmax).step(delta) do |t|
        c += solver(t)
      end

      $points << [$I2, $dI2, (c - 100.0) / 1000.0]

    end

    $I2 = x
    $dI2 = y

    c = 0

    delta = ($tmax - $tmin) / 100.0

    ($tmin...$tmax).step(delta) do |t|
      c += solver(t)
    end

    $points << [$I2, $dI2, (c - 100.0) / 1000.0]

    curve1.draw

    curve3.p = $points

    curve3.draw
  end 
end

show