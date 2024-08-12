-- post game menu
post_game_menu = menu:new() 

function post_game_menu:init(debug, game)
    menu:init(debug)

    -- buttons
    post_game_menu.buttons = {} 
    post_game_menu.buttons.play = post_game_menu:create_button("game", gameWidth / 2, gameHeight * 0.75, "assets/sprites/play-again.png", 1.3)
    post_game_menu.buttons.back = post_game_menu:create_button("main", gameWidth / 2, gameHeight * 0.9, "assets/sprites/back.png", 1.3)

    -- font
    post_game_menu.font = love.graphics.newFont("assets/fonts/PixelOperator8.ttf", 30)
    post_game_menu.font_title = love.graphics.newFont("assets/fonts/PixelOperator8.ttf", 50)
    post_game_menu.scores = {}
    post_game_menu:get_scores()

    -- text for the score
    post_game_menu.text = ""

    -- game object for saving scores
    post_game_menu.game = game
end 

function post_game_menu:draw()
    post_game_menu:draw_scores()
    for k, v in pairs(self.buttons) do 
        love.graphics.draw(v.sprite, v.x, v.y, nil, v.scale)
    end 
    love.graphics.printf("Enter name:", post_game_menu.font, 0, 70, gameWidth, "center")
    love.graphics.printf(("Final Score: " .. post_game_menu.game:get_prev_score()), post_game_menu.font_title, 0, 10, gameWidth, "center")
    love.graphics.printf(post_game_menu.text, post_game_menu.font, 0, gameHeight * 0.2, gameWidth, "center")
end 

function post_game_menu:get_scores() 
    self.scores = {}
    local file, err = io.open("scores.txt", 'r')
    if file then 
        while true do 
            local score_string = file:read()
            if score_string then 
                local table = post_game_menu:split(score_string, "#")
                local l_name = table[1]
                local l_score = table[2]
                self.scores[#self.scores + 1] = {name = l_name, score = tonumber(l_score)}
            else
                break
            end 
        end 
        file:close()
    else
        print("error: ", err)
    end
    table.sort(self.scores, function(a,b) return a.score > b.score end)
end 

function post_game_menu:draw_scores()
    local new_font = love.graphics.newFont("assets/fonts/PixelOperator8.ttf", 50)
    love.graphics.printf("High Scores!", new_font, 0, gameHeight * 0.3, gameWidth, "center")
    if #self.scores == 0 then 
        love.graphics.printf("No scores to display :(", self.font, 0, gameHeight * 0.3 + 70, gameWidth, "center")
    else 
        for i, v in ipairs(self.scores) do 
            if i <= 3 then 
                love.graphics.print(v.name, self.font, gameWidth * 0.3, gameHeight * 0.35 + i * 40)
                love.graphics.print(v.score, self.font, gameWidth * 0.6, gameHeight * 0.35 + i * 40)
            end 
        end 
    end
end 

function post_game_menu:split(inputstr, sep)
    sep = sep or "%s"
    local t = {}
    for word in inputstr:gmatch("([^" .. sep .. "]+)") do
        table.insert(t, word)
    end
    return t
end

function love.textinput(t)
    if string.len(post_game_menu.text) < 8 and t ~= "#" then 
        post_game_menu.text =  post_game_menu.text .. t
    end 
end 

function love.keypressed(key, scancode)
    if game:get_state() == "post_game" then
        local utf8 = require("utf8")
        if key == "backspace" then
            local byteoffset = utf8.offset(post_game_menu.text, -1)

            if byteoffset then
                post_game_menu.text = string.sub(post_game_menu.text, 1, byteoffset - 1)
            end
        end
        if key == "return" and string.len(post_game_menu.text) > 0 and post_game_menu.text ~= "Score saved!" then 
            post_game_menu.game:save_score(post_game_menu.text)
            post_game_menu.text = "Score saved!"
            post_game_menu:get_scores()
        end
    end 
    if game:get_state() == "game" then
        if scancode == "p" then 
            post_game_menu.game.paused = not post_game_menu.game.paused
        end 
    end 
end