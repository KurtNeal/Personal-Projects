Console = Object:extend()

function Console:new()
    self.timer = Timer()
    self.area = Area(self)

    self.font = fonts.Anonymous_8
    self.main_canvas = love.graphics.newCanvas(gw, gh)

    self.lines = {}
    self.line_y = 8
    camera:lookAt(gw/2, gh/2)
    camera.scale = 1
    Menu:play()

    self.inputting = false
    self.input_text = {}
    self.base_input_text = {'[', skill_point_color, 'root', white, ']arch~ '}
    self.cursor_visible = true
    self.timer:every('cursor', 0.5, function() self.cursor_visible = not self.cursor_visible end)

    self.modules = {}

    self:addLine(1, {'console booting up..'})
    self:addLine(2.5, {'checking systens..'})
    self:addLine(3.5, {'all systens operating in', skill_point_color, ' 100%', white, ' capacity'})
    self:addLine(3.6, {''})
    self:addLine(4.5, {'Welcome! ', white, 'to ', skill_point_color, 'A Bit Blaster ', default_color, 'v1.07'})
    self:addLine(5, {'made by ', default_color, 'Kurtical'})
    self:addLine(5.5, {''})
    self:addLine(5.5, {''})
    self:addLine(6, {'Type ', boost_color, '"help"', white, ' to see a list of console commands'})
    self:addLine(6.5, {''})
    self:addLine(6.5, {''})
    self:addLine(6.5, {''})
    self:addLine(6.5, {''})
    self:addLine(6.5, {''})
    self:addLine(6.5, {''})
    self:addLine(6.5, {''})
    self:addLine(6.5, {''})
    self:addLine(6.5, {''})
    self:addLine(6.5, {''})
    self:addLine(6.5, {''})
    self:addInputLine(7)
end

function Console:update(dt)
    self.timer:update(dt)
    self.area:update(dt)
    
    for _, module in ipairs(self.modules) do module:update(dt) end

    if self.inputting then
        if input:pressed('return') then
            Enter:play()
            self.inputting = false

            self.line_y = self.line_y + 12
            local input_text = ''
            for _, character in ipairs(self.input_text) do input_text = input_text .. character end
            self.input_text = {}
            input_text = string.lower(input_text)

            if input_text == 'help' or input_text == 'commands' or input_text == 'command list' then
                table.insert(self.modules, HelpModule(self, self.line_y))
            end

            if input_text == 'resolution' or input_text == 'change resolution' then
                table.insert(self.modules, ResolutionModule(self, self.line_y))
            end

            if input_text == 'start' or input_text == 'play' or input_text == 'start game' or input_text == 'play game' then
                table.insert(self.modules, StartModule(self, self.line_y))
            end

            if input_text == 'exit' or input_text == 'quit' or input_text == 'escape' then
                exit()
            end
            
            if input_text == 'attack' or input_text == 'choose attack' then
                table.insert(self.modules, ChooseAttackModule(self, self.line_y))
            end
        end
        if input:pressRepeat('backspace', 0.02, 0.2) then
            Delete:play()
            table.remove(self.input_text, #self.input_text) 
            self:updateText()
        end
    end

    if input:pressed('escape') and self.inputting then
        Exit:play()
        exit()
    end
end

function Console:draw()
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.clear()
    camera:attach(0, 0, gw, gh)
    for _, line in ipairs(self.lines) do love.graphics.draw(line.text, line.x, line.y) end
    for _, module in ipairs(self.modules) do module:draw() end

    if self.inputting and self.cursor_visible then
        local r, g, b = unpack(default_color)
        love.graphics.setColor(r, g, b, 0.3765)
        local input_text = ''
        for _, character in ipairs(self.input_text) do input_text = input_text .. character end
        local x = self.font:getWidth('[root]arch~ ' .. input_text)
        love.graphics.rectangle('fill', 8 + x, self.lines[#self.lines].y, self.font:getWidth('w'), self.font:getHeight())
        love.graphics.setColor(r, g, b, 1)
    end
    for _, module in ipairs(self.modules) do module:draw() end
    camera:detach()
    love.graphics.setCanvas()

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha')
end

function Console:destroy()

end

function Console:addLine(delay, text)
    self.timer:after(delay, function()
        table.insert(self.lines, {x = 8, y = self.line_y, text = love.graphics.newText(self.font, text)}) 
        self.line_y = self.line_y + 12
        
        if self.line_y > gh then camera:lookAt(camera.x, camera.y + 15) end 
    end)
end

function Console:addInputLine(delay)
    self.timer:after(delay, function()
        table.insert(self.lines, {x = 8, y = self.line_y, text = love.graphics.newText(self.font, self.base_input_text)})
        self.line_y = self.line_y + 12
        self.inputting = true
        if self.line_y > gh then camera:lookAt(camera.x, camera.y + 15) end 
    end)
end

function Console:textinput(t)
    if self.inputting then
        Type:play()
        table.insert(self.input_text, t)
        self:updateText()
    end
end

function Console:updateText()
    local base_input_text = table.copy(self.base_input_text)
    local input_text = ''
    for _, character in ipairs(self.input_text) do input_text = input_text .. character end
    table.insert(base_input_text, input_text)
    self.lines[#self.lines].text:set(base_input_text)
end