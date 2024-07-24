function love.load()
    -- debug, should be true unless
    debug = true

    -- imports 
    anim8 = require "libraries/anim8"
    require("src/ballons")
    require("src/pointer")
    require("src/shoot")
    require("src/game")

    -- fix pixel scaling
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- init objects 
    ballons:init(debug) 
    pointer:init(debug)
    shoot:init(debug)
    game:init(debug)
   
    -- set window settings and background
    love.window.setMode(800, 600)
    love.window.setTitle("Target Practice (Pre-Pre-Pre-Alpha)")
    background = love.graphics.newImage("assets/sprites/background.png")
end 

function love.update(dt)
    -- update pointer
    pointer:update(dt)
    -- update ballons
    ballons:update(dt, game.wave_active)
    -- update shooter
    shoot:update(dt)
    -- quit game if player loses 
    game:update(dt)
    
end

function love.draw()
    -- draw background
    love.graphics.draw(background, 0, 0)
    -- draw ballons
    ballons:draw()
    -- draw shoot UI
    shoot:draw()
    -- draw gui
    game:draw()
    -- draw the pointer above everything
    pointer:draw()
end 

-- shoot! do they score?
function love.mousepressed(x, y, button)
    game:success_check(x, y, button, shoot, pointer, ballons)
end