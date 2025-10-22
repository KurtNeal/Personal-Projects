SmallRock = GameObject:extend()

function SmallRock:new(area, x, y, opts)
    SmallRock.super.new(self, area, x, y, opts)

    local direction = table.random({-1, 1})
    self.x = opts.x or gw / 2 + direction*(gw / 2 + 48)
    self.y = opts.y or random(16, gh - 16)
    self.shield = opts.shield or false
    self.owner = opts.owner or nil
    self.r = 0

    self.w, self.h = 3, 3
    self.collider = self.area.world:newPolygonCollider(createIrregularPolygon(3))
    self.collider:setPosition(self.x, self.y)
    self.collider:setObject(self)
    self.collider:setCollisionClass('EnemyProjectile')
    self.collider:setFixedRotation(false)
    
    self.v = opts.v or -direction*random(20, 40)
    self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))

    self.hp = 25
    self.damage = 10

    if self.shield then 
        self.orbit_distance = random(16, 36)
        self.orbit_speed = random(-5, 5)
        self.orbit_offset = random(0, 2*math.pi)
    end

    self.previous_x, self.previous_y = self.collider:getPosition()
end

function SmallRock:update(dt)
    SmallRock.super.update(self, dt)

    if self.owner.dead then
        self.v = 80
        local target = current_room.player
        if target then
            local projectile_heading = Vector(self.collider:getLinearVelocity()):normalized()
            local angle = math.atan2(target.y - self.y, target.x - self.x)
            local to_target_heading = Vector(math.cos(angle), math.sin(angle)):normalized()
            local final_heading = (projectile_heading + 0.1*to_target_heading):normalized()
            self.collider:setLinearVelocity(self.v*final_heading.x, self.v*final_heading.y)
            self.timer:after(random(3, 5), function() self:die() end)
        else 
            self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r)) 
        end
    end

    if self.collider:enter('Player') then
        local collision_data = self.collider:getEnterCollisionData('Player')
        local object = collision_data.collider:getObject()

        if object then
            object:hit(self.damage)
            self:die()
        end
    end

    if self.shield and not self.owner.dead then
        local player = self.owner
        self.collider:setPosition(
      	player.x + self.orbit_distance*math.cos(self.orbit_speed*time + self.orbit_offset),
      	player.y + self.orbit_distance*math.sin(self.orbit_speed*time + self.orbit_offset))
        local x, y = self.collider:getPosition()
        local dx, dy = x - self.previous_x, y - self.previous_y
        self.r = Vector(dx, dy):angle()
    
    end

    self.previous_x, self.previous_y = self.collider:getPosition()
end

function SmallRock:draw()
    pushRotate(self.x, self.y, Vector(self.collider:getLinearVelocity()):angle())
    love.graphics.setColor(rock_color)
    if self.hit_flash then love.graphics.setColor(default_color) end
    local points = {self.collider:getWorldPoints(self.collider.shapes.main:getPoints())}
    love.graphics.polygon('line', points)
    love.graphics.setColor(default_color)
    love.graphics.pop()
end

function SmallRock:destroy()
    SmallRock.super.destroy(self)
end

function SmallRock:hit(damage)
    self.hp = self.hp - (damage or 100)
    if self.hp <= 0 then
        self.dead = true
        for i = 1, love.math.random(8, 12) do self.area:addGameObject('ExplodeParticle', self.x, self.y, {s = 1, color = self.color}) end
    end
end

function SmallRock:die()
    self.dead = true
        self.area:addGameObject('ProjectileDeathEffect', self.x, self.y, {color = self.color, w = 3*2.5})
    for i = 1, love.math.random(8, 12) do self.area:addGameObject('ExplodeParticle', self.x, self.y, {s = 1, color = self.color}) end
end