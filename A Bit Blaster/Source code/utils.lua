-- Generates unique identifiers, random numbers, to identify which object is which.
function UUID()
    local fn = function(x)
        local r = math.random(16) - 1
        r = (x == "x") and (r + 1) or (r % 4) + 9
        return ("0123456789abcdef"):sub(r, r)
    end
    return (("xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"):gsub("[xy]", fn))
end

function random(min, max)
    local min, max = min or 0, max or 1
    return (min > max and (love.math.random()*(min - max) + max)) or (love.math.random()*(max - min) + min)
end

function sign(n)
    if n > 0 then return 1
    elseif n < 0 then return -1
    else return 0 end
end

function table.find(t, v)
    for i, value in ipairs(t) do
        if value == v  then return i end
    end
end

-- Picks a random element from a table.
function table.random(t)
    return t[love.math.random(1, #t)]
end

--  joins two tables together with all their values into a new one and then returns it.
function table.merge(t1, t2)
    local new_table = {}
    for k, v in pairs(t2) do new_table[k] = v end
    for k, v in pairs(t1) do new_table[k] = v end
    return new_table
end

function table.copy(t)
    local copy 
    if type(t) == 'table' then
        copy = {}
        for k, v in next, t, nil do copy[table.copy(k)] = table.copy(v) end
        setmetatable(copy, table.copy(getmetatable(t)))
    else copy = t end
    return copy
end

-- rotates the graphics context around a point (x, y) by angle r.
function pushRotate(x, y, r)
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(r or 0)
    love.graphics.translate(-x, -y)
end

function pushRotateScale(x, y, r, sx, sy)
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(r or 0)
    love.graphics.scale(sx or 1, sy or sx or 1)
    love.graphics.translate(-x, -y)
end

function areRectanglesOverlapping(x1, y1, x2, y2, x3, y3, x4, y4)
    return not (x3 > x2 or x4 < x1 or y3 > y2 or y4 < y1)
end

function getPointsAlongLine(n, x1, y1, x2, y2)
    local points = {}
    local angle = Vector1.angle(x2 - x1, y2 - y1)
    local step = distance(x1, y1, x2, y2)/n
    for i = 1, n do table.insert(points, {x = x1 + (i-1)*(step)*math.cos(angle), y = y1 + (i-1)*(step)*math.sin(angle)}) end
    return points
end

function createIrregularPolygon(size, point_amount)
    local point_amount = point_amount or 8
    local points = {}
    for i = 1, point_amount do
        local angle_interval = 2*math.pi / point_amount
        local distance = size + random(-size / 4, size / 4)
        local angle = (i-1)*angle_interval + random(-angle_interval / 4, angle_interval / 4)
        table.insert(points, distance*math.cos(angle))
        table.insert(points, distance*math.sin(angle))
    end
    return points
end

function chanceList(...)
    return {
        chance_list = {},
        chance_definitions = {...},
        next = function(self)
            if #self.chance_list == 0 then
                for _, chance_definition in ipairs(self.chance_definitions) do
                    for i = 1, chance_definition[2] do table.insert(self.chance_list, chance_definition[1]) end
                end
            end
            return table.remove(self.chance_list, love.math.random(1, #self.chance_list))
        end
    }
end

function distance(x1, y1, x2, y2)
    return math.sqrt((x1 - x2)*(x1 - x2) + (y1 - y2)*(y1 - y2))
end

function BSGRectangle(mode, x, y, w, h, s)
    love.graphics.polygon(mode, x + s, y, x + w - s, y, x + w, y + s, x + w, y + h - s, x + w - s, y + h, x + s, y + h, x, y + h - s, x, y + s)
end