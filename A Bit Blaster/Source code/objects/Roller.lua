Roller = GameObject:extend()

function Roller:new(area, x, y, opts)
    Roller.super.new(self, area, x, y, opts)

    local direction = opts.direction or table.random({-1, 1})
    self.x = opts.x or (random(16, gw - 16))
    self.y = opts.y or (gh / 2 + direction*(gh / 2 + 48))

    self.w, self.h = 10, 10
    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Enemy')

    self.v = -direction*random(20, 40)
    self.vy = self.v
    self.dr = random(-10, 10)

    self.hp = 200
    self.timer:every(0.4, function() self.area:addGameObject('RollerPool', self.x, self.y) end)
end

function Roller:update(dt)
    Roller.super.update(self, dt)

    self.collider:setLinearVelocity(0, self.vy)
    self.collider:applyAngularImpulse(self.dr)
    self.x, self.y = self.collider:getPosition()
end

function Roller:draw()
    love.graphics.setColor(rock_color)
    if self.hit_flash then love.graphics.setColor(default_color) end
    love.graphics.circle('line', self.x, self.y, self.w)
    love.graphics.setColor(default_color)
end

function Roller:destroy()
    Roller.super.destroy(self)
end

function Roller:hit(damage)
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
    else
        self.hit_flash = true
        self.timer:after('hit_flash', 0.2, function() self.hit_flash = false end)
    end
end