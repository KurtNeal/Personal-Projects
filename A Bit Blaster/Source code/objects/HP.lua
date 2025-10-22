HP = GameObject:extend()

function HP:new(area, x, y, opts)
    HP.super.new(self, area, x, y, opts)

    local direction = table.random({-1, 1})
    self.x = gw / 2 + direction*(gw/2 + 48)
    self.y = random(48, gh - 48)

    self.w, self.h = 12, 12
    self.collider = self.area.world:newRectangleCollider(self.x, self.y, self.w, self.h)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Collectable')
    self.collider:setFixedRotation(false)
    self.v = -direction*random(20, 40)
    self.collider:setLinearVelocity(self.v, 0)
    self.collider:applyAngularImpulse(random(-24, 24))
end

function HP:update(dt)
    HP.super.update(self, dt)

    self.collider:setLinearVelocity(self.v, 0)
end

function HP:draw()
    love.graphics.setColor(default_color)
    pushRotate(self.x, self.y, self.collider:getAngle())
    draft:circle(self.x, self.y, 2*self.w, 2*self.h, 'line')
    love.graphics.setColor(hp_color)
    draft:rectangle(self.x, self.y, 0.4*self.w, 1.2*self.h, 'fill')
    draft:rectangle(self.x, self.y, 1.2*self.w, 0.4*self.h, 'fill')
    love.graphics.pop()
    love.graphics.setColor(default_color)
end

function HP:destroy()
    HP.super.destroy(self)
end

function HP:die()
    self.dead = true
    self.area:addGameObject('HpEffect', self.x, self.y, {color = hp_color, w = self.w, h = self.h})
    self.area:addGameObject('InfoText', self.x + table.random({-1, 1})*self.w, self.y + table.random({-1, 1})*self.h, {text = '+HP', color = hp_color})
end