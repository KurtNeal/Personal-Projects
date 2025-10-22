Director = Object:extend()

function Director:new(stage)
    self.stage = stage
    self.timer = Timer()

    self.difficulty = 1
    self.round_duration = 22
    self.round_timer = 0
    self.resource_duration = 16
    self.resource_timer = 0
    self.attack_duration = 25
    self.attack_timer = 0

    -- Difficulty meter
    self.difficulty_to_points = {}
    self.difficulty_to_points[1] = 16
    self.difficulty_to_points[2] = 24
    self.difficulty_to_points[3] = 24
    self.difficulty_to_points[4] = 16
    self.difficulty_to_points[5] = 32
    self.difficulty_to_points[6] = 40
    self.difficulty_to_points[7] = 40 
    self.difficulty_to_points[8] = 26
    self.difficulty_to_points[9] = 52
    self.difficulty_to_points[10] = 60
    self.difficulty_to_points[11] = 60 
    self.difficulty_to_points[12] = 52
    self.difficulty_to_points[13] = 78
    self.difficulty_to_points[14] = 70
    self.difficulty_to_points[15] = 70 
    self.difficulty_to_points[16] = 62 
    self.difficulty_to_points[17] = 98
    self.difficulty_to_points[18] = 98 
    self.difficulty_to_points[19] = 90 
    self.difficulty_to_points[20] = 108
    self.difficulty_to_points[21] = 128
    self.difficulty_to_points[22] = 72 
    self.difficulty_to_points[23] = 80
    self.difficulty_to_points[24] = 140 
    self.difficulty_to_points[25] = 92
    self.difficulty_to_points[26] = 128
    self.difficulty_to_points[27] = 86
    self.difficulty_to_points[28] = 94 
    self.difficulty_to_points[29] = 142
    self.difficulty_to_points[30] = 88
    self.difficulty_to_points[31] = 96
    self.difficulty_to_points[32] = 104 
    self.difficulty_to_points[33] = 112 
    self.difficulty_to_points[34] = 142
    self.difficulty_to_points[35] = 158
    self.difficulty_to_points[36] = 178
    self.difficulty_to_points[37] = 128
    self.difficulty_to_points[38] = 96
    self.difficulty_to_points[39] = 160
    for i = 40, 2048 do self.difficulty_to_points[i] = 160 + 2*i end

    self.enemy_to_points = {
        ['Rock'] = 1,
        ['Shooter'] = 2,
        ['BigRock'] = 2,
        ['Waver'] = 4,
        ['Roller'] = 6,
        ['Rotator'] = 6,
        ['Tanker'] = 6,
        ['Seeker'] = 6,
        ['Orbitter'] = 12

    }

    self.enemy_spawn_chances = {
        [1] = chanceList({'Rock', 1}),
        [2] = chanceList({'Rock', 8}, {'Shooter', 4}),
        [3] = chanceList({'Rock', 7}, {'BigRock', 3}, {'Shooter', 3}),
        [4] = chanceList({'Rock', 6}, {'BigRock', 3}, {'Shooter', 3}, {'Seeker', 3}),
        [5] = chanceList({'Rock', 5}, {'BigRock', 3}, {'Shooter', 3}, {'Waver', 4}),
        [6] = chanceList({'Rock', 4}, {'BigRock', 4}, {'Seeker', 1}, {'Waver', 1}),
        [7] = chanceList({'Rock', 4}, {'BigRock', 3}, {'Shooter', 3}, {'Seeker', 2}, {'Waver', 2}, {'Roller', 2}),
        [8] = chanceList({'Rock', 4}, {'BigRock', 3}, {'Shooter', 3}, {'Seeker', 2}, {'Waver', 2}),
        [9] = chanceList({'Rock', 4}, {'BigRock', 4}, {'Shooter', 2}, {'Sapper', 2}),
        [10] = chanceList({'Rock', 4}, {'BigRock', 4}, {'Shooter', 4}, {'Rotator', 2}),
        [11] = chanceList({'Rock', 6}, {'BigRock', 6}, {'Tanker', 2}),
        [12] = chanceList({'Rock', 4}, {'BigRock', 4}, {'Shooter', 4}, {'Seeker', 4}, {'Waver', 4}),
    }

    -- Random probabilities past stage 5
    for i = 13, 1024 do
        self.enemy_spawn_chances[i] = chanceList(
            {'Rock', love.math.random(2, 12)},
            {'Shooter', love.math.random(2, 12)},
            {'BigRock', love.math.random(2, 12)},
            {'Waver', love.math.random(2, 12)},
            {'Roller', love.math.random(2, 12)},
            {'Rotator', love.math.random(2, 12)},
            {'Seeker', love.math.random(2, 12)},
            {'Tanker', love.math.random(2, 12)},
            {'Orbitter', love.math.random(2, 12)}
        )
    end

    if self.stage.player.only_spawn_boost then
        self.resource_spawn_chances = chanceList(
            {'Boost', 100}
        )
    elseif self.stage.player.only_spawn_attack then
        self.attack_spawn_chances = chanceList(
            {'Attack', attack = 'Double', 6},
            {'Attack', attack = 'Triple', 6},
            {'Attack', attack = 'Rapid', 6},
            {'Attack', attack = 'Spread', 6},
            {'Attack', attack = 'Back', 6},
            {'Attack', attack = 'Side', 6},
            {'Attack', attack = 'Homing', 6},
            {'Attack', attack = 'Blast', 6},
            {'Attack', attack = 'Spin', 6},
            {'Attack', attack = 'Flame', 6},
            {'Attack', attack = 'Bounce', 6},
            {'Attack', attack = '2Split', 6},
            {'Attack', attack = '4Split', 6},
            {'Attack', attack = 'Lightning', 6}, 
            {'Attack', attack = 'Explode', 6}
        )
    else
        self.resource_spawn_chances = chanceList(
            {'Boost', 28*self.stage.player.boost_spawn_chance_multiplier}, 
            {'HP', 14*self.stage.player.hp_spawn_chance_multiplier}, 
            {'SkillPoint', 58*self.stage.player.sp_spawn_chance_multiplier}
        )

        self.attack_spawn_chances = chanceList(
            {'Attack', attack = 'Double', 6},
            {'Attack', attack = 'Triple', 6},
            {'Attack', attack = 'Rapid', 6},
            {'Attack', attack = 'Spread', 6},
            {'Attack', attack = 'Back', 6},
            {'Attack', attack = 'Side', 6},
            {'Attack', attack = 'Homing', 6},
            {'Attack', attack = 'Blast', 6},
            {'Attack', attack = 'Spin', 6},
            {'Attack', attack = 'Flame', 6},
            {'Attack', attack = 'Bounce', 6},
            {'Attack', attack = '2Split', 6},
            {'Attack', attack = '4Split', 6},
            {'Attack', attack = 'Lightning', 6}, 
            {'Attack', attack = 'Explode', 6}
        )
    end


    self:setEnemySpawnsForThisRound()
end

function Director:update(dt)
    self.timer:update(dt)

    -- Difficulty
    self.round_timer = self.round_timer + dt
    if self.round_timer > self.round_duration/self.stage.player.enemy_spawn_rate_multiplier then
        self.round_timer = 0
        self.difficulty = self.difficulty + 1
        self:setEnemySpawnsForThisRound()
    end

    self.resource_timer = self.resource_timer + dt
    if self.resource_timer > self.resource_duration/self.stage.player.resource_spawn_rate_multiplier then
        self.resource_timer = 0
        if self.stage.player.only_spawn_attack then 
            return 
        else
            self.stage.area:addGameObject(self.resource_spawn_chances:next())
        end
    end

    self.attack_timer = self.attack_timer + dt
    if self.attack_timer > self.attack_duration/self.stage.player.attack_spawn_rate_multiplier then
        self.attack_timer = 0
        if self.stage.player.only_spawn_boost then 
            return 
        else
            self.stage.area:addGameObject(self.attack_spawn_chances:next())
        end
    end
end

function Director:setEnemySpawnsForThisRound()
    local points = self.difficulty_to_points[self.difficulty]

    -- Find enemies
    local runs = 0
    local enemy_list = {}
    while points > 0 and runs < 1000 do
        local enemy = self.enemy_spawn_chances[self.difficulty]:next()
        points = points - self.enemy_to_points[enemy]
        table.insert(enemy_list, enemy)
        runs = runs + 1
    end

    -- Find enemies spawn times
    local enemy_spawn_times = {}
    for i = 1, #enemy_list do enemy_spawn_times[i] = random(0, self.round_duration) end
    table.sort(enemy_spawn_times, function(a, b) return a < b end)

    -- Set spawn enemy timer
    for i = 1, #enemy_spawn_times do
        self.timer:after(enemy_spawn_times[i], function()
            self.stage.area:addGameObject(enemy_list[i])
        end)
    end
end
