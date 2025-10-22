Tanker = GameObject:extend()

function Tanker:new(area, x, y, opts)
    Tanker.super.new(self, area, x, y, opts)

    local direction = opts.direction or table.random({-1, 1})
    self.x = gw / 2 + direction*(gw / 2 + 48)
    self.y = random(16, gh - 16)

    self.w, self.h = 32, 32
    self.collider = self.area.world:newPolygonCollider(createIrregularPolygon(32))
    self.collider:setPosition(self.x, self.y)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Enemy')

    self.v = -direction*random(20, 40)
    self.vx = self.v
    self.dr = random(-10, 10)

    self.hp = 1600
end

function Tanker:update(dt)
    Tanker.super.update(self, dt)

    self.collider:setLinearVelocity(self.vx*dt, 0)
    self.collider:applyAngularImpulse(self.dr*dt)
    self.x, self.y = self.collider:getPosition()
end

function Tanker:draw()
    love.graphics.setColor(rock_color)
    if self.hit_flash then love.graphics.setColor(default_color) end
    local points = {self.collider:getWorldPoints(self.collider.shapes.main:getPoints())}
    love.graphics.polygon('line', points)
    love.graphics.setColor(default_color)
end

function Tanker:destroy()
    Tanker.super.destroy(self)
end

function Tanker:hit(damage)
    if self.dead then return end

    self.hp = self.hp - (damage or 100)
    if self.hp <= 0 then
        Enemy_death:play()
        self.dead = true
        current_room.score = current_room.score + 1000
        if not current_room.player.no_ammo_drop then
            if current_room.player.double_ammo_drop then
                self.area:addGameObject('Ammo', self.x, self.y)
                self.area:addGameObject('Ammo', self.x, self.y)
            else
                self.area:addGameObject('Ammo', self.x, self.y)
            end
        end
        for i = 1, 4 do self.area:addGameObject('BigRock', 0, 0, {x = self.x + random(-32, 32), y = self.y + random(-32, 32), direction = -sign(self.v)}) end
    else
        self.hit_flash = true
        self.timer:after('hit_flash', 0.2, function() self.hit_flash = false end)
    end
end
