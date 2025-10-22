EnemyDeathEffect = GameObject:extend()

function EnemyDeathEffect:new(area, x, y, opts)
    EnemyDeathEffect.super.new(self, area, x, y, opts)
    self.graphics_types = {'rgb_shift'}
    self.depth = 80

    self.first = true
    self.timer:after(0.1, function()
        self.first = false
        self.second = true
        self.timer:after(0.15, function()
            self.second = false
            self.dead = true
        end)
    end)
end

function EnemyDeathEffect:update(dt)
    EnemyDeathEffect.super.update(self, dt)
end

function EnemyDeathEffect:draw()
    if self.first then love.graphics.setColor(default_color)
    elseif self.second then love.graphics.setColor(rock_color) end
    love.graphics.rectangle('fill', self.x - self.w/2, self.y - self.w/2, self.w, self.w)
end

function EnemyDeathEffect:destroy()
    EnemyDeathEffect.super.destroy(self)
end
