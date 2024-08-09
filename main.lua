function love.load()
    -- debug, one day this will be false 
    debug = true

    -- randomize 
    math.randomseed(os.time())

    -- imports 
    anim8 = require("libraries/anim8")
    push = require("libraries/push")
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
    require("src/options_menu")
    require("src/guide_menu")
    require("src/score_menu")
    
    -- set window and resolution settings
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.window.setTitle("High Flying Rogue")
    background = love.graphics.newImage("assets/sprites/background.png")

    -- window bullshit 
    gameWidth, gameHeight = 800, 600 
    local windowWidth, windowHeight = gameWidth, gameHeight
    push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight)

    -- init objects 
    ballons:init(debug) 
    pointers = {}
    add_pointer()
    shoot:init(debug)
    buff_ui:init(debug)
    game:init(debug, "main", ballons, buff_ui)
    post_game_menu:init(debug, game)
    main_menu:init(debug)
    options_menu:init(debug)
    guide_menu:init(debug)
    game_ui:init(game)
    secondary:init(ballons, pointers, shoot, game)
    game:get_secondary_init(secondary)
    score_menu:init(debug, game)

    -- pop-up messages?
    pop_up_message = ""
    pop_up_font = love.graphics.newFont("assets/fonts/PixelOperator8.ttf", 50 )

    -- music
    music = {}
    music_volume = 0.1
    music.main = love.audio.newSource('assets/music/main-menu-music.mp3', 'stream')
    music.options = love.audio.newSource('assets/music/options-music.mp3', 'stream')
    music.guide = love.audio.newSource('assets/music/guide-music.mp3', 'stream')
    music.gameOne = love.audio.newSource('assets/music/game-music-3.mp3', 'stream')
    music.gameTwo = love.audio.newSource('assets/music/game-music-2.mp3', 'stream')
    music.gameThree = love.audio.newSource('assets/music/game-music-1.mp3', 'stream')
    music.pause = love.audio.newSource('assets/music/pause-music.mp3', 'stream')
    music.score = love.audio.newSource('assets/music/pause-music.mp3', 'stream')
    music.rest = love.audio.newSource('assets/music/rest-music.mp3', 'stream')
    music.post_game = love.audio.newSource('assets/music/post-game-music.mp3', 'stream')
    for k, v in pairs(music) do
        v:setVolume(music_volume)
        v:setLooping(true)
    end 
    current_track = ""
    current_game_stage = nil
    current_step = -1
end  

function music_toggle(on)
    for k, v in pairs(music) do 
        if on then 
            v:setVolume(music_volume)
        else
            v:setVolume(0)
        end
    end 
end 

function stop_music() 
    for k, v in pairs(music) do 
        v:pause()
        v:seek(0)
    end
end 

function love.update(dt)
    if current_track ~= game:get_state() and game:get_state() ~= "exit" then 
        if game:get_state() ~= "game" then
            stop_music() 
            current_track = game:get_state()
            music[current_track]:play()
        else
            current_track = "game"
        end
    end 
    if current_track == "game" and game:get_state() ~= "exit" then 
        if current_game_stage ~= game.stage then 
            stop_music() 
            current_game_stage = game.stage 
            if current_game_stage == 'play' then 
                if game.step == 0 then music['gameOne']:play() 
                elseif game.step == 1 then music['gameTwo']:play()
                elseif game.step == 2 then music['gameThree']:play() end 
            elseif current_game_stage == 'rest' then 
                music['rest']:play()
            elseif current_game_stage == 'paused' then 
                music['pause']:play()
            end 
        end 
    end 

    if game:get_state() == "main" then 
        background = love.graphics.newImage("assets/sprites/background.png")
    end 
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
    elseif game:get_state() == "post_game" or game:get_state() == "options" or game:get_state() == "guide" or game:get_state() == "score" then 
        background = love.graphics.newImage("assets/sprites/background_post.png")  
    end 
    if game:get_state() == "post_game" then 
        secondary:reset()
    end 
    if game:get_state() == "guide" then 
        guide_menu:update(dt)
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
    push:start()
    love.graphics.draw(background, 0, 0)
    if game:get_state() == "game" then
        if secondary.ability.name == "blackhole_sec" then 
            secondary:draw()
        end 
        -- draw ballons
        ballons:draw()
        -- draw shoot UI
        shoot:draw()
        -- draw gui
        game_ui:draw()
        -- get secondary
        if secondary.ability.name ~= "blackhole_sec" then secondary:draw() end 
        -- print pop-up
        love.graphics.printf(pop_up_message, pop_up_font, 0, gameHeight * 0.4, gameWidth, "center")
        -- game paused function 
        game:draw()
    elseif game:get_state() == "main" then 
        main_menu:draw()
    elseif game:get_state() == "post_game" then 
        post_game_menu:draw()
    elseif game:get_state() == "options" then 
        options_menu:draw()
    elseif game:get_state() == "guide" then 
        guide_menu:draw()
    elseif game:get_state() == "score" then 
        score_menu:draw() 
    end 
    -- draw the pointer above everything
    for i, v in ipairs(pointers) do 
        v:draw()
    end 
    push:finish()
end 

-- shoot! do they score?
function love.mousepressed(x, y, button)
    if game:get_state() == "game" then 
        game:success_check(x, y, button, shoot, pointers, ballons)
        secondary:activate(button)
        game:goToMenu(x, y, button)
        if button == 1 then 
            if not game.paused then 
                pointers[1]:play_sound(shoot)
            else 
                pointers[1]:play_sound(shoot, "select")
            end 
        end 
    elseif game:get_state() == "main" then 
        main_menu:use_menu(x, y, button, game)
        if button == 1 then 
            pointers[1]:play_sound(shoot, "select")
        end 
    elseif game:get_state() == "post_game" then 
        post_game_menu:use_menu(x, y, button, game)
        if button == 1 then 
            pointers[1]:play_sound(shoot, "select")
            score_menu:get_scores() 
        end 
    elseif game:get_state() == "options" then 
        options_menu:use_menu(x, y, button, game)
        if button == 1 then 
            pointers[1]:play_sound(shoot, "select")
        end 
    elseif game:get_state() == "guide" then 
        guide_menu:use_menu(x, y, button, game)
        if button == 1 then 
            pointers[1]:play_sound(shoot, "select")
        end 
    elseif game:get_state() == "score" then
        score_menu:use_menu(x, y, button, game)
    end 
   
end

function add_pointer() 
    table.insert(pointers, pointer:init(debug))
end 