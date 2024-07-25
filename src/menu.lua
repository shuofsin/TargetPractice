menu = {}

function menu:init(debug) 
    -- debug
    menu.debug = debug

    -- title
    menu.title = {}
    menu.title.sprite = love.graphics.newImage("assets/sprites/title.png")
    menu.title.scale = 1.45
    menu.title.x = (love.graphics.getWidth() / 2) - (menu.title.sprite:getWidth() * menu.title.scale / 2)
    menu.title.y = 10

    -- buttons
    menu.play_button = {}
    menu.play_button.sprite = love.graphics.newImage("assets/sprites/play.png")
    menu.play_button.scale = 1.3
    menu.play_button.x = love.graphics.getWidth() / 2 - menu.play_button.sprite:getWidth() *  menu.play_button.scale / 2
    menu.play_button.y = love.graphics.getHeight() / 4 - menu.play_button.sprite:getHeight() *  menu.play_button.scale / 2

    menu.exit_button = {}
    menu.exit_button = {}
    menu.exit_button.sprite = love.graphics.newImage("assets/sprites/exit.png")
    menu.exit_button.scale = 1.3
    menu.exit_button.x = love.graphics.getWidth() / 2 - menu.exit_button.sprite:getWidth() *  menu.exit_button.scale / 2
    menu.exit_button.y = love.graphics.getHeight() / 2.5 - menu.exit_button.sprite:getHeight() *  menu.exit_button.scale / 2
    -- art
    menu.art = {} 
end 

function menu:draw()
    love.graphics.draw(self.title.sprite, self.title.x, self.title.y, nil, self.title.scale)
    love.graphics.draw(self.play_button.sprite, self.play_button.x, self.play_button.y, nil, self.play_button.scale)
    love.graphics.draw(self.exit_button.sprite, self.exit_button.x, self.exit_button.y, nil, self.exit_button.scale)
    -- menu:draw_play_button()
end 

-- enter the game 
function menu:goto_game(x, y, button, game)
    if button == 1 then
        local min_x, min_y, max_x, max_y
        min_x = self.play_button.x 
        min_y = self.play_button.y
        max_x = min_x + self.play_button.sprite:getWidth() * self.play_button.scale 
        max_y = min_y + self.play_button.sprite:getHeight() * self.play_button.scale
        if x > min_x and x < max_x and y > min_y and y < max_y then 
            game:set_state("game")
        end
    end
end

-- exit the game
function menu:exit_game(x, y, button, game)
    if button == 1 then
        local min_x, min_y, max_x, max_y
        min_x = self.exit_button.x 
        min_y = self.exit_button.y
        max_x = min_x + self.exit_button.sprite:getWidth() * self.exit_button.scale 
        max_y = min_y + self.exit_button.sprite:getHeight() * self.exit_button.scale
        if x > min_x and x < max_x and y > min_y and y < max_y then 
            game:set_state("exit")
        end
    end
end 

-- draw menu box
function menu:draw_play_button()
    love.graphics.setLineWidth(5)
    love.graphics.rectangle("line", self.play_button.x, self.play_button.y, self.play_button.sprite:getWidth(), self.play_button.sprite:getHeight())
end 