Waver = GameObject:extend()

function Waver:new(area, x, y, opts)
    Waver.super.new(self, area, x, y, opts)

    local direction = table.random({-1, 1})
    self.x = gw / 2 + direction*(gw / 2 + 48)
    self.y = random(16, gh - 16)
    self.r = 0

    self.w, self.h = 8, 4
    self.collider = self.area.world:newPolygonCollider({self.w, 0, -self.w/2, self.h, -self.w*2, 0, -self.w/2, -self.h})
    self.collider:setPosition(self.x, self.y)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Enemy')

    self.v = -direction*random(60, 80)
    self.collider:setAngle(direction == 1 and math.pi or 0)
    self.collider:setFixedRotation(true)
    self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))

    self.hp = 70

    self.timer:every(random(0.5, 2), function() local d = 1.2*self.w
        self.area:addGameObject('EnemyProjectile', self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), {r = self.r, attack = self.attack, color = rock_color})
        self.area:addGameObject('EnemyProjectile', self.x + 1.5*d*math.cos(self.r + math.pi / 1), self.y + 1.5*d*math.sin(self.r + math.pi / 1), {r = self.r + math.pi / 1, attack = self.attack, color = rock_color})

    end)

    self.timer:tween(0.25, self, {r = self.r + direction*math.pi / 4}, 'linear', function()
        self.timer:tween(0.25, self, {r = self.r - direction*math.pi / 2}, 'linear')
    end)
    self.timer:every(0.75, function()
        self.timer:tween(0.25, self, {r = self.r + direction*math.pi / 2}, 'linear', function()
            self.timer:tween(0.5, self, {r = self.r - direction*math.pi / 2}, 'linear')
        end)
    end)
end

function Waver:update(dt)
    Waver.super.update(self, dt)

    self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))
end

function Waver:draw()
    pushRotate(self.x, self.y, Vector(self.collider:getLinearVelocity()):angle())
    love.graphics.setColor(rock_color)
    if self.hit_flash then love.graphics.setColor(default_color) end
    local points = {self.collider:getWorldPoints(self.collider.shapes.main:getPoints())}
    love.graphics.polygon('line', points)
    love.graphics.setColor(default_color)
    love.graphics.pop()
end

function Waver:destroy()
    Waver.super.destroy(self)
end

function Waver:hit(damage)
    self.hp = self.hp - (damage or 100)
    if self.hp <= 0 then
        self.dead = true
        Enemy_death:play()
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