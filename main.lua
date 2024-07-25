function love.load()
    -- debug, should be true unless
    debug = true

    -- track game state
    state = "menu"

    -- imports 
    anim8 = require "libraries/anim8"
    require("src/ballons")
    require("src/pointer")
    require("src/shoot")
    require("src/game")
    require("src/menu")
    
    -- set window and resolution settings
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setMode(800, 600)
    love.window.setTitle("Target Practice (Pre-Pre-Pre-Alpha)")
    background = love.graphics.newImage("assets/sprites/background.png")

    -- init objects 
    ballons:init(debug) 
    pointer:init(debug)
    shoot:init(debug)
    game:init(debug)
    menu:init(debug)
end 

function love.update(dt)
    if game:get_state() == "game" then 
        -- update ballons
        ballons:update(dt, game.wave_active, game)
        -- update shooter
        shoot:update(dt)
        -- quit game if player loses 
        game:update(dt)
    elseif game:get_state() == "exit" then 
        love.event.quit(0)
    end 
    -- update pointer
    pointer:update(dt)
end

function love.draw()
    love.graphics.draw(background, 0, 0)
    if game:get_state() == "game" then
        -- draw ballons
        ballons:draw()
        -- draw shoot UI
        shoot:draw()
        -- draw gui
        game:draw()
    elseif game:get_state() == "menu" then 
        menu:draw()
    end 
    -- draw the pointer above everything
    pointer:draw()
end 

-- shoot! do they score?
function love.mousepressed(x, y, button)
    if game:get_state() == "game" then 
        game:success_check(x, y, button, shoot, pointer, ballons)
    elseif game:get_state() == "menu" then 
        menu:goto_game(x, y, button, game)
        menu:exit_game(x, y, button, game)
    end
    pointer:play_sound("hit")
end