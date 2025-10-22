StartModule = Object:extend()

function StartModule:new(console, y)
    self.console = console
    self.x, self.y = gw/2, y + 100
    self.w, self.h = 160, 80

    self.console:addLine(0.02, '')
    self.console:addLine(0.04, '')
    self.console:addLine(0.06, 'CHOOSE SHIP')
    self.console:addLine(0.08, '')
    self.console:addLine(0.12, '')
    self.console:addLine(0.14, '')
    self.console:addLine(0.16, '')
    self.console:addLine(0.18, '')
    self.console:addLine(0.20, '')
    self.console:addLine(0.22, '')
    self.console:addLine(0.24, '')
    self.console:addLine(0.26, '')
    self.console:addLine(0.28, '')
    self.console:addLine(0.30, '')
    self.console:addLine(0.32, '')
    self.console:addLine(0.34, '')
    self.console:addLine(0.36, '')
    self.console:addLine(0.38, '')
    self.console:addLine(0.40, '')
    self.console.timer:after(0.42, function() 
        self.active = true 
    end)

    self.sx, self.sy = 1, 1
    self.font = fonts.m5x7_16

    self.devices = {'Fighter', 'Crusader', 'Squaren', 'Bit Hunter', 'Swift', 'Striker', 'Tetron', 'Pavis', 'Verus', 'Interceptron', 'Velioch', 'Anthophila'}

    self.device_stats = {
        ['Fighter'] = {attack = 1, defense = 1, luck = 1, mobility = 1, uniqueness = 1},
        ['Crusader'] = {attack = 0.6, defense = 1.6, luck = 1, mobility = 0.2, uniqueness = 1},
        ['Squaren'] = {attack = 1.8, defense = 1, luck = 1, mobility = 1.4, uniqueness = 1.6},
        ['Bit Hunter'] = {attack = 0.8, defense = 0.6, luck = 2, mobility = 0.6, uniqueness = 1},
        ['Swift'] = {attack = 1, defense = 0.4, luck = 1.4, mobility = 1.4, uniqueness = 1.2},
        ['Striker'] = {attack = 1.8, defense = 1, luck = 1, mobility = 1, uniqueness = 1.6},
        ['Tetron'] = {attack = 1.2, defense = 1.6, luck = 1, mobility = 0.4, uniqueness = 1.6},
        ['Pavis'] = {attack = 1.4, defense = 0.6, luck = 1, mobility = 1, uniqueness = 1.6},
        ['Verus'] = {attack = 1.6, defense = 1, luck = 1, mobility = 0.8, uniqueness = 2},
        ['Interceptron'] = {attack = 1.4, defense = 0.8, luck = 1, mobility = 1, uniqueness = 1.8},
        ['Velioch'] = {attack = 1.4, defense = 0.4, luck = 1, mobility = 0.6, uniqueness = 1.2},
        ['Anthophila'] = {attack = 1.4, defense = 0.8, luck = 1, mobility = 0.8, uniqueness = 1},
    }

    self.device_y_offsets = {
        ['Fighter'] = 0,
        ['Crusader'] = 0,
        ['Squaren'] = 2,
        ['Bit Hunter'] = 0,
        ['Swift'] = 4,
        ['Striker'] = 0,
        ['Tetron'] = 0,
        ['Pavis'] = 2,
        ['Verus'] = 0,
        ['Interceptron'] = 0,
        ['Velioch'] = 0,
        ['Anthophila'] = 0,
    }

    self.device_descriptions = {
        ['Fighter'] = {
            'DEVICE: FIGHTER',
            '',
            '       Average All Stats'
        },

        ['Crusader'] = {
            'DEVICE: CRUSADER',
            '',
            '   ++  HP',
            '   --- Mobility',
            '   --- Attack Speed',
        },

        ['Squaren'] = {
            'DEVICE: SQUAREN',
            '',
            '   +++ Attack Speed',
            '   ++  Mobility',
            '   --  Boost',
            '   -   Ammo',
        },

        ['Bit Hunter'] = {
            'DEVICE: BIT HUNTER',
            '',
            '   +++ Luck',
            '   ++  Cycle Speed',
            '   ++  Invulnerability Time',
            '   -   All Other Stats',
        },

        ['Swift'] = {
            'DEVICE: SWIFT',
            '',
            '   ++  Mobility',
            '   +   Luck',
            '   -   Ammo',
            '   -   Boost',
        },

        ['Striker'] = {
            'DEVICE: STRIKER',
            '',
            '   +++ Attack Speed',
            '   +++ Barrage',
            '   --- HP',
        },

        ['Tetron'] = {
            'DEVICE: TETRON',
            '',
            '   +++ HP',
            '   +   Converts HP to SP When Full',
            '   --- Mobility',
        },

        ['Pavis'] = {
            'DEVICE: PAVIS',
            '',
            '   ++  Attack',
            '   +   Slow-Fast Projectile',
            '   --  Ammo, HP % Boost Recharge',
        },

        ['Verus'] = {
            'DEVICE: VERUS',
            '',
            '   ++  Lightning Bolt & Angle',
            '   +   Barage Nova',
            '       Energy Shield:',
            '          Takes Double Damage',
            '          HP Recharges and Half Invulnerability Time',
        },

        ['Interceptron'] = {
            'DEVICE: INTERCEPTRON',
            '',
            '   +   Has A Chance To Gain Double SP',
            '   +   Random Projectile Degree Change',
            '   -   HP',
        },

        ['Velioch'] = {
            'DEVICE: VELIOCH',
            '',
            '   +   Launches 3 Homing Projectiles',
            '   +   Chance To Launch Homing On Projectile Kill',
            '   --  HP & Boost',
            '   -   Ammo',
        },

        ['Anthophila'] = {
            'DEVICE: ANTHOPHILA',
            '',
            '   +   Spawn Haste Area % HP Regain On Cycle',
            '   +   Barrage On Kill Projectiles',
            '   -   Boost Recharge',
            '   -   HP',
        },
    }

    self.device_vertices = {
        ['Fighter'] = {
            ['vertice_groups'] = {
                [1] = {
                    12, 0,
                    12/2, -12/2,
                    -12/2, -12/2,
                    -12, 0,
                    -12/2, 12/2,
                    12/2, 12/2,
                },

                [2] = {
                    12/2, -12/2,
                    0, -12,
                    -12 - 12/2, -12,
                    -3*12/4, -12/4,
                    -12/2, -12/2,
                },
                
                [3] = {
                    12/2, 12/2,
                    -12/2, 12/2,
                    -3*12/4, 12/4,
                    -12 - 12/2, 12,
                    0, 12,
                }
            }
        },

        ['Crusader'] = {
            ['vertice_groups'] = {
                [1] = {
                    12, 0,
                    12/2, 12/2,
                    -12/4, 12/2,
                    -12/2, 12/4,
                    -12/2, -12/4,
                    -12/4, -12/2,
                    12/2, -12/2,
                },

                [2] = {
                    12/2, 12/2,
                    12/2, 12,
                    -12/2, 12,
                    -12, 12/2,
                    -12, 0,
                    -12/2, 0,
                    -12/2, 12/4,
                    -12/4, 12/2,
                },

                [3] = {
                    12/2, -12/2,
                    12/2, -12,
                    -12/2, -12,
                    -12, -12/2,
                    -12, 0,
                    -12/2, 0,
                    -12/2, -12/4,
                    -12/4, -12/2,
                }
            }
        },

        ['Squaren'] = {
            ['vertice_groups'] = {
                [1] = {
                    12/4, 0,
                    12/2, -12/2,
                    -12, -12/2,
                    -12/2, 0,
                    -12, 12/2,
                    12/2, 12/2,
                },

                [2] = {
                    12/2, -12/2,
                    0, -12,
                    -12, -12,
                    -12/2, -12/2,
                },

                [3] = {
                    12/2, 12/2,
                    -12/2, 12/2,
                    -12, 12,
                    0, 12,
                }
            }
        },

        ['Bit Hunter'] = {
            ['vertice_groups'] = {
                [1] = {
                    12, 0,
                    12/2, -12/2,
                    -12, -12/2,
                    -12/2, 0,
                    -12, 12/2,
                    12/2, 12/2,
                }
            }
        },

        ['Swift'] = {
            ['vertice_groups'] = {
                [1] = {
                    12, 0,
                    12/4, -12/3,
                    0, -12/2,
                    -12/2, -12/3,
                    -12/4, 0,
                    -12/2, 12/3,
                    0, 12/2,
                    12/4, 12/3,
                }
            }
        },

        ['Striker'] = {
            ['vertice_groups'] = {
                [1] = {
                    12, 0,
                    12/2, -12/2,
                    -12/2, -12/2,
                    -12, 0,
                    -12/2, 12/2,
                    12/2, 12/2,
                },

                [2] = {
                    0, 12/2,
                    -12/4, 12,
                    0, 12 + 12/2,
                    12, 12,
                    0, 2*12,
                    -12/2, 12 + 12/2,
                    -12, 0,
                    -12/2, 12/2,
                },

                [3] = {
                    0, -12/2,
                    -12/4, -12,
                    0, -12 - 12/2,
                    12, -12,
                    0, -2*12,
                    -12/2, -12 - 12/2,
                    -12, 0,
                    -12/2, -12/2,
                }
            }
        },

        ['Tetron'] = {
            ['vertice_groups'] = {
                [1] = {
                    12, 12/2,
                    12/2, 12/2,
                    12/4, 12/4,
                    -12/4, 12/4,
                    -12/2, 12/2,
                    -12, 12/2,
                    -12, -12/2,
                    -12/2, -12/2,
                    -12/4, -12/4,
                    12/4, -12/4,
                    12/2, -12/2,
                    12, -12/2,
                }
            }
        },

        ['Pavis'] = {
            ['vertice_groups'] = {
                [1] = {
                    0, 12,
                    12/4, 12/4,
                    12/6, -12/2,
                    0, -12,
                    -12/6, -12/2,
                    -12/4, 12/4,
                },

                [2] = {
                    -12/4, 12/4,
                    -12*0.9, 0,
                    -12/4, -12/4,
                },

                [3] = {
                    12/4, 12/4,
                    12*0.9, 0,
                    12/4, -12/4,
                }
            }
        },

        ['Verus'] = {
            ['vertice_groups'] = {
                [1] = {
                    12, 0,
                    12/2, -12/2,
                    -12/2, -12/2,
                    -12, 0,
                    -12/2, 12/2,
                    12/2, 12/2
                },

                [2] = {
                    12, 12/2,
                    12/2, 12 * 1.2,
                    -12/2, 12 * 1.2,
                    -12, 12/2,
                },

                [3] = {
                    12, -12/2,
                    12/2, -12 * 1.2,
                    -12/2, -12 * 1.2,
                    -12, -12/2,
                }
            }
        },

        ['Interceptron'] = {
            ['vertice_groups'] = {
                [1] = {
                    -12, 12/4,
                    0, 12/2,
                    12, 0,
                    0, -12/2,
                    -12, -12/4,
                },

                [2] = {
                    12/2, -12/2,
                    0, -12,
                    -12, -12,
                    -12/2, -12/2,
                },

                [3] = {
                    12/2, 12/2,
                    -12/2, 12/2,
                    -12, 12,
                    0, 12,
                }
            }
        },

        ['Velioch'] = {
            ['vertice_groups'] = {
                [1] = {
                    12*0.75, 12/3,
                    12*0.75, -12/3,
                    -12*0.75, -12/3,
                    -12*0.75, 12/3,
                },

                [2] = {
                    12/2, -12/2,
                    0, -12,
                    -12, -12,
                    -12/2, -12/2,
                },

                [3] = {
                    12/2, 12/2,
                    -12/2, 12/2,
                    -12, 12,
                    0, 12,
                }
            }
        },

        ['Anthophila'] = {
            ['vertice_groups'] = {
                [1] = {
                    12*1.2, 0,
                    12/2, 12/3,
                    -12/4, 12/2,
                    -12, 0,
                    -12/4, -12/2,
                    12/2, -12/3,
                },

                [2] = {
                    -12/4, 12/2,
                    -12*1.1, 12*0.6,
                    -12, 12/4,
                },

                [3] = {
                    -12/4, -12/2,
                    -12*1.1, -12*0.6,
                    -12, -12/4,
                }
            }
        },
    }

    self.device_index = 1
end

function StartModule:update(dt)
    if not self.active then return end 

    if input:pressed('left') then
        Switch:play()
        self.device_index = self.device_index - 1
        if self.device_index == 0 then self.device_index = #self.devices end
        local current_device = self.devices[self.device_index]
        device = current_device
    end

    if input:pressed('right') then
        Switch:play()
        self.device_index = self.device_index + 1
        if self.device_index == #self.devices+1 then self.device_index = 1 end
        local current_device = self.devices[self.device_index]
        device = current_device
    end

    if input:pressed('return') then
        Enter:play()
        Menu:stop()
        local current_device = self.devices[self.device_index]
        device = current_device
        Player.ship = device
        gotoRoom('Stage')
    end

    if input:pressed('escape') then
        Exit:play()
        self.active = false
        self.console:addLine(0.02, '')
        self.console:addInputLine(0.04)
    end
end

function StartModule:draw()
    love.graphics.setColor(default_color)
    pushRotateScale(self.x, self.y, 0, self.sx, self.sy)
    local w, h = self.w, self.h 
    local x, y = self.x, self.y

    love.graphics.setFont(self.font)
    -- love.graphics.print('CHOOSE device', x, y - h/1.5, 0, 1.01, 1.01, self.font:getWidth('CHOOSE device')/2, self.font:getHeight()/2)

    love.graphics.line(self.x - self.w/2 - 80, self.y, self.x - self.w/2 - 60, self.y - self.h/4)
    love.graphics.line(self.x - self.w/2 - 80, self.y, self.x - self.w/2 - 60, self.y + self.h/4)
    love.graphics.line(self.x + self.w/2 + 80, self.y, self.x + self.w/2 + 60, self.y - self.h/4)
    love.graphics.line(self.x + self.w/2 + 80, self.y, self.x + self.w/2 + 60, self.y + self.h/4)
    BSGRectangle('line', self.x - self.w/2 - 50, self.y - self.h/2, 120, self.h, 8, 8)
    BSGRectangle('line', self.x + self.w/2 - 70, self.y - self.h/2, 120, self.h, 8, 8)

    -- Left
    local device = self.devices[self.device_index]
    love.graphics.setLineWidth(1)
    love.graphics.print(device, self.x - self.w/2 + 10, self.y - 27, 0, 1.01, 1.01, self.font:getWidth(device)/2, self.font:getHeight()/2)
    pushRotate(self.x - self.w/2 + 10, self.y - 2 + self.device_y_offsets[device], -math.pi/2)
    for _, vertice_group in ipairs(self.device_vertices[self.devices[self.device_index]].vertice_groups) do
        local points = fn.map(vertice_group, function(k, v) 
            if k % 2 == 1 then return self.x - self.w/2 + 10 + v + random(-1, 1) else return self.y - 2 + self.device_y_offsets[device] + v + random(-1, 1) end 
        end)
        love.graphics.polygon('line', points)
    end
    love.graphics.pop()

    -- Right
    local x, y = self.x + self.w/2 - 10, self.y + 5
    local drawPentagon = function(radius)
        local points = {}
        for i = 1, 5 do
            table.insert(points, x + radius*math.cos(-math.pi/2 + i*(2*math.pi/5)))
            table.insert(points, y + radius*math.sin(-math.pi/2 + i*(2*math.pi/5)))
        end
        love.graphics.polygon('line', points)
    end

    local r, g, b = unpack(default_color)
    love.graphics.setColor(r, g, b, 32)
    drawPentagon(32)
    drawPentagon(16)
    love.graphics.setColor(r, g, b, 255)
    love.graphics.print('TECH', x, y - 38, 0, 1, 1, self.font:getWidth('TECH')/2, self.font:getHeight()/2)
    love.graphics.print('ATK', x - 41, y - 12, 0, 1, 1, self.font:getWidth('ATK')/2, self.font:getHeight()/2)
    love.graphics.print('DEF', x + 41, y - 12, 0, 1, 1, self.font:getWidth('DEF')/2, self.font:getHeight()/2)
    love.graphics.print('SPD', x + 32, y + 26, 0, 1, 1, self.font:getWidth('SPD')/2, self.font:getHeight()/2)
    love.graphics.print('LCK', x - 32, y + 26, 0, 1, 1, self.font:getWidth('LCK')/2, self.font:getHeight()/2)

    local stats = {'uniqueness', 'defense', 'mobility', 'luck', 'attack'}
    local points = {}
    for i = 1, 5 do
        local d = self.device_stats[device][stats[i]]
        table.insert(points, x + d*16*math.cos(-math.pi/2 + (i-1)*(2*math.pi/5)) + random(-1, 1))
        table.insert(points, y + d*16*math.sin(-math.pi/2 + (i-1)*(2*math.pi/5)) + random(-1, 1))
    end
    love.graphics.setColor(r, g, b, 64)
    local triangles = love.math.triangulate(points)
    for _, triangle in ipairs(triangles) do love.graphics.polygon('fill', triangle) end
    love.graphics.setColor(r, g, b, 255)
    love.graphics.polygon('line', points)

    -- Text
    local x, y = self.x - self.w/2 - 80, self.y + self.h - 24
    for i, line in ipairs(self.device_descriptions[device]) do
        love.graphics.print(line, x, y + 12*(i-1), 0, 1, 1, 0, self.font:getHeight()/2)
    end
    love.graphics.pop()
end
