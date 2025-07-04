require 'ruby2d'

set width: 600
set height: 400
set title: 'Simulación 1 - Cuadrado color aleatorio'

square = Square.new(x: 100, y: 100, size: 50, color: 'blue')

update do
  square.x += 1
  square.y += 1
  square.color = [rand, rand, rand, 1.0]
end

show
