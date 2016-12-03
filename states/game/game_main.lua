local Main = Game:addState('Main')

function Main:enteredState()
  local Camera = require("lib/camera")
  self.camera = Camera:new()

  g.setBackgroundColor(150, 150, 150)

  blurShader = g.newShader('shaders/blur.glsl')

  loop_index = 1
  loops = {
    {
      update = require('loop001'),
      bg = self.preloaded_images['bg1.png']
    },
    {
      update = require('loop002'),
      bg = self.preloaded_images['bg2.png']
    },
    {
      update = require('loop003'),
      bg = self.preloaded_images['bg3.png']
    },
  }

  g.setFont(self.preloaded_fonts["04b03_16"])
  self.camera:move(-g.getWidth() / 2, -g.getHeight() / 2)
end

local t = 0
function Main:update(dt)
  t = t + dt
end

local CYCLE_LENGTH = 10

function Main:draw()
  self.camera:set()

  local width, height = g.getDimensions()

  local cycle = t % CYCLE_LENGTH
  local cycle_ratio = cycle / CYCLE_LENGTH

  local bpm = 96 / (60 / CYCLE_LENGTH)
  local beat = math.pow(math.sin(cycle_ratio * math.pi * bpm), 16)

  local loop = loops[loop_index]

  g.setShader(blurShader)
  blurShader:send('direction', {1 + beat, 0})
  g.setColor(255, 255, 255)
  g.draw(loop.bg, -width / 2, -height / 2)
  g.setShader()

  loop.update(cycle_ratio, beat)

  self.camera:unset()
end

function Main:mousepressed(x, y, button, isTouch)
end

function Main:mousereleased(x, y, button, isTouch)
end

function Main:keypressed(key, scancode, isrepeat)
  loop_index = (loop_index % #loops) + 1
end

function Main:keyreleased(key, scancode)
end

function Main:gamepadpressed(joystick, button)
end

function Main:gamepadreleased(joystick, button)
end

function Main:focus(has_focus)
end

function Main:exitedState()
  self.camera = nil
end

return Main
