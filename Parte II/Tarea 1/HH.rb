require 'ruby2d'
require_relative 'curve_box'

$w = 800
$h = 400

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

curve1.draw

show