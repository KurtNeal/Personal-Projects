Player = GameObject:extend()

function Player:new(area, x, y, opts)
    Player.super.new(self, area, x, y, opts)
    self.paused = false

    self.x, self.y = x, y
    self.w, self.h = 12, 12
    self.collider = self.area.world:newCircleCollider(self.x, self.y, self.w)
    self.collider:setObject(self)
    self.collider:setCollisionClass('Player')

    self.r = -math.pi/2
    self.rv = 1.66*math.pi
    self.v = 0
    self.base_max_v = 100
    self.max_v = self.base_max_v
    self.a = 100

    -- Cycle
    self.cycle_timer = 0
    self.cycle_cooldown = 5

    -- Boost
    self.max_boost = 100
    self.boost = self.max_boost
    self.boosting = false
    self.can_boost = true
    self.boost_timer = 0
    self.boost_cooldown = 2

    -- HP
    self.max_hp = 100
    self.hp = self.max_hp

    -- ES
    self.energy_shield_recharge_cooldown = 2
    self.energy_shield_recharge_amount = 1

    -- Ammo
    self.max_ammo = 100
    self.ammo = self.max_ammo
    self:setAttack(opts.attack or 'Neutral')

    -- Attack
    self.shoot_timer = 0
    self.shoot_cooldown = 0.24

    input:bind('f4', function() self:die() end)

    -- Ship visuals
    self.ship = opts.device
    self.polygons = {}

    if self.ship == 'Fighter' then
        self.polygons[1] = {
            self.w, 0,
            self.w/2, -self.w/2,
            -self.w/2, -self.w/2,
            -self.w, 0,
            -self.w/2, self.w/2,
            self.w/2, self.w/2
        }
        self.polygons[2] = {
            self.w/2, -self.w/2,
            0, -self.w,
            -self.w - self.w/2, -self.w,
            -3*self.w/4, -self.w/4,
            -self.w/2, -self.w/2,
        }
        self.polygons[3] = {
            self.w/2, self.w/2,
            -self.w/2, self.w/2,
            -3*self.w/4, self.w/4,
            -self.w - self.w/2, self.w,
            0, self.w,
        }
    elseif self.ship == 'Striker' then
        self.polygons[1] = {
            self.w, 0,
            self.w/2, -self.w/2,
            -self.w/2, -self.w/2,
            -self.w, 0,
            -self.w/2, self.w/2,
            self.w/2, self.w/2,
        }
        self.polygons[2] = {
            0, self.w/2,
            -self.w/4, self.w,
            0, self.w + self.w/2,
            self.w, self.w,
            0, 2*self.w,
            -self.w/2, self.w + self.w/2,
            -self.w, 0,
            -self.w/2, self.w/2,
        }
        self.polygons[3] = {
            0, -self.w/2,
            -self.w/4, -self.w,
            0, -self.w - self.w/2,
            self.w, -self.w,
            0, -2*self.w,
            -self.w/2, -self.w - self.w/2,
            -self.w, 0,
            -self.w/2, -self.w/2,
        }
    elseif self.ship == 'Squaren' then
        self.polygons[1] = {
            self.w/4, 0,
            self.w/2, -self.w/2,
            -self.w, -self.w/2,
            -self.w/2, 0,
            -self.w, self.w/2,
            self.w/2, self.w/2,
        }
        self.polygons[2] = {
            self.w/2, -self.w/2,
            0, -self.w,
            -self.w, -self.w,
            -self.w/2, -self.w/2,
        }
        self.polygons[3] = {
            self.w/2, self.w/2,
            -self.w/2, self.w/2,
           -self.w, self.w,
            0, self.w,
        }
    elseif self.ship == 'Swift' then
        self.polygons[1] = {
            self.w, 0,
            self.w/4, -self.w/3,
            0, -self.w/2,
            -self.w/2, -self.w/3,
            -self.w/4, 0,
            -self.w/2, self.w/3,
            0, self.w/2,
            self.w/4, self.w/3,
        }
    elseif self.ship == 'Tetron' then
        self.polygons[1] = {
            self.w, self.w/2,
            self.w/2, self.w/2,
            self.w/4, self.w/4,
            -self.w/4, self.w/4,
            -self.w/2, self.w/2,
            -self.w, self.w/2,
            -self.w, -self.w/2,
            -self.w/2, -self.w/2,
            -self.w/4, -self.w/4,
            self.w/4, -self.w/4,
            self.w/2, -self.w/2,
            self.w, -self.w/2,
        }
    elseif self.ship == 'Pavis' then
        self.polygons[1] = {
            0, self.w,
            self.w/4, self.w/4,
            self.w/6, -self.w/2,
            0, -self.w,
            -self.w/6, -self.w/2,
            -self.w/4, self.w/4,
        }
        self.polygons[2] = {
            -self.w/4, self.w/4,
            -self.w * 0.9, 0,
            -self.w/4, -self.w/4,
        }
        self.polygons[3] = {
            self.w/4, self.w/4,
            self.w * 0.9, 0,
            self.w/4, -self.w/4,
        }
    elseif self.ship == 'Verus' then
        self.polygons[1] = {
            self.w, 0,
            self.w/2, -self.w/2,
            -self.w/2, -self.w/2,
            -self.w, 0,
            -self.w/2, self.w/2,
            self.w/2, self.w/2
        }
        self.polygons[2] = {
            self.w, self.w/2,
            self.w/2, self.w * 1.2,
            -self.w/2, self.w * 1.2,
            -self.w, self.w/2,
        }
        self.polygons[3] = {
            self.w, -self.w/2,
            self.w/2, -self.w * 1.2,
            -self.w/2, -self.w * 1.2,
            -self.w, -self.w/2,
        }
    elseif self.ship == 'Interceptron' then
        self.polygons[1] = {
            -self.w, self.w/4,
            0, self.w/2,
            self.w, 0,
            0, -self.w/2,
            -self.w, -self.w/4,
        }
        self.polygons[2] = {
            self.w/2, -self.w/2,
            0, -self.w,
            -self.w, -self.w,
            -self.w/2, -self.w/2,
        }
        self.polygons[3] = {
            self.w/2, self.w/2,
            -self.w/2, self.w/2,
           -self.w, self.w,
            0, self.w,
        }
    elseif self.ship == 'Velioch' then
        self.polygons[1] = {
            self.w * 0.75, self.w / 3,
            self.w * 0.75, -self.w / 3,
            -self.w * 0.75, -self.w / 3,
            -self.w * 0.75, self.w / 3,
        }
        self.polygons[2] = {
            self.w/2, -self.w/2,
            0, -self.w,
            -self.w, -self.w,
            -self.w/2, -self.w/2,
        }
        self.polygons[3] = {
            self.w/2, self.w/2,
            -self.w/2, self.w/2,
           -self.w, self.w,
            0, self.w,
        }
    elseif self.ship == 'Bit Hunter' then
        self.polygons[1] = {
            self.w, 0,
            self.w/2, -self.w/2,
            -self.w, -self.w/2,
            -self.w/2, 0,
            -self.w, self.w/2,
            self.w/2, self.w/2,
        }
    elseif self.ship == 'Anthophila' then
        self.polygons[1] = {
            self.w * 1.2, 0,
            self.w/2, self.w/3,
            -self.w/4, self.w/2,
            -self.w, 0,
            -self.w/4, -self.w/2,
            self.w/2, -self.w/3,
        }
        self.polygons[2] = {
            -self.w/4, self.w/2,
            -self.w * 1.1, self.w * 0.6,
            -self.w, self.w/4,
        }
        self.polygons[3] = {
            -self.w/4, -self.w/2,
            -self.w * 1.1, -self.w * 0.6,
            -self.w, -self.w/4,
        }
    elseif self.ship == 'Crusader' then
        self.polygons[1] = {
            self.w, 0,
            self.w/2, self.w/2,
            -self.w/4, self.w/2,
            -self.w/2, self.w/4,
            -self.w/2, -self.w/4,
            -self.w/4, -self.w/2,
            self.w/2, -self.w/2,
        }
        self.polygons[2] = {
            self.w/2, self.w/2,
            self.w/2, self.w,
            -self.w/2, self.w,
            -self.w, self.w/2,
            -self.w, 0,
            -self.w/2, 0,
            -self.w/2, self.w/4,
            -self.w/4, self.w/2,
        }
        self.polygons[3] = {
            self.w/2, -self.w/2,
            self.w/2, -self.w,
            -self.w/2, -self.w,
            -self.w, -self.w/2,
            -self.w, 0,
            -self.w/2, 0,
            -self.w/2, -self.w/4,
            -self.w/4, -self.w/2,
        }

    end

    -- Boost trail
    self.trail_color = skill_point_color 
    self.timer:every(0.01, function()
        if self.ship == 'Fighter' then
            self.area:addGameObject('TrailParticle', 
            self.x - 0.9*self.w*math.cos(self.r) + 0.2*self.w*math.cos(self.r - math.pi/2),
            self.y - 0.9*self.w*math.sin(self.r) + 0.2*self.w*math.sin(self.r - math.pi/2),
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color})
            self.area:addGameObject('TrailParticle', 
            self.x - 0.9*self.w*math.cos(self.r) + 0.2*self.w*math.cos(self.r + math.pi/2),
            self.y - 0.9*self.w*math.sin(self.r) + 0.2*self.w*math.sin(self.r + math.pi/2),
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color})

        elseif self.ship == 'Striker' then
            self.area:addGameObject('TrailParticle', 
            self.x - 1.0*self.w*math.cos(self.r) + 0.2*self.w*math.cos(self.r - math.pi/2), 
            self.y - 1.0*self.w*math.sin(self.r) + 0.2*self.w*math.sin(self.r - math.pi/2), 
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color}) 
            self.area:addGameObject('TrailParticle', 
            self.x - 1.0*self.w*math.cos(self.r) + 0.2*self.w*math.cos(self.r + math.pi/2), 
            self.y - 1.0*self.w*math.sin(self.r) + 0.2*self.w*math.sin(self.r + math.pi/2), 
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color})

        elseif self.ship == 'Squaren' then
            self.area:addGameObject('TrailParticle', 
            self.x - 1*self.w*math.cos(self.r) + 0*self.w*math.cos(self.r + math.pi/2),
            self.y - 1*self.w*math.sin(self.r) + 0*self.w*math.sin(self.r + math.pi/2),  
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color})

        elseif self.ship == 'Swift' then
            self.area:addGameObject('TrailParticle', 
            self.x - 0.7*self.w*math.cos(self.r) + 0*self.w*math.cos(self.r + math.pi/2),
            self.y - 0.7*self.w*math.sin(self.r) + 0*self.w*math.sin(self.r + math.pi/2),  
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color})

        elseif self.ship == 'Tetron' then
            self.area:addGameObject('TrailParticle', 
            self.x - 1.3*self.w*math.cos(self.r) + 0.3*self.w*math.cos(self.r - math.pi/2), 
            self.y - 1.3*self.w*math.sin(self.r) + 0.3*self.w*math.sin(self.r - math.pi/2), 
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color}) 
            self.area:addGameObject('TrailParticle', 
            self.x - 1.3*self.w*math.cos(self.r) + 0.3*self.w*math.cos(self.r + math.pi/2), 
            self.y - 1.3*self.w*math.sin(self.r) + 0.3*self.w*math.sin(self.r + math.pi/2), 
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color})

        elseif self.ship == 'Pavis' then
            self.area:addGameObject('TrailParticle', 
            self.x - 0.5*self.w*math.cos(self.r) + 0.7*self.w*math.cos(self.r - math.pi/2), 
            self.y - 0.5*self.w*math.sin(self.r) + 0.7*self.w*math.sin(self.r - math.pi/2), 
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color}) 
            self.area:addGameObject('TrailParticle', 
            self.x - 0.5*self.w*math.cos(self.r) + 0.7*self.w*math.cos(self.r + math.pi/2), 
            self.y - 0.5*self.w*math.sin(self.r) + 0.7*self.w*math.sin(self.r + math.pi/2), 
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color})
            
        elseif self.ship == 'Verus' then
            self.area:addGameObject('TrailParticle', 
            self.x - 1*self.w*math.cos(self.r) + 0.9*self.w*math.cos(self.r - math.pi/2), 
            self.y - 1*self.w*math.sin(self.r) + 0.9*self.w*math.sin(self.r - math.pi/2), 
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color}) 
            self.area:addGameObject('TrailParticle', 
            self.x - 1*self.w*math.cos(self.r) + 0.9*self.w*math.cos(self.r + math.pi/2), 
            self.y - 1*self.w*math.sin(self.r) + 0.9*self.w*math.sin(self.r + math.pi/2), 
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color})
        elseif self.ship == 'Interceptron' then
            self.area:addGameObject('TrailParticle', 
            self.x - 1.2*self.w*math.cos(self.r) + 0*self.w*math.cos(self.r + math.pi/2),
            self.y - 1.2*self.w*math.sin(self.r) + 0*self.w*math.sin(self.r + math.pi/2),  
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color})

        elseif self.ship == 'Velioch' then
            self.area:addGameObject('TrailParticle', 
            self.x - 0.9*self.w*math.cos(self.r) + 0.2*self.w*math.cos(self.r - math.pi/2), 
            self.y - 0.9*self.w*math.sin(self.r) + 0.2*self.w*math.sin(self.r - math.pi/2), 
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color}) 
            self.area:addGameObject('TrailParticle', 
            self.x - 0.9*self.w*math.cos(self.r) + 0.2*self.w*math.cos(self.r + math.pi/2), 
            self.y - 0.9*self.w*math.sin(self.r) + 0.2*self.w*math.sin(self.r + math.pi/2), 
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color})
        elseif self.ship == 'Bit Hunter' then
            self.area:addGameObject('TrailParticle', 
            self.x - 0.8*self.w*math.cos(self.r), self.y - 1*self.w*math.sin(self.r), 
            {parent = self, r = random(2, 4), d = random(0.1, 0.2), color = self.trail_color}) 

        elseif self.ship == 'Anthophila' then
            self.area:addGameObject('TrailParticle', 
            self.x - 1.3*self.w*math.cos(self.r) + 0.1*self.w*math.cos(self.r - math.pi/2),
            self.y - 1.3*self.w*math.sin(self.r) + 0.1*self.w*math.sin(self.r - math.pi/2),
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color})
            self.area:addGameObject('TrailParticle', 
            self.x - 1.3*self.w*math.cos(self.r) + 0.1*self.w*math.cos(self.r + math.pi/2),
            self.y - 1.3*self.w*math.sin(self.r) + 0.1*self.w*math.sin(self.r + math.pi/2),
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color})

        elseif self.ship == 'Crusader' then
            self.area:addGameObject('TrailParticle', 
            self.x - 1.2*self.w*math.cos(self.r) + 0.2*self.w*math.cos(self.r - math.pi/2), 
            self.y - 1.2*self.w*math.sin(self.r) + 0.2*self.w*math.sin(self.r - math.pi/2), 
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color}) 
            self.area:addGameObject('TrailParticle', 
            self.x - 1.2*self.w*math.cos(self.r) + 0.2*self.w*math.cos(self.r + math.pi/2), 
            self.y - 1.2*self.w*math.sin(self.r) + 0.2*self.w*math.sin(self.r + math.pi/2), 
            {parent = self, r = random(2, 4), d = random(0.15, 0.25), color = self.trail_color}) 

        end
    end)

    -- Flats
    self.flat_hp = 0
    self.flat_ammo = 0
    self.flat_boost = 0
    self.ammo_gain = 0
    self.additional_bounce_projectiles = 0
    self.additional_homing_projectiles = 0
    self.additional_barrage_projectiles = 0

    -- Multipliers
    self.hp_multiplier = 1
    self.ammo_multiplier = 1
    self.boost_multiplier = 1
    self.hp_spawn_chance_multiplier = 1
    self.sp_spawn_chance_multiplier = 1
    self.boost_spawn_chance_multiplier = 1
    self.base_aspd_multiplier = 1
    self.aspd_multiplier = Stat(1)
    self.base_mvspd_multiplier = 1
    self.mvspd_multiplier = Stat(1)
    self.base_pspd_multiplier = 1
    self.pspd_multiplier = Stat(1)
    self.base_cycle_speed_multiplier = 1
    self.cycle_speed_multiplier = Stat(1)
    self.luck_multiplier = 1
    self.enemy_spawn_rate_multiplier = 1
    self.resource_spawn_rate_multiplier = 1
    self.attack_spawn_rate_multiplier = 1
    self.turn_rate_multiplier = 1
    self.boost_effectiveness_multiplier = 1
    self.projectile_size_multiplier = 1
    self.boost_recharge_rate_multiplier = 1
    self.invulnerability_time_multiplier = 1
    self.ammo_consumption_multiplier = 1
    self.size_multiplier = 1
    self.stat_boost_duration_multiplier = 1
    self.angle_change_frequency_multiplier = 1
    self.projectile_acceleration_multiplier = 1
    self.projectile_deceleration_multiplier = 1
    self.projectile_duration_multiplier = 1
    self.area_multiplier = 1
    self.double_spawn_chance_multiplier = 1
    self.triple_spawn_chance_multiplier = 1
    self.rapid_spawn_chance_multiplier = 1
    self.spread_spawn_chance_multiplier = 1
    self.back_spawn_chance_multiplier = 1
    self.side_spawn_chance_multiplier = 1
    self.homing_spawn_chance_multiplier = 1
    self.blast_spawn_chance_multiplier = 1
    self.spin_spawn_chance_multiplier = 1
    self.flame_spawn_chance_multiplier = 1
    self.bounce_spawn_chance_multiplier = 1
    self.split2_spawn_chance_multiplier = 1
    self.split4_spawn_chance_multiplier = 1
    self.lightning_spawn_chance_multiplier = 1
    self.explode_spawn_chance_multiplier = 1
    self.energy_shield_recharge_amount_multiplier = 1
    self.energy_shield_recharge_cooldown_multiplier = Stat(1)

    -- Chances
    self.launch_homing_projectile_on_ammo_pickup_chance = 10
    self.launch_homing_projectile_on_cycle_chance = 5
    self.launch_homing_projectile_on_kill_chance = 3
    self.launch_homing_projectile_while_boosting_chance = 3
    self.regain_hp_on_ammo_pickup_chance = 15
    self.regain_hp_on_sp_pickup_chance = 65
    self.regain_hp_on_cycle_chance = 5
    self.regain_ammo_on_kill_chance = 5
    self.regain_full_ammo_on_cycle_chance = 5
    self.regain_boost_on_kill_chance = 10
    self.gain_aspd_boost_on_kill_chance = 3
    self.gain_double_sp_chance = 5
    self.spawn_haste_area_on_hp_pickup_chance = 45
    self.spawn_haste_area_on_sp_pickup_chance = 65
    self.spawn_haste_area_on_cycle_chance = 5
    self.spawn_sp_on_cycle_chance = 3
    self.spawn_hp_on_cycle_chance = 3
    self.spawn_boost_on_kill_chance = 3
    self.spawn_double_hp_chance = 5
    self.spawn_double_sp_chance = 5
    self.barrage_on_kill_chance = 5
    self.barrage_on_cycle_chance = 5
    self.change_attack_on_cycle_chance = 10
    self.mvspd_boost_on_cycle_chance = 5
    self.pspd_boost_on_cycle_chance = 5
    self.pspd_inhibit_on_cycle_chance = 10
    self.increased_cycle_speed_while_boosting_chance = 3
    self.increased_luck_while_boosting_chance = 3
    self.invulnerability_while_boosting_chance = 3
    self.drop_double_ammo_chance = 5
    self.attack_twice_chance = 5
    self.shield_projectile_chance = 10
    self.split_projectiles_split_chance = 10
    self.drop_mines_chance = 2
    self.self_explode_on_cycle_chance = 5
    self.added_chance_to_all_on_kill_events = 0

    -- Booleans
    self.increased_luck_while_boosting = false
    self.projectile_ninety_degree_change = false
    self.projectile_random_degree_change = false
    self.wavy_projectiles = false
    self.fast_slow_projectiles = false
    self.slow_fast_projectiles = false
    self.additional_lightning_bolt = false
    self.increased_lightning_angle = false
    self.fixed_spin_attack_direction_left = false
    self.fixed_spin_attack_direction_right = false
    self.split_projectiles_split = false
    self.start_with_double = false
    self.start_with_triple = false
    self.start_with_rapid = false
    self.start_with_spread = false
    self.start_with_back = false
    self.start_with_side = false
    self.start_with_homing = false
    self.start_with_blast = false
    self.start_with_spin = false
    self.start_with_flame = false
    self.start_with_bounce = false
    self.start_with_split2 = false
    self.start_with_split4 = false
    self.start_with_lightning = false
    self.start_with_explode = false
    self.barrage_nova = false
    self.mine_projectile = false
    self.energy_shield = false
    self.change_attack_periodically = false
    self.gain_sp_on_death = false
    self.convert_hp_to_sp_if_hp_full = false
    self.no_boost = false
    self.half_ammo = false 
    self.half_hp = false
    self.deal_damage_while_invulnerable = false
    self.refill_ammo_if_hp_full = false
    self.refill_boost_if_hp_full = false
    self.only_spawn_boost = false
    self.only_spawn_attack = false
    self.no_ammo_drop = false
    self.infinite_ammo = false
    self.change_attack_when_no_ammo = false

    -- Conversions
    self.ammo_to_aspd = 0
    self.mvspd_to_aspd = 0
    self.mvspd_to_hp = 0
    self.mvspd_to_pspd = 0

    -- Stats
    treeToPlayer(self)
    self:setStats()
    self:generateChances()
    self:passives()

    if self.start_with_double then
        self:setAttack('Double')
    elseif self.start_with_triple then
        self:setAttack('Triple')
    elseif self.start_with_rapid then
        self:setAttack('Rapid')
    elseif self.start_with_spread then
        self:setAttack('Spread')
    elseif self.start_with_back then
        self:setAttack('Back')
    elseif self.start_with_side then
        self:setAttack('Side')
    elseif self.start_with_homing then
        self:setAttack('Homing')
    elseif self.start_with_blast then
        self:setAttack('Blast')
    elseif self.start_with_spin then
        self:setAttack('Spin')
    elseif self.start_with_flame then
        self:setAttack('Flame')
    elseif self.start_with_bounce then
        self:setAttack('Bounce')
    elseif self.start_with_split2 then
        self:setAttack('2Split')
    elseif self.start_with_split4 then
        self:setAttack('4Split')
    elseif self.start_with_lightning then
        self:setAttack('Lightning')
    elseif self.start_with_explode then
        self:setAttack('Explode')
    else
        self:setAttack('Neutral')
    end

    if self.console_attack then
        self:setAttack(self.console_attack)
    end

    self.timer:every('roller_pool', 0.5, function() if self.inside_roller_pool then self:hit(10) end end)
end

function Player:setStats()
    -- HP
    if self.half_hp then
        self.max_hp = 50
        self.hp = self.max_hp
    elseif self.half_hp == false then
        self.max_hp = (self.max_hp + self.flat_hp)*self.hp_multiplier
        self.hp = self.max_hp
    end

    -- ES
    if self.energy_shield then
        self.invulnerability_time_multiplier = self.invulnerability_time_multiplier/2
    end

    -- Boost
    if self.no_boost then
        self.max_boost = 0
    elseif self.no_boost == false then
        self.max_boost = 100
    end

    if self.half_ammo then
        self.max_ammo = 50
    elseif self.half_ammo == false then
        self.max_ammo = 100
    end

    -- Ship passives
    if self.ship == 'Striker' then
        self.max_ammo = 120
        self.base_aspd_multiplier = self.base_aspd_multiplier + 1
        self.base_pspd_multiplier = self.base_pspd_multiplier + 0.25
        self.max_hp = 50
        self.hp = self.max_hp
        self.additional_barrage_projectiles = 8
        self.barrage_on_kill_chance = 10
        self.barrage_on_cycle_chance = 10
        self.barrage_nova = true
    elseif self.ship == 'Squaren' then
        self.max_hp = 100
        self.hp = self.max_hp
        self.max_boost = 30
        self.base_pspd_multiplier = self.base_pspd_multiplier + 1
        self.base_mvspd_multiplier = self.base_mvspd_multiplier + 0.5
        self.projectile_size_multiplier = self.projectile_size_multiplier + 0.5
        self.max_ammo = 50
        self.change_attack_on_cycle_chance = 10
        self.turn_rate_multiplier = self.turn_rate_multiplier + 0.5
    elseif self.ship == 'Swift' then
        self.max_hp = 50
        self.hp = self.max_hp
        self.turn_rate_multiplier = self.turn_rate_multiplier + 1
        self.base_mvspd_multiplier = self.base_mvspd_multiplier + 1
        self.base_cycle_speed_multiplier = self.base_cycle_speed_multiplier + 1.5
        self.projectile_size_multiplier = self.projectile_size_multiplier - 0.5
        self.max_ammo = 30
        self.max_boost = 50
        self.increased_luck_while_boosting_chance = 10
        self.attack_twice_chance = 10
    elseif self.ship == 'Tetron' then
        self.max_hp = 150
        self.hp = self.max_hp
        self.base_mvspd_multiplier = self.base_mvspd_multiplier - 0.5
        self.boost_effectiveness_multiplier = self.boost_effectiveness_multiplier - 0.5
        self.boost_recharge_rate_multiplier = self.boost_recharge_rate_multiplier - 0.5
        self.turn_rate_multiplier = self.turn_rate_multiplier - 0.3
        self.projectile_size_multiplier = self.projectile_size_multiplier + 0.3
        self.luck_multiplier = self.luck_multiplier + 0.5
        self.max_ammo = 70
        self.regain_hp_on_cycle_chance = 10
        self.attack_twice_chance = 10
        self.convert_hp_to_sp_if_hp_full = true
    elseif self.ship == 'Pavis' then
        self.max_hp = 50
        self.hp = self.max_hp
        self.base_mvspd_multiplier = self.base_mvspd_multiplier + 0.5
        self.boost_recharge_rate_multiplier = self.boost_recharge_rate_multiplier - 1
        self.max_ammo = 70
        self.shield_projectile_chance = 10
        self.gain_aspd_boost_on_kill_chance = 15
        self.slow_fast_projectiles = true
    elseif self.ship == 'Verus' then
        self.max_ammo = 100
        self.turn_rate_multiplier = self.turn_rate_multiplier - 0.3
        self.barrage_on_cycle_chance = 10
        self.additional_lightning_bolt = true
        self.increased_lightning_angle = true
        self.energy_shield = true
        self.barrage_nova = true
    elseif self.ship == 'Interceptron' then
        self.max_hp = 70
        self.hp = self.max_hp
        self.base_aspd_multiplier = self.base_aspd_multiplier + 1
        self.regain_hp_on_ammo_pickup_chance = 15
        self.gain_double_sp_chance = 15
        self.projectile_random_degree_change = true
    elseif self.ship == 'Velioch' then
        self.max_hp = 50
        self.hp = self.max_hp
        self.max_boost = 50
        self.max_ammo = 80
        self.ammo_gain = 10
        self.launch_homing_projectile_on_kill_chance = 15
        self.additional_homing_projectiles = 3
    elseif self.ship == 'Bit Hunter' then
        self.base_mvspd_multiplier = self.base_mvspd_multiplier - 0.1
        self.turn_rate_multiplier = self.turn_rate_multiplier - 0.1
        self.max_ammo = 80
        self.base_aspd_multiplier = self.base_aspd_multiplier - 0.2
        self.base_pspd_multiplier = self.base_pspd_multiplier - 0.1
        self.invulnerability_time_multiplier = self.invulnerability_time_multiplier + 0.5
        self.size_multiplier = self.size_multiplier + 0.1
        self.luck_multiplier = self.luck_multiplier + 0.5
        self.resource_spawn_rate_multiplier = self.resource_spawn_rate_multiplier + 0.5
        self.enemy_spawn_rate_multiplier = self.enemy_spawn_rate_multiplier + 0.5
        self.base_cycle_speed_multiplier = self.base_cycle_speed_multiplier + 0.25
    elseif self.ship == 'Anthophila' then
        self.max_hp = 70
        self.hp = self.max_hp
        self.additional_barrage_projectiles = 3
        self.spawn_haste_area_on_cycle_chance = 10
        self.regain_hp_on_cycle_chance = 10
        self.barrage_on_kill_chance = 15
        self.boost_recharge_rate_multiplier = self.boost_recharge_rate_multiplier - 0.5
    elseif self.ship == 'Crusader' then
        self.max_boost = 80
        self.boost_effectiveness_multiplier = self.boost_effectiveness_multiplier + 1
        self.base_mvspd_multiplier = self.base_mvspd_multiplier - 0.4
        self.turn_rate_multiplier = self.turn_rate_multiplier - 0.4
        self.base_aspd_multiplier = self.base_aspd_multiplier - 0.44
        self.base_pspd_multiplier = self.base_pspd_multiplier + 0.5
        self.max_hp = 150
        self.hp = self.max_hp
        self.size_multiplier = self.size_multiplier + 0.5
    end
end

function Player:generateChances()
    self.chances = {}
    for k, v in pairs(self) do
        if k:find('_chance') and type(v) == 'number' then
            if k:find('_on_kill') and v > 0 then
                self.chances[k] = chanceList(
                {true, math.ceil(v+self.added_chance_to_all_on_kill_events)},
                {false, 100-math.ceil(v+self.added_chance_to_all_on_kill_events)})
            else
      	        self.chances[k] = chanceList({true, math.ceil(v*self.luck_multiplier)}, {false, 100-math.ceil(v*self.luck_multiplier)})
            end
        end
    end
end

function Player:update(dt)
    Player.super.update(self, dt)

    if self.inside_haste_area then self.aspd_multiplier:increase(100) end
    if self.aspd_boosting then self.aspd_multiplier:increase(100) end
    if self.mvspd_boosting then self.mvspd_multiplier:increase(50) end
    if self.pspd_boosting then self.pspd_multiplier:increase(100) end
    if self.pspd_inhibit then self.pspd_multiplier:decrease(50) end
    if self.cycle_speeding then self.cycle_speed_multiplier:increase(200) end
    if self.inside_roller_pool then self.mvspd_multiplier:decrease(150) end
    self.inside_roller_pool = false
    
    -- Conversions
    if self.ammo_to_aspd > 0 then
        self.aspd_multiplier:increase((self.ammo_to_aspd/100)*(self.max_ammo - 100))
    end

    if self.mvspd_to_aspd > 0 then
        self.aspd_multiplier:increase((self.mvspd_to_aspd/100)*(self.max_v - 100))
    end

    if self.mvspd_to_pspd > 0 then
        self.pspd_multiplier:increase((self.mvspd_to_pspd/100)*(self.max_v - 100))
    end

    if self.mvspd_to_hp > 0 then
        self.hp = self.hp + (self.mvspd_to_hp/100)*(self.max_hp - 100)
    end

    self.aspd_multiplier:update(dt)
    self.mvspd_multiplier:update(dt)
    self.pspd_multiplier:update(dt)
    self.cycle_speed_multiplier:update(dt)

    -- Collision
    if self.x < 0 or self.x > gw then self:die() end
    if self.y < 0 or self.y > gh then self:die() end

    if self.collider:enter('Collectable') then
        local collision_data = self.collider:getEnterCollisionData('Collectable')
        local object = collision_data.collider:getObject()

        self.hp_full = (self.hp == self.max_hp)
        Collect:play()

        if object:is(Ammo) then
            object:die()
            self:addAmmo(5)
            self:onAmmoPickup()

        elseif object:is(Boost) then
            object:die()
            self:addBoost(25)

        elseif object:is(HP) then
            object:die()
            self:onHPPickup()
            self:addHP(25)
            if self.convert_hp_to_sp_if_hp_full and self.hp == self.max_hp then
                addSp(3)
                self.area:addGameObject('InfoText', self.x, self.y, {text = '3 SP Gained!', color = faded_skill_point_color})
            elseif self.refill_ammo_if_hp_full and self.hp_full then
                self:addAmmo(100)
                self.area:addGameObject('InfoText', self.x, self.y, {text = 'Ammo Refilled!', color = faded_skill_point_color})
            elseif self.refill_boost_if_hp_full and self.hp_full then
                self:addBoost(100)
                self.area:addGameObject('InfoText', self.x, self.y, {text = 'Boost Refilled!', color = faded_skill_point_color})
            end

        elseif object:is(SkillPoint) then
            object:die()
            self:onSPPickup()
            current_room.score = current_room.score + 250
            if self.gain_double_sp == true then addSp(2) else addSp(1) end
            
        elseif object:is(Attack) then
            object:die()
            current_room.score = current_room.score + 500
            self:setAttack(object.attack)

        end
    end

    if self.collider:enter('Enemy') then
        local collision_data = self.collider:getEnterCollisionData('Enemy')
        local object = collision_data.collider:getObject()

        if object then 
            self:hit(30)
            if self.invulnerable_damage then
                object:hit(50)
            end
        end
    end

    -- Cycle
    self.cycle_timer = self.cycle_timer + dt
    if self.cycle_timer > self.cycle_cooldown/self.cycle_speed_multiplier.value then
        self.cycle_timer = 0
        self:cycle()
        Cycle:play()
    end

    -- Boost
    self.boost = math.min(self.boost + 10*dt*self.boost_recharge_rate_multiplier, self.max_boost)
    self.boost_timer = self.boost_timer + dt
    if self.boost_timer > self.boost_cooldown then self.can_boost = true end
    self.max_v = self.base_max_v
    self.boosting = false
    if input:pressed('up') and self.boost > 1 and self.can_boost then self:onBoostStart() end
    if input:released('up') then self:onBoostEnd() end
    if input:down('up') and self.boost > 1 and self.can_boost then 
        self.boosting = true
        self.max_v = 1.5*self.base_max_v 
        self.boost = self.boost - 50*dt*self.boost_effectiveness_multiplier
        if self.boost <= 1 then
            self.boosting = false
            self.can_boost = false
            self.boost_timer = 0
            self:onBoostEnd()
        end
    end
    if input:pressed('down') and self.boost > 1 and self.can_boost then self:onBoostStart() end
    if input:released('down') then self:onBoostEnd() end
    if input:down('down') and self.boost > 1 and self.can_boost then 
        self.boosting = true
        self.max_v = 0.5*self.base_max_v 
        self.boost = self.boost - 50*dt*self.boost_effectiveness_multiplier
        if self.boost <= 1 then
            self.boosting = false
            self.can_boost = false
            self.boost_timer = 0
            self:onBoostEnd()
        end
    end
    self.trail_color = skill_point_color 
    if self.boosting then self.trail_color = boost_color end

    -- Shoot
    self.shoot_timer = self.shoot_timer + dt
    if self.shoot_timer > self.shoot_cooldown/self.aspd_multiplier.value then
        self.shoot_timer = 0
        self:shoot()
        self.timer:after(0.09, function() if self.attack_twice then self:shoot() end end)
    end

    -- Movement
    if input:down('left') then self.r = self.r - self.rv*dt*self.turn_rate_multiplier end
    if input:down('right') then self.r = self.r + self.rv*dt*self.turn_rate_multiplier end
    self.v = math.min(self.v + self.a*dt, self.max_v)*self.mvspd_multiplier.value
    self.collider:setLinearVelocity(self.v*math.cos(self.r), self.v*math.sin(self.r))
end

function Player:draw()
    pushRotate(self.x, self.y, self.r)
    love.graphics.setColor(default_color)
    for _, polygon in ipairs(self.polygons) do
        local points = fn.map(polygon, function(k, v)
            if k % 2 == 1 then
                return self.x + v + random(-1, 1)
            else
                return self.y + v + random(-1, 1)
            end
        end)
        love.graphics.polygon('line', points)
    end
    love.graphics.pop()
end

function Player:destroy()
    Player.super.destroy(self)
end

function Player:cycle()
    self.area:addGameObject('CycleEffect', self.x, self.y, {parent = self})
    self:onCycle()
end

function Player:shoot()

    local d = 1.2*self.w
    self.area:addGameObject('ShootEffect', self.x + d*math.cos(self.r), self.y + d*math.sin(self.r), {player = self, d = d})

    local mods = {
        shield = self.chances.shield_projectile_chance:next()
    }
    
    if self.attack == 'Neutral' then
        Shoot:play()
        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), table.merge({r = self.r, attack = self.attack}, mods))

    elseif self.attack == 'Double' then
        self.ammo = self.ammo - attacks[self.attack].ammo*self.ammo_consumption_multiplier

        for i = 1, 2 do
            Shoot:play()
        end
        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r + math.pi/12), self.y + 1.5*d*math.sin(self.r + math.pi/12), table.merge({r = self.r + math.pi/12, attack = self.attack}, mods))
        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r - math.pi/12), self.y + 1.5*d*math.sin(self.r - math.pi/12), table.merge({r = self.r - math.pi/12, attack = self.attack}, mods))

    elseif self.attack == 'Triple' then
        self.ammo = self.ammo - attacks[self.attack].ammo*self.ammo_consumption_multiplier

        for i = 1, 3 do
            Shoot:play()
        end
        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), table.merge({r = self.r, attack = self.attack}, mods))
        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r + math.pi / 12), self.y + 1.5*d*math.sin(self.r + math.pi / 12), table.merge({r = self.r + math.pi / 12, attack = self.attack}, mods))
        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r - math.pi / 12), self.y + 1.5*d*math.sin(self.r - math.pi / 12), table.merge({r = self.r - math.pi / 12, attack = self.attack}, mods))


    elseif self.attack == 'Rapid' then
        self.ammo = self.ammo - attacks[self.attack].ammo*self.ammo_consumption_multiplier

        Shoot:play()
        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), table.merge({r = self.r, attack = self.attack}, mods))

    elseif self.attack == 'Spread' then
        self.ammo = self.ammo - attacks[self.attack].ammo*self.ammo_consumption_multiplier

        Shoot:play()
        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), table.merge({r = self.r - random(- math.pi / 8,  math.pi / 8), attack = self.attack}, mods))

    elseif self.attack == 'Back' then
        self.ammo = self.ammo - attacks[self.attack].ammo*self.ammo_consumption_multiplier

        for i = 1, 2 do
            Shoot:play()
        end
        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), table.merge({r = self.r, attack = self.attack}, mods))
        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r + math.pi / 1), self.y + 1.5*d*math.sin(self.r + math.pi / 1), table.merge({r = self.r + math.pi / 1, attack = self.attack}, mods))

    elseif self.attack == 'Side' then
        self.ammo = self.ammo - attacks[self.attack].ammo*self.ammo_consumption_multiplier

        for i = 1, 3 do
            Shoot:play()
        end
        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), table.merge({r = self.r, attack = self.attack}, mods))
        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r + math.pi / 2), self.y + 1.5*d*math.sin(self.r + math.pi / 2), table.merge({r = self.r + math.pi / 2, attack = self.attack}, mods))
        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r - math.pi / 2), self.y + 1.5*d*math.sin(self.r - math.pi / 2), table.merge({r = self.r - math.pi / 2, attack = self.attack}, mods))

    elseif self.attack == 'Homing' then
        self.ammo = self.ammo - attacks[self.attack].ammo*self.ammo_consumption_multiplier

        Shoot:play()
        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), table.merge({r = self.r, attack = self.attack}, mods))

    elseif self.attack == 'Blast' then
        self.ammo = self.ammo - attacks[self.attack].ammo*self.ammo_consumption_multiplier
        
        Shotgun:play()
        for i = 1, 12 do 
            local random_angle = random(-math.pi / 6, math.pi / 6)
            self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r + random_angle), self.y + 1.5*d*math.sin(self.r + random_angle), table.merge({r = self.r + random_angle, attack = self.attack, v = random(500, 600)}, mods))
        end
        camera:shake(4, 60, 0.4)

    elseif self.attack == 'Spin' then
        self.ammo = self.ammo - attacks[self.attack].ammo*self.ammo_consumption_multiplier

        Shoot:play()
        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), table.merge({r = self.r, attack = self.attack}, mods))

    elseif self.attack == 'Flame' then
        self.ammo = self.ammo - attacks[self.attack].ammo*self.ammo_consumption_multiplier

        Flame:play()
        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), table.merge({r = self.r - random(- math.pi / 20,  math.pi / 20), attack = self.attack}, mods))

    elseif self.attack == 'Bounce' then
        self.ammo = self.ammo - attacks[self.attack].ammo*self.ammo_consumption_multiplier

        Shoot:play()
        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), table.merge({r = self.r, attack = self.attack, bounce = 4 + self.additional_bounce_projectiles}, mods))

    elseif self.attack == '2Split' then
        self.ammo = self.ammo - attacks[self.attack].ammo*self.ammo_consumption_multiplier

        Shoot:play()
        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), table.merge({r = self.r, attack = self.attack}, mods))

    elseif self.attack == '4Split' then
        self.ammo = self.ammo - attacks[self.attack].ammo*self.ammo_consumption_multiplier

        Shoot:play()
        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), table.merge({r = self.r, attack = self.attack}, mods))

    elseif self.attack == 'Lightning' then

        if self.increased_lightning_angle then
            self.x1, self.y1 = self.x + math.cos(self.r), self.y + math.sin(self.r)
            self.cx, self.cy = self.x1 + math.cos(self.r), self.y1 + math.sin(self.r)
        else
            self.x1, self.y1 = self.x + d*math.cos(self.r), self.y + d*math.sin(self.r)
            self.cx, self.cy = self.x1 + 24*math.cos(self.r), self.y1 + 24*math.sin(self.r)
        end
        
        -- Finds the closest enemy
        local nearby_enemies = self.area:getAllGameObjectsThat(function(e)
            for _, enemy in ipairs(enemies) do
                if e:is(_G[enemy]) and (distance(e.x, e.y, self.cx, self.cy) < 64*self.area_multiplier) then
                    return true
                end
            end
        end)
        table.sort(nearby_enemies, function(a, b) return distance(a.x, a.y, self.cx, self.cy) < distance(b.x, b.y, self.cx, self.cy) end)
        local closest_enemy1 = nearby_enemies[1]
        local closest_enemy2 = nearby_enemies[2]

        -- Attacks closest enemy
        if closest_enemy1 then
            Thunder:play()
            self.ammo = self.ammo - attacks[self.attack].ammo*self.ammo_consumption_multiplier
            closest_enemy1:hit()
            local x2, y2 = closest_enemy1.x, closest_enemy1.y
            self.area:addGameObject('LightningLine', 0, 0, {x1 = self.x1, y1 = self.y1, x2 = x2, y2 = y2})
            for i = 1, love.math.random(4, 8) do self.area:addGameObject('ExplodeParticle', self.x1, self.y1, {color = table.random({default_color, boost_color})}) end
            for i = 1, love.math.random(4, 8) do self.area:addGameObject('ExplodeParticle', x2, y2, {color = table.random({default_color, boost_color})}) end
        end

        if self.additional_lightning_bolt and closest_enemy2 then
            Thunder:play()
            closest_enemy2:hit()
            local x2, y2 = closest_enemy2.x, closest_enemy2.y
            self.area:addGameObject('LightningLine', 0, 0, {x1 = self.x1, y1 = self.y1, x2 = x2, y2 = y2})
            for i = 1, love.math.random(4, 8) do self.area:addGameObject('ExplodeParticle', self.x1, self.y1, {color = table.random({default_color, boost_color})}) end
            for i = 1, love.math.random(4, 8) do self.area:addGameObject('ExplodeParticle', x2, y2, {color = table.random({default_color, boost_color})}) end
        end

    elseif self.attack == 'Explode' then
        self.ammo = self.ammo - attacks[self.attack].ammo*self.ammo_consumption_multiplier

        Shoot:play()
        self.area:addGameObject('Projectile', self.x + 1.5*d*math.cos(self.r), self.y + 1.5*d*math.sin(self.r), {r = self.r, attack = self.attack})

    end


    if self.ammo <= 0 then 
        self:setAttack('Neutral')
        self.ammo = self.max_ammo

        if self.change_attack_when_no_ammo then
            self:setRandomAttack()
        end
    end

    if self.infinite_ammo then
        self.ammo = self.max_ammo
    end
end

function Player:setAttack(attack)
    self.attack = attack
    self.shoot_cooldown = attacks[attack].cooldown
    self.ammo = self.max_ammo
end

function Player:hit(damage)
    if self.invincible then return end
    damage = damage or 5

    if self.energy_shield then
        damage = damage*2
        self.timer:after('energy_shield_recharge_cooldown', self.energy_shield_recharge_cooldown*self.energy_shield_recharge_cooldown_multiplier.value, function() 
            self.timer:every('energy_shield_recharge_amount', 0.25, function()
                self:addHP(self.energy_shield_recharge_amount*self.energy_shield_recharge_amount_multiplier)
            end)
        end) 
    end

    for i = 1, love.math.random(4, 8) do self.area:addGameObject('ExplodeParticle', self.x, self.y) end
    self:removeHP(damage)

    if damage >= 30 then
        self.invincible = true
        self.timer:after('invincibility', 10*self.invulnerability_time_multiplier, function() self.invincible = false end)
        for i = 1, 50 do self.timer:after((i-1)*0.04, function() self.invisible = not self.invisible end) end
        self.timer:after(51*0.04, function() self.invisible = false end)

        Hit:play()
        camera:shake(6, 60, 0.2)
        flash(3)
        slow(0.25, 0.5)
    else
        Hit2:play()
        camera:shake(3, 60, 0.1)
        flash(2)
        slow(0.75, 0.25)
    end

    if self.deal_damage_while_invulnerable and self.invincible then
        self.invulnerable_damage = true
    end
end

function Player:die()
    self:onDeath()
    Game_over:play()

    self.dead = true 
    flash(4)
    camera:shake(6, 60, 0.4)
    slow(0.15, 1)
    for i = 1, love.math.random(8, 12) do self.area:addGameObject('ExplodeParticle', self.x, self.y) end

    current_room:finish()
end

function Player:addAmmo(amount)
    self.ammo = math.max(math.min(self.ammo + amount + self.ammo_gain, self.max_ammo), 0)
    current_room.score = current_room.score + 50
end

function Player:addBoost(amount)
    self.boost = math.max(math.min(self.boost + amount, self.max_boost), 0)
    current_room.score = current_room.score + 150
end

function Player:addHP(amount)
    self.hp = math.max(math.min(self.hp + amount, self.max_hp), 0)
end

function Player:removeHP(amount)
    self.hp = self.hp - (amount or 5)
    if self.hp <= 0 then
        self.hp = 0
        self:die()
    end
end

function Player:onAmmoPickup()
    if self.chances.launch_homing_projectile_on_ammo_pickup_chance:next() then
        local d = 1.2*self.w
        for i = 1, 1+self.additional_homing_projectiles do
            self.area:addGameObject('Projectile', self.x + d*math.cos(self.r), self.y + d*math.sin(self.r), {r = self.r, attack = 'Homing'})
        end
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'Homing Projectile!', color = faded_skill_point_color})
    end

    if self.chances.regain_hp_on_ammo_pickup_chance:next() then
        self:addHP(25)
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'HP Regain!', color = faded_hp_color})
    end
end

function Player:onSPPickup()
    if self.chances.regain_hp_on_sp_pickup_chance:next() then
        self:addHP(25)
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'HP Regain!', color = faded_hp_color})
    end

    if self.chances.spawn_haste_area_on_sp_pickup_chance:next() then
        self.area:addGameObject('HasteArea', self.x, self.y)
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'Haste Area!', color = faded_ammo_color})
    end
end

function Player:onHPPickup()
    if self.chances.spawn_haste_area_on_hp_pickup_chance:next() then
        self.area:addGameObject('HasteArea', self.x, self.y)
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'Haste Area!', color = faded_ammo_color})
    end
end

function Player:onCycle()
    if self.only_spawn_boost == false and self.only_spawn_attack == false then
        if self.chances.spawn_sp_on_cycle_chance:next() then
            self.area:addGameObject('SkillPoint')
            self.area:addGameObject('InfoText', self.x, self.y, {text = 'SP Spawn!', color = faded_skill_point_color})
        end
    end

    if self.only_spawn_boost == false and self.only_spawn_attack == false then   
        if self.chances.spawn_hp_on_cycle_chance:next() then
            self.area:addGameObject('HP')
            self.area:addGameObject('InfoText', self.x, self.y, {text = 'HP Spawn!', color = faded_hp_color})
        end
    end

    if self.chances.regain_hp_on_cycle_chance:next() then
        self:addHP(25)
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'HP Regain!', color = faded_hp_color})
    end

    if self.chances.regain_full_ammo_on_cycle_chance:next() then
        self.ammo = self.max_ammo
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'Full Ammo!', color = faded_ammo_color})
    end

    if self.chances.change_attack_on_cycle_chance:next() then 
        random_attack = table.random(change_attack)
        self:setAttack(random_attack)
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'Attack Changed!', color = faded_skill_point_color})
    end

    if self.chances.spawn_haste_area_on_cycle_chance:next() then
        self.area:addGameObject('HasteArea', self.x, self.y)
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'Haste Area!', color = faded_ammo_color})
    end

    if self.chances.barrage_on_cycle_chance:next() then
        for i = 1, 1+self.additional_barrage_projectiles do
            for i = 1, 8 do
                self.timer:after((i-1)*0.05, function()
                    if self.barrage_nova then
                        self.random_angle = random(-math.pi, math.pi)
                    else
                        self.random_angle = random(-math.pi/8, math.pi/8)
                    end
                    local d = 2.2*self.w
                    self.area:addGameObject('Projectile', self.x + d*math.cos(self.r + self.random_angle), self.y + d*math.sin(self.r + self.random_angle), {r = self.r + self.random_angle, attack = self.attack})
                end)
            end
        end
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'Barrage!!!'})
    end

    if self.chances.launch_homing_projectile_on_cycle_chance:next() then
        local d = 1.2*self.w
        for i = 1, 1+self.additional_homing_projectiles do
            self.area:addGameObject('Projectile', self.x + d*math.cos(self.r), self.y + d*math.sin(self.r), {r = self.r, attack = 'Homing'})
        end
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'Homing Projectile!'})
    end

    if self.chances.launch_homing_projectile_on_cycle_chance:next() then
        local d = 1.2*self.w
        for i = 1, 1+self.additional_homing_projectiles do
            self.area:addGameObject('Projectile', self.x + d*math.cos(self.r), self.y + d*math.sin(self.r), {r = self.r, attack = 'Homing'})
        end
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'Homing Projectile!', color = faded_skill_point_color})
    end

    if self.chances.mvspd_boost_on_cycle_chance:next() then
        self.mvspd_boosting = true
        self.timer:after(4*self.stat_boost_duration_multiplier, function() self.mvspd_boosting = false end)
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'MVSPD Boost!', color = faded_skill_point_color})
    end

    if self.chances.pspd_boost_on_cycle_chance:next() then
        self.pspd_boosting = true
        self.timer:after(4*self.stat_boost_duration_multiplier, function() self.pspd_boosting = false end)
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'PSPD Boost!', color = faded_skill_point_color})
    end

    if self.chances.pspd_inhibit_on_cycle_chance:next() then
        self.pspd_inhibit = true
        self.timer:after(4*self.stat_boost_duration_multiplier, function() self.pspd_inhibit = false end)
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'PSPD Inhibit!', color = faded_skill_point_color})
    end

    if self.chances.self_explode_on_cycle_chance:next() then
        self.area:addGameObject('ExplodeEffect', self.x, self.y, {parent = self, w = 128, h = 128, color = faded_hp_color})
        for i = 1, love.math.random(8, 12) do self.area:addGameObject('ExplodeParticle', self.x, self.y, {s = 50, v = 200, color = faded_hp_color}) end
    end

end

function Player:onKill()
    if self.chances.barrage_on_kill_chance:next() then
        for i = 1, 1+self.additional_barrage_projectiles do
            for i = 1, 8 do
                self.timer:after((i-1)*0.05, function()
                    if self.barrage_nova then
                        self.random_angle = random(-math.pi, math.pi)
                    else
                        self.random_angle = random(-math.pi/8, math.pi/8)
                    end
                    local d = 2.2*self.w
                    self.area:addGameObject('Projectile', self.x + d*math.cos(self.r + self.random_angle), self.y + d*math.sin(self.r + self.random_angle), {r = self.r + self.random_angle, attack = self.attack})
                end)
            end
        end
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'Barrage!!!'})
    end

    if self.chances.regain_ammo_on_kill_chance:next() then
        self:addAmmo(20)
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'Ammo Regain!', color = faded_ammo_color})
    end

    if self.chances.launch_homing_projectile_on_kill_chance:next() then
        local d = 1.2*self.w
        for i = 1, 1+self.additional_homing_projectiles do
            self.area:addGameObject('Projectile', self.x + d*math.cos(self.r), self.y + d*math.sin(self.r), {r = self.r, attack = 'Homing'})
        end
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'Homing Projectile!', color = faded_skill_point_color})
    end

    if self.chances.regain_boost_on_kill_chance:next() then
        self:addBoost(40)
        self.area:addGameObject('InfoText', self.x, self.y, {text = 'Boost Regain!', color = faded_boost_color})
    end

    if self.only_spawn_attack == false then
        if self.chances.spawn_boost_on_kill_chance:next() then
            self.area:addGameObject('Boost', self.x, self.y)
            self.area:addGameObject('InfoText', self.x, self.y, {text = 'Boost Spawn!', color = faded_boost_color})
        end
    end

    if self.chances.gain_aspd_boost_on_kill_chance:next() then
        self.aspd_boosting = true
        self.timer:after(4, function() self.aspd_boosting = false end)
        self.area:addGameObject('InfoText', self.x, self.y, 
      	{text = 'ASPD Boost!', color = faded_ammo_color})
    end
end

function Player:onBoostStart()
    self.timer:every('launch_homing_projectile_while_boosting_chance', 0.2, function()
        if self.chances.launch_homing_projectile_while_boosting_chance:next() then
            local d = 1.2*self.w
            for i = 1, 1+self.additional_homing_projectiles do
                self.area:addGameObject('Projectile', self.x + d*math.cos(self.r), self.y + d*math.sin(self.r), {r = self.r, attack = 'Homing'})
            end
            self.area:addGameObject('InfoText', self.x, self.y, {text = 'Homing Projectile!', color = faded_skill_point_color})
        end
    end)

    self.timer:every('increased_cycle_speed_while_boosting_chance', 0.2, function()
        if self.chances.increased_cycle_speed_while_boosting_chance:next() then
            self.cycle_speeding = true
            self.timer:after(5, function() self.cycle_speeding = false end)
            self.area:addGameObject('InfoText', self.x, self.y, {text = 'Cycle Speed Boost!'})
        end
    end)

    self.timer:every('invulnerability_while_boosting_chance', 0.2, function()
        if self.chances.invulnerability_while_boosting_chance:next() then
            self.invincible = true
            self.timer:after(15*self.invulnerability_time_multiplier*self.stat_boost_duration_multiplier, function() self.invincible = false end)
            self.area:addGameObject('InfoText', self.x, self.y, {text = 'Invulnerability!'})
        end
    end)

    self.timer:after('increased_luck_while_boosting_chance', 0.2, function()
        if self.chances.increased_luck_while_boosting_chance:next() then
            self.increased_luck_while_boosting = true
            self.area:addGameObject('InfoText', self.x, self.y, {text = 'Luck Boost!'})
        end
    end)

    if self.increased_luck_while_boosting then 
        self.luck_boosting = true
        self.luck_multiplier = self.luck_multiplier*2
        self:generateChances()
    end
end

function Player:onBoostEnd()
    self.timer:cancel('launch_homing_projectile_while_boosting_chance')
    self.timer:cancel('increased_cycle_speed_while_boosting_chance')
    self.timer:cancel('invulnerability_while_boosting_chance')
    self.timer:cancel('increased_luck_while_boosting_chance')

    if self.increased_luck_while_boosting and self.luck_boosting then
        self.timer:after(5*self.stat_boost_duration_multiplier, function() self.increased_luck_while_boosting = false end)
    	self.luck_boosting = false
    	self.luck_multiplier = self.luck_multiplier/2
    	self:generateChances()
    end
end

function Player:onDeath()
    if self.gain_sp_on_death then
        addSp(20)
        self.area:addGameObject('InfoText', self.x, self.y, {text = '20 SP Gained!', color = faded_skill_point_color})
    end
end

function Player:passives()
    self.timer:every(0.5, function()
        if self.chances.drop_mines_chance:next() then
            self.mine_projectile = true
            self.area:addGameObject('InfoText', self.x, self.y, {text = 'Mine Dropped!', color = faded_skill_point_color})
            self.timer:after(0.3, function() self.mine_projectile = false end)
        end
    end)

    if self.change_attack_periodically then
        self.timer:every(10, function()
            local random_attack = table.random(change_attack)
            self:setAttack(random_attack)
            self.area:addGameObject('InfoText', self.x, self.y, {text = 'Attack Changed!', color = default_color})
        end)
    end

end
