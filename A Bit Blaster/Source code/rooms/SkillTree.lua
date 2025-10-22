SkillTree = Object:extend()

function SkillTree:new()
    self.timer = Timer()

    self.font = fonts.m5x7_16
    self.main_canvas = love.graphics.newCanvas(gw, gh)

    self.nodes = {}
    self.lines = {}

    -- Bi-directional links
    self.tree = table.copy(tree)
    for id, node in ipairs(self.tree) do
        for _, linked_node_id in ipairs(node.links or {}) do
            table.insert(self.tree[linked_node_id], id)
        end
    end
    for id, node in ipairs(self.tree) do
        if node.links then
            node.links = fn.unique(node.links)
        end
    end

    -- Create nodes and links
    for id, node in pairs(self.tree) do self.nodes[id] = Node(id, node.x, node.y, node.size) end
    for id, node in pairs(self.tree) do 
        for _, linked_node_id in ipairs(node.links or {}) do
            table.insert(self.lines, Line(self.nodes, id, linked_node_id))
        end
    end

    self:updateCanBeBoughtNodes()
    self.buying = false
    self.skill_points_to_buy = 0
    self.temporary_bought_node_indexes = {}
    
    bought_node_indexes = {1}
end

function SkillTree:update(dt)
    self.timer:update(dt)
    camera.smoother = Camera.smooth.damped(5)

    if input:down('left_click') then
        self.moving_with_kb = false
        local mx, my = camera:getMousePosition(sx, sy, 0, 0, sx*gw, sy*gh)
        local dx, dy = mx - self.previous_mx, my - self.previous_my
        camera:move(-dx/camera.scale, -dy/camera.scale)
        camera.x, camera.y = math.floor(camera.x), math.floor(camera.y)
    end
    self.previous_mx, self.previous_my = camera:getMousePosition(sx, sy, 0, 0, sx*gw, sy*gh)

    if input:pressed('zoom_in') then self.timer:tween('zoom', 0.2, camera, {scale = camera.scale + 0.4}, 'in-out-cubic') end
    if input:pressed('zoom_out') then self.timer:tween('zoom', 0.2, camera, {scale = camera.scale - 0.4}, 'in-out-cubic') end
    camera.scale = math.max(0.2, camera.scale) 

    -- Console
    local pmx, pmy = love.mouse.getPosition()
    local text = 'CONSOLE'
    local w = self.font:getWidth(text)
    local x, y = gw - w - 15, 5
    if (pmx >= sx*x and pmx <= sx*(x + w + 10) and pmy >= sy*y and pmy <= sy*(y + 16) and input:pressed('left_click')) then
        self:cancel()
    end

    -- Apply, cancel buttons
    self.bought_nodes_this_frame = false
    if self.buying then
        local pmx, pmy = love.mouse.getPosition()
        -- Apply
        local text = 'Apply ' .. self.skill_points_to_buy .. ' Skill Points'
        local w = self.font:getWidth(text)
        local x, y = 5, gh - 20
        if (pmx >= sx*x and pmx <= sx*(x + w + 10) and pmy >= sy*y and pmy <= sy*(y + 16) and input:pressed('left_click')) then
            if self.skill_points_to_buy <= skill_points and #bought_node_indexes <= max_tree_nodes then
                skill_points = skill_points - self.skill_points_to_buy
                spent_sp = spent_sp + self.skill_points_to_buy
                self.skill_points_to_buy = 0
                self.buying = false
                self.temporary_bought_node_indexes = {}
                self.bought_nodes_this_frame = true
            else
                if #bought_node_indexes > max_tree_nodes then
                    self.cant_buy_error = 'CANT HAVE MORE THAN ' .. max_tree_nodes .. ' NODES'
                    self.timer:after(0.5, function() self.cant_buy_error = false end)
                    self:cancel()
                    self:glitchError()
                else
                    self.cant_buy_error = 'NOT ENOUGH SKILL POINTS'
                    self.timer:after(0.5, function() self.cant_buy_error = false end)
                    self:cancel()
                    self:glitchError()
                end
            end
        end

        -- Cancel
        local x = x + w + 10 + 5
        local text = 'Cancel'
        local w = self.font:getWidth(text)
        if (pmx >= sx*x and pmx <= sx*(x + w + 10) and pmy >= sy*y and pmy <= sy*(y + 16) and input:pressed('left_click')) then 
            self:cancel()
        end
    end

    for _, node in ipairs(self.nodes) do node:update(dt) end
    for _, line in ipairs(self.lines) do line:update(dt) end
end

function SkillTree:draw()
    love.graphics.setCanvas(self.main_canvas)
    love.graphics.clear()
        love.graphics.setColor(background_color)
        love.graphics.rectangle('fill', 0, 0, gw, gh)
        camera:attach(0, 0, gw, gh)
        love.graphics.setLineWidth(1/camera.scale)
        for _, line in ipairs(self.lines) do line:draw() end
        for _, node in ipairs(self.nodes) do node:draw() end
        love.graphics.setLineWidth(1)
        camera:detach()

        -- Skill points
        love.graphics.setColor(skill_point_color)
        love.graphics.print(skill_points .. ' SP', gw - 30, 28, 0, 1, 1, math.floor(self.font:getWidth(skill_points .. 'SP')/2), math.floor(self.font:getHeight()/2))

        -- Nodes
        if #bought_node_indexes > max_tree_nodes then love.graphics.setColor(hp_color)
        else love.graphics.setColor(default_color) end
        love.graphics.print(#bought_node_indexes .. '/' .. max_tree_nodes .. ' NODES BOUGHT', 10, 20, 0, 1, 1, 0, math.floor(self.font:getHeight()/2))

        -- Can't buy
        if self.cant_buy_error then
            local text = self.cant_buy_error
            local w = self.font:getWidth(text)
            local x, y = gw/2 - w/2 - 5, gh/2 - 12
            love.graphics.setColor(hp_color)
            love.graphics.rectangle('fill', x, y, w + 10, 24)
            love.graphics.setColor(background_color)
            love.graphics.print(text, math.floor(x + 5), math.floor(y + 8))
        end

        -- Console button
        local pmx, pmy = love.mouse.getPosition()
        local text = 'CONSOLE'
        local w = self.font:getWidth(text)
        local x, y = gw - w - 15, 5
        love.graphics.setColor(0, 0, 0, 222)
        love.graphics.rectangle('fill', x, y, w + 10, 16) 
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.print(text, x + 5, y + 3)
        if pmx >= sx*x and pmx <= sx*(x + w + 10) and pmy >= sy*y and pmy <= sy*(y + 16) then love.graphics.rectangle('line', x, y, w + 10, 16) end

        -- Confirm/cancel buttons
        if self.buying then
            local pmx, pmy = love.mouse.getPosition()
            local text = 'Apply ' .. self.skill_points_to_buy .. ' Skill Points'
            local w = self.font:getWidth(text)

            local x, y = 5, gh - 20
            love.graphics.setColor(0, 0, 0, 222)
            love.graphics.rectangle('fill', x, y, w + 10, 16) 
            love.graphics.setColor(255, 255, 255, 255)
            love.graphics.print(text, x + 5, y + 3)
            if pmx >= sx*x and pmx <= sx*(x + w + 10) and pmy >= sy*y and pmy <= sy*(y + 16) then love.graphics.rectangle('line', x, y, w + 10, 16) end

            local x = x + w + 10 + 5
            local text = 'Cancel'
            local w = self.font:getWidth(text)
            love.graphics.setColor(0, 0, 0, 222)
            love.graphics.rectangle('fill', x, y, w + 10, 16) 
            love.graphics.setColor(255, 255, 255, 255)
            love.graphics.print(text, x + 5, y + 3)
            if pmx >= sx*x and pmx <= sx*(x + w + 10) and pmy >= sy*y and pmy <= sy*(y + 16) then love.graphics.rectangle('line', x, y, w + 10, 16) end

            love.graphics.line(x - 65, y + 13, x - 65 + 5, y + 13) -- K
            love.graphics.line(x + 5, y + 13, x + 5 + 5, y + 13) -- C
        end

        -- Stats rectangle
        local font = fonts.m5x7_16
        love.graphics.setFont(font)
        for _, node in ipairs(self.nodes) do
            if node.hot then
                local stats = self.tree[node.id].stats or {}
                -- Figure out max_text_width to be able to set the proper rectangle width
                local max_text_width = 0
                for i = 1, #stats, 3 do
                    if font:getWidth(stats[i]) > max_text_width then
                        max_text_width = font:getWidth(stats[i])
                    end
                end
                -- Draw rectangle
                local mx, my = love.mouse.getPosition() 
                mx, my = mx/sx, my/sy
                love.graphics.setColor(0, 0, 0, 0.87)
                love.graphics.rectangle('fill', mx, my, 16 + max_text_width, font:getHeight() + (#stats/3)*font:getHeight())
                -- Draw text
                love.graphics.setColor(default_color)
                for i = 1, #stats, 3 do
                    love.graphics.print(stats[i], math.floor(mx + 8), math.floor(my + font:getHeight()/2 + math.floor(i/3)*font:getHeight()))
                end
            end
        end
        love.graphics.setColor(default_color)
    love.graphics.setCanvas()

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setBlendMode('alpha', 'premultiplied')
    love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
    love.graphics.setBlendMode('alpha')
end

function SkillTree:destroy()
    
end

function SkillTree:canNodeBeBought(id)
    for _, linked_node_id in ipairs(self.tree[id]) do
        if fn.any(bought_node_indexes, linked_node_id) then return true end
    end
end

function SkillTree:updateCanBeBoughtNodes()
    for _, node in pairs(self.nodes) do node.can_be_bought = false end

    for _, bought_node_index in ipairs(bought_node_indexes) do
        for _, linked_node_id in ipairs(self.tree[bought_node_index].links) do
            self.nodes[linked_node_id].can_be_bought = true
        end
    end

    for _, node in pairs(self.nodes) do 
        if node.bought then node.can_be_bought = false end
    end
end

function SkillTree:cancel()
    self.skill_points_to_buy = 0
    self.buying = false
    bought_node_indexes = fn.difference(bought_node_indexes, self.temporary_bought_node_indexes)
    self.temporary_bought_node_indexes = {} 
    for _, node in pairs(self.nodes) do node:updateStatus() end
    self:updateCanBeBoughtNodes()
end

function SkillTree:getNumberOfBoughtNeighbors(id)
    local n = 0
    for _, linked_node_id in ipairs(self.tree[id].links) do
        if fn.any(bought_node_indexes, linked_node_id) then
            n = n + 1
        end
    end
    return n
end

function SkillTree:getBoughtNeighbors(id)
    local bought_neighbors = {}
    for _, linked_node_id in ipairs(self.tree[id].links) do
        if fn.any(bought_node_indexes, linked_node_id) then
            table.insert(bought_neighbors, linked_node_id)
        end
    end
    return bought_neighbors
end

function SkillTree:isBoughtNeighbor(id, neighbor_id)
    for _, linked_node_id in ipairs(self.tree[id].links) do
        if fn.any(bought_node_indexes, linked_node_id) and linked_node_id == neighbor_id then
            return true
        end
    end
end

function SkillTree:isNodeReachableWithout(id, without_id)
    local bought_nodes_without_id = fn.select(bought_node_indexes, function(_, value) return value ~= without_id end)
    local result = self:reachNodeFrom(1, id, {}, table.copy(bought_nodes_without_id))
    return result
end

function SkillTree:reachNodeFrom(start_id, target_id, explored_nodes, node_pool)
    local stack = {}
    table.insert(stack, 1, start_id)
    local current_node = nil
    repeat
        current_node = table.remove(stack, 1)
        if not fn.any(explored_nodes, current_node) then
            table.insert(explored_nodes, current_node)
            for _, linked_node_id in ipairs(self.tree[current_node].links) do
                if fn.any(node_pool, linked_node_id) then
                    table.insert(stack, 1, linked_node_id)
                end
            end
        end
    until current_node == target_id or #stack == 0 
    if current_node == target_id then return true end
end