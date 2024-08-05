-- main menu
main_menu = menu:new() 

function main_menu:init(debug)
    menu:init(debug) 

    -- title
    main_menu.title = {}
    main_menu.title.sprite = love.graphics.newImage("assets/sprites/title.png")
    main_menu.title.scale = 1.45
    main_menu.title.x = (gameWidth / 2) - (main_menu.title.sprite:getWidth() * main_menu.title.scale / 2)
    main_menu.title.y = 10

    -- buttons
    main_menu.buttons = {}
    main_menu.buttons.play = main_menu:create_button("game", gameWidth / 2, gameHeight * 0.25, "assets/sprites/play.png", 1.3)
    main_menu.buttons.exit = main_menu:create_button("exit", gameWidth / 2, gameHeight * 0.4, "assets/sprites/exit.png", 1.3)

    main_menu.text = ""
    main_menu.font = love.graphics.newFont("assets/fonts/PixelOperator8.ttf", 30)
end 

function main_menu:draw()
    for k, v in pairs(self.buttons) do 
        love.graphics.draw(v.sprite, v.x, v.y, nil, v.scale)
    end 
    love.graphics.draw(self.title.sprite, self.title.x, self.title.y, nil, self.title.scale)
end 