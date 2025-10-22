Stage = Object:extend()

function Stage:new()
    self.area = Area(self)
    self.area:addPhysicsWorld()
    self.area.world:addCollisionClass('Player')
    self.area.world:addCollisionClass('Enemy')
    self.area.world:addCollisionClass('Projectile', {ignores = {'Projectile', 'Player'}})
    self.area.world:addCollisionClass('Collectable', {ignores = {'Collectable', 'Projectile'}})
    self.area.world:addCollisionClass('EnemyProjectile', {ignores = {'EnemyProjectile', 'Projectile', 'Enemy', 'Collectable'}})

    self.font = fonts.m5x7_16
    self.main_canvas = love.graphics.newCanvas(gw, gh)
    self.rgb_shift_canvas = love.graphics.newCanvas(gw, gh)
    self.final_canvas = love.graphics.newCanvas(gw, gh)
    self.player = self.area:addGameObject('Player', gw / 2, gh / 2)
    self.director = Director(self)

    self.score = 0
    self.paused = false
    self.scorescreen = false
    self.start_sp = skill_points

    self.rgb_shift = love.graphics.newShader('resources/shaders/rgb_shift.frag')
    self.rgb_shift_mag = 2

    Automation:stop()
    Automation:play()
end

function Stage:update(dt)
    if input:pressed('escape') and not self.scorescreen then 
        self:pause()
        Automation:pause()
    end

    if not self.paused and not self.scorescreen then Automation:resume() end
    if self.paused then self.paused_object:update(dt) end
    if self.paused then return end
    self.director:update(dt)

    if self.scorescreen then self.scorescreen_object:update(dt) end
    if not self.scorescreen then self.director:update(dt) end

    camera.smoother = Camera.smooth.damped(5)
    camera:lockPosition(dt, gw / 2, gh / 2)

    self.area:update(dt)
end

function Stage:draw()
    love.graphics.setCanvas(self.rgb_shift_canvas)
    love.graphics.clear()
    	camera:attach(0, 0, gw, gh)
    	self.area:drawOnly({'rgb_shift'})
    	camera:detach()
    love.graphics.setCanvas()

    love.graphics.setCanvas(self.main_canvas)
    love.graphics.clear()
        camera:attach(0, 0, gw, gh)
        self.area:drawExcept({'rgb_shift'})
        camera:detach()

        love.graphics.setFont(self.font)

        -- Score
        love.graphics.setColor(default_color)
        love.graphics.print(self.score, gw - 20, 10, 0, 1, 1, math.floor(self.font:getWidth(self.score) / 2), math.floor(self.font:getHeight() / 2))
        love.graphics.setColor(1, 1, 1)

        -- Skill Points
        love.graphics.setColor(skill_point_color)
        love.graphics.print(skill_points .. ' SP', gw - 465, 10, 0, 1, 1, math.floor(self.font:getWidth(skill_points) / 2), math.floor(self.font:getHeight() / 2))
        love.graphics.setColor(1, 1, 1)

        -- HP
        if self.player.energy_shield then
            local r, g, b = unpack(default_color)
            local hp, max_hp = self.player.hp, self.player.max_hp
            love.graphics.setColor(r, g, b)
            love.graphics.rectangle('fill', gw / 2 - 52, gh - 16, 48*(hp/max_hp), 4)
            love.graphics.setColor(r - 0.125, g - 0.125, b - 0.125)
            love.graphics.rectangle('line', gw / 2 - 52, gh - 16, 48, 4)
            love.graphics.print('ES', gw / 2 - 52 + 24, gh - 24, 0, 1, 1, math.floor(self.font:getWidth('ES') / 2), math.floor(self.font:getHeight() / 2))
            love.graphics.print(hp .. '/' .. max_hp, gw / 2 - 52 + 24, gh - 6, 0, 1, 1, math.floor(self.font:getWidth(hp .. '/' .. max_hp) / 2), math.floor(self.font:getHeight() / 2))
            love.graphics.setColor(1, 1, 1, 1)
        else
            local r, g, b = unpack(hp_color)
            local hp, max_hp = self.player.hp, self.player.max_hp
            love.graphics.setColor(r, g, b)
            love.graphics.rectangle('fill', gw / 2 - 52, gh - 16, 48*(hp/max_hp), 4)
            love.graphics.setColor(r - 0.125, g - 0.125, b - 0.125)
            love.graphics.rectangle('line', gw / 2 - 52, gh - 16, 48, 4)
            love.graphics.print('HP', gw / 2 - 52 + 24, gh - 24, 0, 1, 1, math.floor(self.font:getWidth('HP') / 2), math.floor(self.font:getHeight() / 2))
            love.graphics.print(hp .. '/' .. max_hp, gw / 2 - 52 + 24, gh - 6, 0, 1, 1, math.floor(self.font:getWidth(hp .. '/' .. max_hp) / 2), math.floor(self.font:getHeight() / 2))
            love.graphics.setColor(1, 1, 1, 1)
        end

        -- Ammo
        local r, g, b = unpack(ammo_color)
        local ammo, max_ammo = self.player.ammo, self.player.max_ammo
        love.graphics.setColor(r, g, b)
        love.graphics.rectangle('fill', gw / 2 - 52, gh - 258, 48*(ammo/max_ammo), 4)
        love.graphics.setColor(r - 0.125, g - 0.125, b - 0.125)
        love.graphics.rectangle('line', gw / 2 - 52, gh - 258, 48, 4)
        love.graphics.print('Ammo', gw / 2 - 52 + 16, gh - 249, 0, 1, 1, math.floor(self.font:getWidth('HP') / 2), math.floor(self.font:getHeight() / 2))
        love.graphics.print(ammo .. '/' .. max_ammo, gw / 2 - 52 + 24, gh - 265, 0, 1, 1, math.floor(self.font:getWidth(ammo .. '/' .. max_ammo) / 2), math.floor(self.font:getHeight() / 2))
        love.graphics.setColor(1, 1, 1, 1)

        -- Boost
        local r, g, b = unpack(boost_color)
        local boost, max_boost = self.player.boost, self.player.max_boost
        boost = math.floor(boost)
        love.graphics.setColor(r, g, b)
        love.graphics.rectangle('fill', gw / 2 + 4, gh - 258, 48*(boost/max_boost), 4)
        love.graphics.setColor(r - 0.125, g - 0.125, b - 0.125)
        love.graphics.rectangle('line', gw / 2 + 4, gh - 258, 48, 4)
        love.graphics.print('Boost', gw / 2 + 27, gh - 249, 0, 1, 1, math.floor(self.font:getWidth('Boost') / 2), math.floor(self.font:getHeight() / 2))
        love.graphics.print(boost .. '/' .. max_boost, gw / 2 + 4 + 24, gh - 265, 0, 1, 1, math.floor(self.font:getWidth(boost .. '/' .. max_boost) / 2), math.floor(self.font:getHeight() / 2))
        love.graphics.setColor(1, 1, 1, 1)

        -- Cycle
        local r, g, b = unpack(default_color)
        local cycle_timer, cycle_cooldown = self.player.cycle_timer, self.player.cycle_cooldown
        love.graphics.setColor(r, g, b)
        love.graphics.rectangle('fill', gw / 2 + 4, gh - 16, 48*(cycle_timer/cycle_cooldown), 4)
        love.graphics.setColor(r - 0.125, g - 0.125, b - 0.125)
        love.graphics.rectangle('line', gw / 2 + 4, gh - 16, 48, 4)
        love.graphics.print('Cycle', gw / 2 + 4 + 24, gh - 24, 0, 1, 1, math.floor(self.font:getWidth('Cycle') / 2), math.floor(self.font:getHeight() / 2))

        -- Difficulty
        local r, g, b = unpack(default_color)
        love.graphics.setColor(r, g, b)
        love.graphics.rectangle('fill', gw / 2 - 235, gh - 10, 48*(self.director.round_timer/(self.director.round_duration/(self.player.enemy_spawn_rate_multiplier))), 4)
        love.graphics.setColor(r - 32, g - 32, b - 32)
        love.graphics.rectangle('line', gw / 2 - 235, gh - 10, 48, 4)
        love.graphics.print(self.director.difficulty, gw / 2 - 185, gh - 9, 0, 1, 1, 0, math.floor(self.font:getHeight()/2))

        -- Pause, scorescreen
        if self.scorescreen then self.scorescreen_object:draw() end
        if self.paused then self.paused_object:draw() end
    love.graphics.setCanvas()

    love.graphics.setCanvas(self.final_canvas)
    love.graphics.clear()
        love.graphics.setColor(1, 1, 1)
        love.graphics.setBlendMode("alpha", "premultiplied")
  
        self.rgb_shift:send('amount', {random(-self.rgb_shift_mag, self.rgb_shift_mag)/gw, random(-self.rgb_shift_mag, self.rgb_shift_mag)/gh})
        love.graphics.setShader(self.rgb_shift)
        love.graphics.draw(self.rgb_shift_canvas, 0, 0, 0, 1, 1)
        love.graphics.setShader()
  
  		love.graphics.draw(self.main_canvas, 0, 0, 0, 1, 1)
  		love.graphics.setBlendMode("alpha")
    love.graphics.setCanvas()

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.final_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha')
    love.graphics.setShader()
end

function Stage:destroy()
    self.area:destroy()
    self.area = nil
    self.player = nil
end

function Stage:finish()
    timer:after(1, function() 
        score = self.score
        if score > high_score then high_score = score end 

        run = run + 1
        self.scorescreen = true
        self.difficulty_reached = self.director.difficulty
        self.scorescreen_object = ScoreScreen(self)
    end)
end

function Stage:pause()
    self.paused = not self.paused 
    if self.paused then self.paused_object = Paused(self)
    else self.paused_object = nil end
end

