-- post game menu
options_menu = menu:new() 

function options_menu:init(debug, game)
    menu:init(debug)

    -- options title 
    options_menu.title = {}
    options_menu.title.sprite = love.graphics.newImage("assets/sprites/options_title.png")
    options_menu.title.scale = 1.45
    options_menu.title.x = (gameWidth / 2) - (options_menu.title.sprite:getWidth() * options_menu.title.scale / 2)
    options_menu.title.y = 10

    -- buttons
    options_menu.buttons = {}
    options_menu.buttons.back = options_menu:create_button("main", gameWidth / 2, gameHeight * 0.9, "assets/sprites/back.png", 1.3)

    -- options
    options_menu.options = {}
    options_menu.options.fullscreen = {option = "Fullscreen", value = false, i = 0}
    options_menu.options.sound = {option = "Sound", value = true, i = 1}

    -- font
    options_menu.font = love.graphics.newFont("assets/fonts/PixelOperator8.ttf", 30)
    options_menu.font_title = love.graphics.newFont("assets/fonts/PixelOperator8.ttf", 50)
    options_menu.scores = {}
end 

function options_menu:draw()
    for k, v in pairs(self.buttons) do 
        love.graphics.draw(v.sprite, v.x, v.y, nil, v.scale)
    end 
    for k, v in pairs(options_menu.options) do 
        love.graphics.printf(v.option, self.font, 0, gameHeight * 0.2 + v.i * gameHeight * 0.1, gameWidth * 0.5, "right")
        local r_type
        if v.value then r_type = "fill" else r_type = "line" end 
        love.graphics.rectangle(r_type, gameWidth * 0.6, gameHeight * 0.2 + v.i * gameHeight * 0.1, gameWidth * 0.035, gameWidth * 0.035)
    end 
    love.graphics.draw(self.title.sprite, self.title.x, self.title.y, nil, self.title.scale)
end 

function options_menu:use_menu(x, y, button, game)
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
        for k,v in pairs(options_menu.options) do 
            local min_x, min_y, max_x, max_y
            min_x = gameWidth * 0.6 
            min_y = gameHeight * 0.2 + v.i * gameHeight * 0.1
            max_x = min_x + gameWidth * 0.035 
            max_y = min_y + gameWidth * 0.035
            if x > min_x and x < max_x and y > min_y and y < max_y then 
                v.value = not v.value
                if v.option == "Fullscreen" then
                    push:switchFullscreen(gameWidth, gameHeight)
                end 
                if v.option == "Sound" then 
                    if v.value then love.audio.setVolume(1.0) else love.audio.setVolume(0) end
                end 
            end
        end 
    end
end