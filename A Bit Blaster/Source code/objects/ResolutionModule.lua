ResolutionModule = Object:extend()

function ResolutionModule:new(console, y)
    self.console = console
    
    self.console:addLine(0.02, 'available resolutions: ')
    self.console:addLine(0.04, '480x270')
    self.console:addLine(0.06, '960x540')
    self.console:addLine(0.08, '1440x810')
    self.console:addLine(0.10, '1920x1080')


    self.y = y
    self.h = 6*self.console.font:getHeight()

    self.selection_index = 1
    self.selection_widths = {self.console.font:getWidth('480x270'), self.console.font:getWidth('960x540'), self.console.font:getWidth('1440x810'), self.console.font:getWidth('1920x1080')}
    self.console.timer:after(0.02 + self.selection_index*0.02, function() self.active = true end)
end

function ResolutionModule:update(dt)
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

    if input:pressed('return') then
        Enter:play()
        self.active = false
        resize(self.selection_index)
        self.console:addLine(0.02, '')
        self.console:addInputLine(0.04)
    end

    if input:pressed('escape') then
        Exit:play()
        self.active = false
        self.console:addLine(0.02, '')
        self.console:addInputLine(0.04)
    end
end

function ResolutionModule:draw()
    if not self.active then return end

    local width = self.selection_widths[self.selection_index]
    local r, g, b = unpack(default_color)
    love.graphics.setColor(r, g, b, 0.3765)
    local x_offset = self.console.font:getWidth('')
    love.graphics.rectangle('fill', 8 + x_offset - 2, self.y + self.selection_index*12, width + 4, self.console.font:getHeight())
    love.graphics.setColor(r, g, b, 1)
end