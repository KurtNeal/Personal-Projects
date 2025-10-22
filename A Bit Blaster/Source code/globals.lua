
default_color = {0.87, 0.87, 0.87, 0.87}
hp_color = {1, 0, 0, 1}
background_color = {0.063, 0.063, 0.063}
ammo_color = {0.482, 0.784, 0.643}
boost_color = {0.298, 0.765, 0.851}
skill_point_color = {1, 0.776, 0.365}
rock_color = {0.961, 0.306, 0.106, 1}
flame_color = {0.988, 0.545, 0.0706, 1}

-- Faded colors
faded_hp_color = {1, 0, 0, 0.8}
faded_ammo_color = {0.482, 0.784, 0.643, 0.8}
faded_boost_color = {0.298, 0.765, 0.851, 0.8}
faded_skill_point_color = {1, 0.776, 0.365, 0.8}

-- Skill tree colors
white = { 1, 1, 1, 1 }
dark = { 0.3765, 0.3765, 0.3765, 1 }
gray = { 0.6275, 0.6275, 0.6275, 1 }
red = { 0.8706, 0.1255, 0.1255, 1 }
green = { 0.1255, 0.8706, 0.1255, 1 }
blue = { 0.1255, 0.1255, 0.8706, 1 }
pink = { 0.8706, 0.1255, 0.8706, 1 }
brown = { 0.7529, 0.3765, 0.1255, 1 }
yellow = { 0.8706, 0.8706, 0.1255, 1 }
orange = { 0.8706, 0.5020, 0.1255, 1 }
bluegreen = { 0.8706, 0.5020, 0.1255, 1 }
purple = { 0.5020, 0.1255, 0.5020, 1 }

default_colors = {default_color, hp_color, background_color, ammo_color, boost_color, skill_point_color}
negative_colors = {
    {255-default_color[1], 255-default_color[2], 255-default_color[3]}, 
    {255-hp_color[1], 255-hp_color[2], 255-hp_color[3]}, 
    {255-ammo_color[1], 255-ammo_color[2], 255-ammo_color[3]}, 
    {255-boost_color[1], 255-boost_color[2], 255-boost_color[3]}, 
    {255-skill_point_color[1], 255-skill_point_color[2], 255-skill_point_color[3]}
}

all_colors = fn.append(default_colors, negative_colors)


attacks = {
    ['Neutral'] = {cooldown = 0.24, ammo = 0, abbreviation = 'N', color = default_color},
    ['Double'] = {cooldown = 0.32, ammo = 2, abbreviation = '2', color = ammo_color},
    ['Triple'] = {cooldown = 0.32, ammo = 3, abbreviation = '3', color = boost_color},
    ['Rapid'] = {cooldown = 0.12, ammo = 1, abbreviation = 'R', color = default_color},
    ['Spread'] = {cooldown = 0.16, ammo = 1, abbreviation = 'RS', color = default_color},
    ['Back'] = {cooldown = 0.32, ammo = 2, abbreviation = 'Ba', color = skill_point_color},
    ['Side'] = {cooldown = 0.32, ammo = 2, abbreviation = 'Si', color = boost_color},
    ['Homing'] = {cooldown = 0.56, ammo = 4, abbreviation = 'H', color = skill_point_color},
    ['Blast'] = {cooldown = 0.64, ammo = 6, abbreviation = 'W', color = default_color},
    ['Spin'] = {cooldown = 0.32, ammo = 2, abbreviation = 'Sp', color = hp_color},
    ['Flame'] = {cooldown = 0.048, ammo = 0.4, abbreviation = 'F', color = flame_color},
    ['Bounce'] = {cooldown = 0.32, ammo = 4, abbreviation = 'Bn', color = default_color},
    ['2Split'] = {cooldown = 0.32, ammo = 3, abbreviation = '2S', color = ammo_color},
    ['4Split'] = {cooldown = 0.4, ammo = 4, abbreviation = '4S', color = boost_color},
    ['Lightning'] = {cooldown = 0.2, ammo = 8, abbreviation = 'Li', color = default_color},
    ['Explode'] = {cooldown = 0.6, ammo = 4, abbreviation = 'E', color = hp_color},
}

change_attack = {
    "Double", "Triple", 
    "Rapid", "Spread", 
    "Back", "Side", 
    "Homing", "Blast", 
    "Spin", "Flame",
    "Bounce", "2Split",
    "4Split", "Lightning",
    "Explode"
}

enemies = {'Rock', 'Shooter', 'BigRock', 'Waver', 'Seeker', 'Orbitter', 'Roller', 'Rotator', 'Tanker'}

skill_points = 1000

-- Globals
bought_node_indexes = {1}
run = 1
device = 'Fighter'
unlocked_devices = {''}
classes = {}
max_tree_nodes = 80
spent_sp = 0
high_score = 0

-- BGM & EFX
-- Music
local music = ripple.newTag()

Menu = ripple.newSound(love.audio.newSource('resources/sounds/Main_menu.mp3', 'static'), {
    volume = 0.3,
    pitch = 3,
    loop = true,
    tags = {music}
})

Automation = ripple.newSound(love.audio.newSource('resources/sounds/Automation.mp3', 'static'), {
    volume = 0.3,
    pitch = 1,
    loop = true,
    tags = {music}
})

-- Sound Effects
local sfx = ripple.newTag()

Shoot = ripple.newSound(love.audio.newSource('resources/sounds/Shoot1.mp3', 'static'), {
    volume = 0.1,
    pitch = 5,
    loop = false,
    tags = {sfx}
})

Projectile_death = ripple.newSound(love.audio.newSource('resources/sounds/Projectile_death_SFX.mp3', 'static'), {
    volume = 0.02,
    loop = false,
    tags = {sfx}
})

Type = ripple.newSound(love.audio.newSource('resources/sounds/Typing_SFX.mp3', 'static'), {
    volume = 1,
    loop = false,
    tags = {sfx}
})

Enter = ripple.newSound(love.audio.newSource('resources/sounds/Enter_SFX.mp3', 'static'), {
    volume = 1,
    loop = false,
    tags = {sfx}
})

Exit = ripple.newSound(love.audio.newSource('resources/sounds/Exit.mp3', 'static'), {
    volume = 1,
    loop = false,
    tags = {sfx}
})

Delete = ripple.newSound(love.audio.newSource('resources/sounds/Delete_SFX.mp3', 'static'), {
    volume = 1,
    loop = false,
    tags = {sfx}
})

Switch = ripple.newSound(love.audio.newSource('resources/sounds/Switch.mp3', 'static'), {
    volume = 0.8,
    loop = false,
    tags = {sfx}
})

Line_click = ripple.newSound(love.audio.newSource('resources/sounds/Line_click.mp3', 'static'), {
    volume = 0.8,
    loop = false,
    tags = {sfx}
})

Cycle = ripple.newSound(love.audio.newSource('resources/sounds/Cycle.wav', 'static'), {
    volume = 0.2,
    pitch = 1,
    loop = false,
    tags = {sfx}
})

Hit = ripple.newSound(love.audio.newSource('resources/sounds/Hit.wav', 'static'), {
    volume = 0.15,
    pitch = 1,
    loop = false,
    tags = {sfx}
})

Hit2 = ripple.newSound(love.audio.newSource('resources/sounds/Hit.wav', 'static'), {
    volume = 0.3,
    pitch = 1,
    loop = false,
    tags = {sfx}
})

Shotgun = ripple.newSound(love.audio.newSource('resources/sounds/Shotgun.mp3', 'static'), {
    volume = 0.2,
    pitch = 1,
    loop = false,
    tags = {sfx}
})

Flame = ripple.newSound(love.audio.newSource('resources/sounds/Flame.mp3', 'static'), {
    volume = 0.25,
    pitch = 1,
    loop = false,
    tags = {sfx}
})

Ricochet = ripple.newSound(love.audio.newSource('resources/sounds/Ricochet.mp3', 'static'), {
    volume = 0.25,
    pitch = 1,
    loop = false,
    tags = {sfx}
})

Thunder = ripple.newSound(love.audio.newSource('resources/sounds/Thunder.mp3', 'static'), {
    volume = 0.20,
    pitch = 1,
    loop = false,
    tags = {sfx}
})

Explosion = ripple.newSound(love.audio.newSource('resources/sounds/Explosion.wav', 'static'), {
    volume = 0.7,
    pitch = 1,
    loop = false,
    tags = {sfx}
})

Game_over = ripple.newSound(love.audio.newSource('resources/sounds/Game_over.mp3', 'static'), {
    volume = 0.6,
    pitch = 1,
    loop = false,
    tags = {sfx}
})

Collect = ripple.newSound(love.audio.newSource('resources/sounds/Collect.mp3', 'static'), {
    volume = 0.2,
    pitch = 1,
    loop = false,
    tags = {sfx}
})

Infotext = ripple.newSound(love.audio.newSource('resources/sounds/Glitch.mp3', 'static'), {
    volume = 0.05,
    pitch = 1,
    loop = false,
    tags = {sfx}
})

local Enemy_sfx = ripple.newTag()


Enemy_death = ripple.newSound(love.audio.newSource('resources/sounds/Enemy_death.wav', 'static'), {
    volume = 0.08,
    pitch = 1,
    loop = false,
    tags = {Enemy_sfx}
})
