local vector = require('lib.HardonCollider.vector-light')

local SIZE = 15
local sin, cos, pow = math.sin, math.cos, math.pow
local tau = math.pi * 2
local pi = math.pi

local arms = 5
local num = arms * 20

local mesh = g.newMesh({
  {0, -SIZE / 2},
  {SIZE / 2, SIZE / 2},
  {-SIZE / 2, SIZE / 2}
})

local function inQuad(t, b, c, d) return c * math.pow(t / d, 2) + b end
local function inQuint(t, b, c, d) return c * math.pow(t / d, 5) + b end

return function(cycle_ratio, beat)
  beat = math.pow(beat, 8)
  local width, height = g.getDimensions()

  g.push('all')
  g.rotate(-cycle_ratio * pi * 2)

  g.scale(1 + beat / 5)

  for i=0,num-1 do
    local armIndex = i % arms
    local i_cycle_ratio = (i / num + cycle_ratio) % 1

    local size = width / 4

    -- local x = sin(i_cycle_ratio * pi * 2) * size
    -- x = x + pow(sin(i_cycle_ratio * pi), 2) * size / 2
    -- local y = sin(i_cycle_ratio * pi * 2) * size * i_cycle_ratio
    -- y = y + pow(sin(i_cycle_ratio * pi), 2) * size / 2
    -- local d = math.sqrt(x * x + y * y)

    -- local angle = pi * 2 / arms * armIndex
    -- x, y = vector.rotate(angle, x, y)

    local x = cos(i_cycle_ratio * pi * 2) * size
    x = x * sin(cycle_ratio * pi * 2)
    x = x + pow(sin(i_cycle_ratio * pi), 2) * size / 2
    local y = sin(i_cycle_ratio * pi * 2) * size
    y = y * cos(cycle_ratio * pi * 2)
    local d = math.sqrt(x * x + y * y)

    -- glm::mat4 m;
    -- m = glm::rotate(m, -(float)pi / 2, twoDAxis);
    -- m = glm::rotate(m, (float)pi * 2 / arms * armIndex, twoDAxis);
    -- m = glm::translate(m, {x, y, 1});

    local angle = pi * 2 / arms * armIndex - pi / 2
    x, y = vector.rotate(angle, x, y)

    g.setColor(hsl2rgb((cycle_ratio + d / size * 0.65) % 1, 1, 0.5))
    g.draw(mesh, x, y, angle)
  end

  g.pop()
end
