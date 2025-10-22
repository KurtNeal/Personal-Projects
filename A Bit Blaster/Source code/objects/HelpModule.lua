HelpModule = Object:extend()

function HelpModule:new(console, y)
    self.console = console
    self.y = y

    self.console:addLine(0.02, 'Command List: ')
    self.console:addLine(0.04, 'start:         Starts the game')
    self.console:addLine(0.06, 'attack:        Displays attacks to choose')
    self.console:addLine(0.08, 'help:          Displays all commands')
    self.console:addLine(0.10, "resolution:    Displays screen resolution options")
    self.console:addLine(0.12, "exit:          Closes terminal")
    self.console.timer:after(0.16, function() self.active = true end)

    self.selection_index = 1
    self.selection_widths = {
        self.console.font:getWidth('start:'),
        self.console.font:getWidth('attack:'),
        self.console.font:getWidth('help:'),
        self.console.font:getWidth('resolution:'),
        self.console.font:getWidth('exit:'),
    }
end

function HelpModule:update(dt)
    if not self.active then return end

    if input:pressRepeat('up', 0.02, 0.4) then
        Switch:play()
        self.selection_index = self.selection_index - 1
        if self.selection_index < 1 then self.selection_index = #self.selection_widths end
    end

    if input:pressRepeat('down', 0.02, 0.4) then
        Switch:play()
        self.selection_index = self.selection_index + 1
        if self.selection_index > #self.selection_widths then self.selection_index = 1 end
    end

    if input:pressed('escape') then
        Exit:play()
        self.active = false
        self.console:addLine(0.02, '')
        self.console:addInputLine(0.04, '')
    end

    if input:pressed('return') then
        Enter:play()
        self.active = false
        if self.selection_index == 1 then
            table.insert(self.console.modules, StartModule(self.console, self.console.line_y))
        elseif self.selection_index == 2 then
            table.insert(self.console.modules, ChooseAttackModule(self.console, self.console.line_y))
        elseif self.selection_index == 3 then
            table.insert(self.console.modules, HelpModule(self.console, self.console.line_y))
        elseif self.selection_index == 4 then
            table.insert(self.console.modules, ResolutionModule(self.console, self.console.line_y))
        elseif self.selection_index == 5 then
            exit()
        end
    end
end

function HelpModule:draw()
    if not self.active then return end

    local width = self.selection_widths[self.selection_index]
    local r, g, b = unpack(default_color)
    love.graphics.setColor(r, g, b, 0.3765)
    local x_offset = self.console.font:getWidth('')
    love.graphics.rectangle('fill', 8 + x_offset - 2, self.y + self.selection_index*12, width + 4, self.console.font:getHeight())
    love.graphics.setColor(r, g, b, 1)
end