Rock = GameObject:extend()

function Rock:new(area, x, y, opts)
    Rock.super.new(self, area, x, y, opts)

    local direction = table.random({-1, 1})
    self.x = opts.x or gw / 2 + direction*(gw / 2 + 48)
    self.y = opts.y or random(16, gh - 16)

    self.w, self.h = 8, 8
    self.collider = self.area.world:newPolygonCollider(createIrregularPolygon(8))
    self.collider:setPosition(self.x, self.y)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Enemy')
    self.collider:setFixedRotation(false)
    
    self.v = opts.v or -direction*random(20, 40)
    self.collider:setLinearVelocity(self.v, 0)
    self.collider:applyAngularImpulse(random(-100, 100))

    self.hp = 100
end

function Rock:update(dt)
    Rock.super.update(self, dt)

    self.collider:setLinearVelocity(self.v, 0)
end

function Rock:draw()
    love.graphics.setColor(rock_color)
    if self.hit_flash then love.graphics.setColor(default_color) end
    local points = {self.collider:getWorldPoints(self.collider.shapes.main:getPoints())}
    love.graphics.polygon('line', points)
    love.graphics.setColor(default_color)
end

function Rock:destroy()
    Rock.super.destroy(self)
end

function Rock:hit(damage)
    self.hp = self.hp - (damage or 100)
    if self.hp <= 0 then
        Enemy_death:play()
        self.dead = true
        current_room.score = current_room.score + 100
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