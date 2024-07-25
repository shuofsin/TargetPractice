-- main menu
main_menu = menu:new() 

function main_menu:init(debug)
    menu:init(debug) 

    -- title
    main_menu.title = {}
    main_menu.title.sprite = love.graphics.newImage("assets/sprites/title.png")
    main_menu.title.scale = 1.45
    main_menu.title.x = (love.graphics.getWidth() / 2) - (main_menu.title.sprite:getWidth() * main_menu.title.scale / 2)
    main_menu.title.y = 10

    -- buttons
    main_menu.buttons.play = menu:create_button("game", love.graphics.getWidth() / 2, love.graphics.getHeight() / 4, "assets/sprites/play.png", 1.3)
    main_menu.buttons.exit = menu:create_button("exit", love.graphics.getWidth() / 2, love.graphics.getHeight() / 2.5, "assets/sprites/exit.png", 1.3)
end 

function main_menu:draw()
    menu:draw()
    love.graphics.draw(self.title.sprite, self.title.x, self.title.y, nil, self.title.scale)
end 