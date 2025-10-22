ChooseAttackModule = Object:extend()

function ChooseAttackModule:new(console, y)
    self.console = console

    self.console:addLine(0.02, 'choose attack to start with:')
    self.console:addLine(0.04, 'neutral')
    self.console:addLine(0.06, 'double')
    self.console:addLine(0.08, 'triple')
    self.console:addLine(0.10, 'rapid')
    self.console:addLine(0.12, 'spread')
    self.console:addLine(0.14, 'back')
    self.console:addLine(0.16, 'side')
    self.console:addLine(0.18, 'homing')
    self.console:addLine(0.20, 'blast')
    self.console:addLine(0.22, 'spin')
    self.console:addLine(0.24, 'flame')
    self.console:addLine(0.26, 'bounce')
    self.console:addLine(0.28, '2split')
    self.console:addLine(0.30, '4split')
    self.console:addLine(0.32, 'lightning')
    self.console:addLine(0.34, 'explode')

    self.y = y
    self.h = 6*self.console.font:getHeight()

    self.attack_index = 1
    self.selection_widths = {
        self.console.font:getWidth('neutral'), self.console.font:getWidth('double'), 
        self.console.font:getWidth('triple'), self.console.font:getWidth('rapid'), 
        self.console.font:getWidth('spread'), self.console.font:getWidth('back'),
        self.console.font:getWidth('side'), self.console.font:getWidth('homing'), 
        self.console.font:getWidth('blast'), self.console.font:getWidth('spin'), 
        self.console.font:getWidth('flame'), self.console.font:getWidth('bounce'),
        self.console.font:getWidth('neutral'), self.console.font:getWidth('4split'), 
        self.console.font:getWidth('lightning'), self.console.font:getWidth('explode'),
    }

    self.attacks = {'Neutral', 'Double', 'Triple', 'Rapid', 'Spread', 'Back', 'Side', 'Homing', 'Blast', 'Spin', 'Flame', 'Bounce', '2Split', '4Split', 'Lightning', 'Explode'}
    self.console.timer:after(0.02 + self.attack_index*0.02, function() self.active = true end)
end

function ChooseAttackModule:update(dt)
    if not self.active then return end

    if input:pressRepeat('up', 0.02, 0.4) then
        Switch:play()
        self.attack_index = self.attack_index - 1
        if self.attack_index < 1 then self.attack_index = #self.selection_widths end
        local current_attack = self.attacks[self.attack_index]
        attack = current_attack
    end

    if input:pressRepeat('down', 0.02, 0.4) then
        Switch:play()
        self.attack_index = self.attack_index + 1
        if self.attack_index > #self.selection_widths then self.attack_index = 1 end
        local current_attack = self.attacks[self.attack_index]
        attack = current_attack
    end

    if input:pressed('return') then
        Enter:play()
        self.active = false
        local current_attack = self.attacks[self.attack_index]
        Player.console_attack = current_attack
        self.console:addLine(0.02, '')
        self.console:addInputLine(0.04)
    end

    if input:pressed('escape') then
        Exit:play()
        self.active = false
        self.console:addLine(0.02, '')
        self.console:addInputLine(0.04, '')
    end
end

function ChooseAttackModule:draw()
    if not self.active then return end

    local width = self.selection_widths[self.attack_index]
    local r, g, b = unpack(default_color)
    love.graphics.setColor(r, g, b, 0.3765)
    local x_offset = self.console.font:getWidth('')
    love.graphics.rectangle('fill', 8 + x_offset - 2, self.y + self.attack_index*12, width + 4, self.console.font:getHeight())
    love.graphics.setColor(r, g, b, 1)
end