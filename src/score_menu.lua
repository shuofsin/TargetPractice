-- post game menu
score_menu = menu:new() 

function score_menu:init(debug, game)
    menu:init(debug)

    -- buttons
    score_menu.buttons = {} 
    score_menu.buttons.back = score_menu:create_button("main", gameWidth / 2, gameHeight * 0.95, "assets/sprites/back.png", 1.3)

    -- font
    score_menu.font = love.graphics.newFont("assets/fonts/PixelOperator8.ttf", 30)
    score_menu.font_title = love.graphics.newFont("assets/fonts/PixelOperator8.ttf", 60)
    score_menu.scores = {}
    score_menu:get_scores()

    -- text for the score
    score_menu.text = ""

    -- game object for saving scores
    score_menu.game = game

    score_menu.start = 1

    -- up and down button 
    score_menu.button_up = love.graphics.newImage("assets/sprites/arrow_up.png")
    score_menu.button_down = love.graphics.newImage("assets/sprites/arrow_down.png")
end 

function score_menu:draw()
    score_menu:draw_scores()
    for k, v in pairs(self.buttons) do 
        love.graphics.draw(v.sprite, v.x, v.y, nil, v.scale)
    end 
    if self.start > 1 then 
        love.graphics.draw(self.button_up, gameWidth / 2 - self.button_up:getWidth() * 1.5 / 2, gameHeight * 0.14, nil, 1.5) 
    end 
    if self.start + 9 < #self.scores then 
        love.graphics.draw(self.button_down, gameWidth / 2 - self.button_down:getWidth() * 1.5 / 2, gameHeight * 0.86, nil, 1.5) 
    end 
end 

function score_menu:get_scores() 
    self.scores = {}
    local file, err = io.open("scores.txt", 'r')
    if file then 
        while true do 
            local score_string = file:read()
            if score_string then 
                local table = score_menu:split(score_string, "#")
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

function score_menu:draw_scores()
    local new_font = love.graphics.newFont("assets/fonts/PixelOperator8.ttf", 50)
    love.graphics.printf("All Scores", self.font_title, 0, gameHeight * 0.03, gameWidth, "center")
    if #self.scores == 0 then 
        love.graphics.printf("No scores to display :(", self.font, 0, gameHeight * 0.45, gameWidth, "center")
    else 
        for i, v in ipairs(self.scores) do 
            if i >= self.start and i <= self.start + 9 then 
                love.graphics.print(v.name, self.font, gameWidth * 0.25, gameHeight * 0.125 + (i - self.start + 1) * 40)
                love.graphics.print(v.score, self.font, gameWidth * 0.55, gameHeight * 0.125 + (i - self.start + 1) * 40)
            end 
        end 
    end
end 

-- enter the game 
function score_menu:use_menu(x, y, button, game)
    if button == 1 then
        for k, v in pairs(self.buttons) do
            local min_x, min_y, max_x, max_y
            min_x = v.x 
            min_y = v.y
            max_x = min_x + v.sprite:getWidth() * v.scale 
            max_y = min_y + v.sprite:getHeight() * v.scale
            if x > min_x and x < max_x and y > min_y and y < max_y then 
                game:set_state(v.state)
            end
        end 
        local b1_min_x = gameWidth / 2 - self.button_up:getWidth() * 1.5 / 2
        local b1_min_y = gameHeight * 0.14
        local b1_max_x = b1_min_x + self.button_up:getWidth() * 1.5 
        local b1_max_y = b1_min_y + self.button_up:getHeight() * 1.5
        if x > b1_min_x and x < b1_max_x and y > b1_min_y and y < b1_max_y then 
            if self.start > 1 then 
                self.start = self.start - 1 
            end 
        end 

        local b2_min_x = gameWidth / 2 - self.button_down:getWidth() * 1.5 / 2
        local b2_min_y = gameHeight * 0.86
        local b2_max_x = b2_min_x + self.button_down:getWidth() * 1.5 
        local b2_max_y = b2_min_y + self.button_down:getHeight() * 1.5
        if x > b2_min_x and x < b2_max_x and y > b2_min_y and y < b2_max_y then 
            if self.start + 9 < #self.scores then 
                self.start = self.start + 1 
            end 
        end 
    end
    
end

function score_menu:split(inputstr, sep)
    sep = sep or "%s"
    local t = {}
    for word in inputstr:gmatch("([^" .. sep .. "]+)") do
        table.insert(t, word)
    end
    return t
end
