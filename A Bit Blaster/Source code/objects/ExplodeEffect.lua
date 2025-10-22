ExplodeEffect = GameObject:extend()

function ExplodeEffect:new(area, x, y, opts)
    ExplodeEffect.super.new(self, area, x, y, opts)

    self.area_multiplier = current_room.player.area_multiplier

    self.color = opts.color or default_color
    self.s = opts.s or 5.5
    self.w, self.h = opts.w or 48, opts.h or 48
    self.w = self.w * self.area_multiplier
    self.h = self.h * self.area_multiplier
    self.y_offset = 0
    self.timer:tween(0.30, self, {h = 0, w = 0}, 'in-out-bounce', function() self.dead = true end)
    
    self.collider = self.area.world:newRectangleCollider(self.x, self.y, self.w, self.h)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Projectile')

    self.damage = 200
end

function ExplodeEffect:update(dt)
    ExplodeEffect.super.update(self, dt)
    if self.parent then self.x, self.y = self.parent.x, self.parent.y - self.y_offset end

    if self.collider:enter('Enemy') then
        local collision_data = self.collider:getEnterCollisionData('Enemy')
        local object = collision_data.collider:getObject()

        if object then
            object:hit(self.damage)
        end
    end
end

function ExplodeEffect:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle('fill', self.x - self.w / 2, self.y - self.h / 2, self.w, self.h)
    love.graphics.setColor(1, 1, 1)
end

function ExplodeEffect:destroy()
    ExplodeEffect.super.destroy(self)
end