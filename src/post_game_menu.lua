-- post game menu
post_game_menu = menu:new() 



function post_game_menu:init(debug)
    menu:init(debug)

    -- buttons
    post_game_menu.buttons.play = menu:create_button("game", love.graphics.getWidth() / 2, love.graphics.getHeight() * 0.4, "assets/sprites/play.png", 1.3)
    post_game_menu.buttons.exit = menu:create_button("exit", love.graphics.getWidth() / 2, love.graphics.getHeight() * 0.6, "assets/sprites/exit.png", 1.3)

    -- font
    post_game_menu.font = love.graphics.newFont("assets/fonts/PixelOperator8.ttf", 30)
    post_game_menu.scores = {}
    post_game_menu:get_scores()
end 

function post_game_menu:draw()
    post_game_menu:draw_scores()
    for k, v in pairs(self.buttons) do 
        love.graphics.draw(v.sprite, v.x, v.y, nil, v.scale)
    end 
end 

function post_game_menu:get_scores() 
    local file, err = io.open("scores.txt", 'r')
    if file then 
        while true do 
            local score = file:read()
            if score then 
                table.insert(self.scores, score)
            else 
                break
            end 
        end 
    else
        print("error: ", err)
    end
    table.sort(self.scores)
end 

function post_game_menu:draw_scores() 
    for i, v in ipairs(self.scores) do 
        if i <= 3 then
            love.graphics.print(v, self.font, love.graphics.getWidth() * 0.4, i * 40)
        end 
    end 
end 