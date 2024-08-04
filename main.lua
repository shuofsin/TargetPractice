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
    require("src/pop")
    require("src/buff_ui")
    require("src/game_ui")
    require("src/secondary")
    
    -- set window and resolution settings
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setMode(800, 600)
    love.window.setTitle("Target Practice (Pre-Pre-Alpha)")
    background = love.graphics.newImage("assets/sprites/background.png")

    -- init objects 
    ballons:init(debug) 
    pointers = {}
    add_pointer()
    shoot:init(debug)
    buff_ui:init(debug)
    game:init(debug, "main", ballons, buff_ui)
    post_game_menu:init(debug, game)
    main_menu:init(debug)
    game_ui:init(game)
    secondary:init()

    -- pop-up messages?
    pop_up_message = ""
    pop_up_font = love.graphics.newFont("assets/fonts/PixelOperator8.ttf", 50 )
    win_w, win_h = love.graphics.getDimensions() 
    win_d = math.sqrt(win_w * win_w + win_h * win_h)
end 

function love.update(dt)
    if game:get_state() == "game" then 
        background = love.graphics.newImage("assets/sprites/background.png")
        -- update shooter
        shoot:update(dt)
        -- update game
        game:update(dt)
        -- get secondary ability
        secondary:update(dt)
    elseif game:get_state() == "exit" then 
        love.event.quit(0)
    elseif game:get_state() == "post_game" then 
        background = love.graphics.newImage("assets/sprites/background_post.png")  
    end 
    -- update pointer
    for i, v in ipairs(pointers) do 
        v:update(dt, i, #pointers)
    end 

    if pop_up_message ~= "" then 
        if not start_time then start_time = love.timer.getTime() end
        if love.timer.getTime() - start_time > 3 then 
            pop_up_message = ""
            start_time = nil
        end 
    end 
end

function love.draw()
    love.graphics.draw(background, 0, 0)
    if game:get_state() == "game" then
        -- draw ballons
        ballons:draw()
        -- draw shoot UI
        shoot:draw()
        -- draw gui
        game_ui:draw()
        -- get secondary
        secondary:draw()
        -- print pop-up
        love.graphics.printf(pop_up_message, pop_up_font, 0, win_h * 0.4, win_w, "center")
    elseif game:get_state() == "main" then 
        main_menu:draw()
    elseif game:get_state() == "post_game" then 
        post_game_menu:draw()
    end 
    -- draw the pointer above everything
    for i, v in ipairs(pointers) do 
        v:draw()
    end 
end 

-- shoot! do they score?
function love.mousepressed(x, y, button)
    if game:get_state() == "game" then 
        game:success_check(x, y, button, shoot, pointers, ballons)
        secondary:activate(button)
    elseif game:get_state() == "main" then 
        main_menu:use_menu(x, y, button, game)
    elseif game:get_state() == "post_game" then 
        post_game_menu:use_menu(x, y, button, game)
    end 
    pointers[1]:play_sound("hit")
end

function add_pointer() 
    table.insert(pointers, pointer:init(debug))
end 