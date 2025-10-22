EnemyProjectile = GameObject:extend()

function EnemyProjectile:new(area, x, y, opts)
    EnemyProjectile.super.new(self, area, x, y, opts)

    self.s = opts.s or 2.5
    self.v = opts.v or 200
    self.color = opts.color or hp_color
    self.mine = opts.mine or false

    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.s)
    self.collider:setObject(self)
    self.collider:setCollisionClass('EnemyProjectile')
    self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))

    self.damage = 10
    self.hp = opts.hp or 1

    if self.mine then
        self.rv = table.random({random(-12*math.pi, -10*math.pi), random(10*math.pi, 12*math.pi)})
        self.timer:after(random(12, 14), function()
            self:die()
        end)
    end

end

function EnemyProjectile:update(dt)
    EnemyProjectile.super.update(self, dt)

    self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))

    if self.mine then self.r = self.r + self.rv*dt end

    if self.collider:enter('Player') then
        local collision_data = self.collider:getEnterCollisionData('Player')
        local object = collision_data.collider:getObject()

        if object then
            object:hit(self.damage)
            self:die()
            
        end
    end
    
    if self.x < 0 then self:die() end
    if self.y < 0 then self:die() end
    if self.x > gw then self:die() end
    if self.y > gh then self:die() end

    self.previous_x, self.previous_y = self.collider:getPosition()
end

function EnemyProjectile:draw()
    love.graphics.setColor(self.color)
    pushRotate(self.x, self.y, Vector(self.collider:getLinearVelocity()):angle()) 
    love.graphics.setLineWidth(self.s - self.s/4)
    love.graphics.line(self.x - 2*self.s, self.y, self.x, self.y)
    love.graphics.line(self.x, self.y, self.x + 2*self.s, self.y)
    love.graphics.setLineWidth(1)
    love.graphics.pop()
    love.graphics.setColor(default_color)
end

function EnemyProjectile:destroy()
    EnemyProjectile.super.destroy(self)
end

function EnemyProjectile:hit()
    self.hp = self.hp - 1
    if self.hp <= 0 then self:die() end
end

function EnemyProjectile:die()
    self.dead = true
    self.area:addGameObject('ProjectileDeathEffect', self.x, self.y, {color = self.color, w = 3*self.s})
    for i = 1, love.math.random(8, 12) do self.area:addGameObject('ExplodeParticle', self.x, self.y, {s = 1, color = self.color}) end
end
