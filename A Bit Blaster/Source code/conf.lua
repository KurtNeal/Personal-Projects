gw = 480
gh = 270
sx = 1
sy = 1

function love.conf(t)
    t.identity = nil
    t.version = "11.3"
    t.console = false

    t.window.title = "A Bit Blaster"
    t.window.icon = nil
    t.window.width = gw
    t.window.height = gh
    t.window.borderless = false
    t.window.resizable = true
    t.window.minwidth = 480
    t.window.minheight = 270
    t.window.fullscreen = false
    t.window.fullscreentype = "exclusive"
    t.window.fsaa = 0
    t.window.vsync = true
    t.window.display = 1
    t.window.srgb = false
    t.window.highdpi = false
    t.window.x = nil
    t.window.y = nil

    t.modules.event = true
    t.modules.audio = true
    t.modules.sound = true
    t.modules.graphics = true
    t.modules.image = true
    t.modules.joystick = true
    t.modules.keyboard = true
    t.modules.mouse = true
    t.modules.math = true
    t.modules.physics = true
    t.modules.system = true
    t.modules.timer = true
    t.modules.window = true
    t.modules.thread = true
end