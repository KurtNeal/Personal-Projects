HpEffect = GameObject:extend()

function HpEffect:new(area, x, y, opts)
    HpEffect.super.new(self, area, x, y, opts)
    self.depth = 75

    self.current_color = hp_color
    self.timer:after(0.2, function() self.current_color = self.color 
        self.timer:after(0.35, function() self.dead = true end) 
    end)
    
    self.visible = true
    self.timer:after(0.2, function()
        self.timer:every(0.05, function() self.visible = not self.visible end, 6)
        self.timer:after(0.35, function() self.visible = true end)
    end)

    self.sx, self.sy = 1, 1
    self.timer:tween(0.35, self, {sx = 2, sy = 2}, 'in-out-cubic')
end

function HpEffect:update(dt)
    HpEffect.super.update(self, dt)
end

function HpEffect:draw()
    if not self.visible then return end

    love.graphics.setColor(self.current_color)
    draft:rectangle(self.x, self.y, 0.8*self.w, 1.8*self.h, 'fill')
    draft:rectangle(self.x, self.y, 1.8*self.w, 0.8*self.h, 'fill')
    love.graphics.setColor(default_color)
    draft:circle(self.x, self.y, self.sx*2*self.w, self.sy*2*self.h, 'line')
    love.graphics.setColor(default_color)
end

function HpEffect:destroy()
   HpEffect.super.destroy(self)
end
