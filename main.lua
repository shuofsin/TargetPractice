function love.load()
    -- debug, one day this will be false 
    debug = true

    -- randomize 
    math.randomseed(os.time())

    -- imports 
    anim8 = require("libraries/anim8")
    require("src/ballons")
    require("src/pointer")
    require("src/shoot")
    require("src/game")
    require("src/menu")
    require("src/main_menu")
    require("src/post_game_menu")
    
    -- set window and resolution settings
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setMode(800, 600)
    love.window.setTitle("Target Practice (Pre-Pre-Alpha)")
    background = love.graphics.newImage("assets/sprites/background.png")

    -- init objects 
    ballons:init(debug) 
    pointer:init(debug)
    shoot:init(debug)
    game:init(debug, "main", ballons)
    main_menu:init(debug)
    post_game_menu:init(debug)
end 

function love.update(dt)
    if game:get_state() == "game" then 
        -- update shooter
        shoot:update(dt)
        -- update game
        game:update(dt)
    elseif game:get_state() == "exit" then 
        love.event.quit(0)
    elseif game:get_state() == "main" then 
        -- debug main menu
        main_menu:update(dt)
    elseif game:get_state() == "post_game" then 
        post_game_menu:update(dt)    
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
    elseif game:get_state() == "main" then 
        main_menu:draw()
    elseif game:get_state() == "post_game" then 
        post_game_menu:draw()
    end 
    -- draw the pointer above everything
    pointer:draw()
end 

-- shoot! do they score?
function love.mousepressed(x, y, button)
    if game:get_state() == "game" then 
        game:success_check(x, y, button, shoot, pointer, ballons)
    elseif game:get_state() == "main" then 
        main_menu:use_menu(x, y, button, game)
    elseif game:get_state() == "post_game" then 
        post_game_menu:use_menu(x, y, button, game)
    end 
    pointer:play_sound("hit")
end