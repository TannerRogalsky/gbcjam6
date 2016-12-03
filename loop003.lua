local vector = require('lib.HardonCollider.vector-light')

local SIZE = 17
local sin, cos, pow = math.sin, math.cos, math.pow
local tau = math.pi * 2
local pi = math.pi

local arms = 7
local trisPerArm = 10
local num = arms * trisPerArm

local mesh = g.newMesh({
  {0, -SIZE / 2},
  {SIZE / 2, SIZE / 2},
  {-SIZE / 2, SIZE / 2}
})

local function inQuad(t, b, c, d) return c * math.pow(t / d, 2) + b end
local function inQuint(t, b, c, d) return c * math.pow(t / d, 5) + b end

return function(cycle_ratio, beat)
  beat = math.pow(beat, 2)

  local width, height = g.getDimensions()

  g.push('all')
  g.rotate(-cycle_ratio * pi * 2)

  g.scale(1 + beat / 4)
  local size = width / 4

  for i=0,num-1 do
    local armIndex = i % arms
    local indexInArm = math.floor(i / arms) / trisPerArm
    local i_cycle_ratio = (indexInArm + cycle_ratio) % 1
    -- local i_cycle_ratio = (i / num + cycle_ratio) % 1

    local x = cos(i_cycle_ratio * pi * 2) * size * sin(cycle_ratio * pi * 2)
    local y = sin(i_cycle_ratio * pi * 2) * size
    local d = math.sqrt(x * x + y * y);

    local angle = pi * 2 / arms * armIndex
    x, y = vector.rotate(angle, x, y)

    g.setColor(hsl2rgb((cycle_ratio + d / size * 0.65) % 1, 1, 0.5))
    -- g.draw(mesh, x, y, angle)
    g.draw(mesh, x, y, math.atan2(y, x) - pi / 2)
  end

  g.pop()
end
