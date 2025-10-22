BigRock = GameObject:extend()

function BigRock:new(area, x, y, opts)
    BigRock.super.new(self, area, x, y, opts)

    local direction = opts.direction or table.random({-1, 1})
    self.x = opts.x or gw / 2 + direction*(gw / 2 + 48)
    self.y = opts.y or random(16, gh - 16)

    self.w, self.h = 16, 16
    self.collider = self.area.world:newPolygonCollider(createIrregularPolygon(16))
    self.collider:setPosition(self.x, self.y)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Enemy')
    self.collider:setFixedRotation(false)

    self.v = -direction*random(20, 40)
    self.vx = self.v
    self.dr = random(-10, 10)

    self.hp = 300
end

function BigRock:update(dt)
    BigRock.super.update(self, dt)

    self.collider:setLinearVelocity(self.vx, 0)
    self.collider:applyAngularImpulse(self.dr)
    self.x, self.y = self.collider:getPosition()
end

function BigRock:draw()
    love.graphics.setColor(rock_color)
    if self.hit_flash then love.graphics.setColor(default_color) end
    local points = {self.collider:getWorldPoints(self.collider.shapes.main:getPoints())}
    love.graphics.polygon('line', points)
    love.graphics.setColor(default_color)
end

function BigRock:destroy()
    BigRock.super.destroy(self)
end

function BigRock:hit(damage)
    self.hp = self.hp - (damage or 100)
    if self.hp <= 0 then
        Enemy_death:play()
        self.dead = true
        current_room.score = current_room.score + 200
        self.area:addGameObject('EnemyDeathEffect', self.x, self.y, {color = rock_color, w = 3*self.w})
        if not current_room.player.no_ammo_drop then
            if current_room.player.double_ammo_drop then
                self.area:addGameObject('Ammo', self.x, self.y)
                self.area:addGameObject('Ammo', self.x, self.y)
            else
                self.area:addGameObject('Ammo', self.x, self.y)
            end
        end
        for i = 1, 4 do
            self.area:addGameObject('Rock', self.x, self.y, {x = self.x, y = self.y, v = self.v})
        end
        for i = 1, love.math.random(8, 12) do self.area:addGameObject('ExplodeParticle', self.x, self.y, {s = 20, color = rock_color}) end
    else
        self.hit_flash = true
        self.timer:after('hit_flash', 0.2, function() self.hit_flash = false end)
    end
end