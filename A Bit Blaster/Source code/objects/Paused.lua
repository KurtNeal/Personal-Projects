Paused = Object:extend()

function Paused:new(stage)
    self.stage = stage
    self.font = fonts.Anonymous_8
    self.resume = true
end

function Paused:update(dt)
    if input:pressed('left') or input:pressed('right') then
        Switch:play()
        self.resume = not self.resume
    end
    if input:pressed('return') or input:pressed('up') then
        Enter:play()
        if self.resume then
            self.stage:pause()
        else
            gotoRoom('Console')
        end
    end
end

function Paused:draw()
    love.graphics.setFont(self.font)

    love.graphics.setColor(0.031, 0.031, 0.031, 0.90)
    love.graphics.rectangle('fill', gw / 2 - 68, gh / 2 - 8, 64, 16)
    love.graphics.setColor(0.75, 0.75, 0.75, 1)
    if self.resume then love.graphics.rectangle('line', gw / 2 - 68, gh / 2 - 8, 64, 16) end
    love.graphics.print('RESUME', gw / 2 - 4 - 32, gh / 2 - 6, 0, 1, 1, math.floor(self.font:getWidth('RESUME') / 2))

    love.graphics.setColor(0.031, 0.031, 0.031, 0.90)
    love.graphics.rectangle('fill', gw/2 + 4, gh/2 - 8, 64, 16) 
    love.graphics.setColor(0.75, 0.75, 0.75, 1)
    if not self.resume then love.graphics.rectangle('line', gw / 2 + 4, gh / 2 - 8, 64, 16) end
    love.graphics.print('CONSOLE', gw / 2 + 4 + 32, gh / 2 - 6, 0, 1, 1, math.floor(self.font:getWidth('CONSOLE') / 2))
end