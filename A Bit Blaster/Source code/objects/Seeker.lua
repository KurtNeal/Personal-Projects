Seeker = GameObject:extend()

function Seeker:new(area, x, y, opts)
    Seeker.super.new(self, area, x, y, opts)

    local direction = table.random({1, -1})
    self.x = gw / 2 + direction*(gw / 2 + 48)
    self.y = random(16, gh - 16)
    self.r = 0

    self.w, self.h = 12, 6
    self.collider = self.area.world:newPolygonCollider({self.w, 0, self.w/2, -self.w/2, -self.w/2, -self.w/2, -self.w, 0, -self.w/2, self.w/2, self.w/2, self.w/2})
    self.collider:setPosition(self.x, self.y)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Enemy')

    self.v = -direction*random(20, 40)
    self.collider:setFixedRotation(false)
    self.collider:setAngle(direction == -1 and math.pi or 0)
    self.collider:setFixedRotation(true)
    self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))
    self.collider:applyAngularImpulse(random(-100, 100))

    self.hp = 200

    self.timer:every(random(3, 5), function() self.area:addGameObject('PreAttackEffect',
        self.x + 1.4*self.w*math.cos(self.collider:getAngle()),
        self.y + 1.4*self.w*math.sin(self.collider:getAngle()), 
        {seeker = self, color = rock_color, duration = 1})
        self.timer:after(1, function() self.area:addGameObject('EnemyProjectile', 
            self.x + 1.4*self.w*math.cos(self.collider:getAngle()),
            self.y + 1.4*self.w*math.sin(self.collider:getAngle()),
            {r = math.atan2(current_room.player.y - self.y, current_room.player.x - self.x), v = random(80, 100), s = 3.5, color = rock_color, mine = true})

        end) 
    end)
end

function Seeker:update(dt)
    Seeker.super.update(self, dt)

    local target = current_room.player
    if target then
        local projectile_heading = Vector(self.collider:getLinearVelocity()):normalized()
        local angle = math.atan2(target.y - self.y, target.x - self.x)
        local to_target_heading = Vector(math.cos(angle), math.sin(angle)):normalized()
        local final_heading = (projectile_heading + 0.1*to_target_heading):normalized()
        self.collider:setLinearVelocity(self.v*final_heading.x, self.v*final_heading.y)
    else 
        self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r)) 
    end
end

function Seeker:draw()
    pushRotate(self.x, self.y, Vector(self.collider:getLinearVelocity()):angle())
    love.graphics.setColor(rock_color)
    if self.hit_flash then love.graphics.setColor(default_color) end
    local points = {self.collider:getWorldPoints(self.collider.shapes.main:getPoints())}
    love.graphics.polygon('line', points)
    love.graphics.setColor(default_color)
    love.graphics.pop()
end

function Seeker:destroy()
    Seeker.super.destroy(self)
end

function Seeker:hit(damage)
    self.hp = self.hp - (damage or 100)
    if self.hp <= 0 then
        Enemy_death:play()
        self.dead = true
        current_room.score = current_room.score + 250
        self.area:addGameObject('EnemyDeathEffect', self.x, self.y, {color = rock_color, w = 3*self.w})
        if not current_room.player.no_ammo_drop then
            if current_room.player.double_ammo_drop then
                self.area:addGameObject('Ammo', self.x, self.y)
                self.area:addGameObject('Ammo', self.x, self.y)
            else
                self.area:addGameObject('Ammo', self.x, self.y)
            end
        end
    else
        self.hit_flash = true
        self.timer:after('hit_flash', 0.2, function() self.hit_flash = false end)
    end
end