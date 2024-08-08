-- main menu
main_menu = menu:new() 

function main_menu:init(debug)
    menu:init(debug) 

    -- title
    main_menu.title = {}
    main_menu.title.sprite = love.graphics.newImage("assets/sprites/title.png")
    main_menu.title.scale = 1
    main_menu.title.x = (gameWidth / 2) - (main_menu.title.sprite:getWidth() * main_menu.title.scale / 2)
    main_menu.title.y = gameHeight * 0.06

    main_menu.credits = {}
    main_menu.credits.sprite = love.graphics.newImage("assets/sprites/bottom_banner.png")
    main_menu.credits.scale = 1
    main_menu.credits.x = gameWidth * 0
    main_menu.credits.y = gameHeight * 0.946667


    -- buttons
    main_menu.buttons = {}
    main_menu.buttons.play = main_menu:create_button("game", gameWidth / 2, gameHeight * 0.25, "assets/sprites/play.png", 1.3)
    main_menu.buttons.options = main_menu:create_button("options", gameWidth / 2, gameHeight * 0.4, "assets/sprites/options.png", 1.3)
    main_menu.buttons.guide = main_menu:create_button("guide", gameWidth / 2, gameHeight * 0.55, "assets/sprites/guide.png", 1.3)
    main_menu.buttons.exit = main_menu:create_button("exit", gameWidth / 2, gameHeight * 0.7, "assets/sprites/exit.png", 1.3)

    main_menu.text = ""
    main_menu.font = love.graphics.newFont("assets/fonts/PixelOperator8.ttf", 30)
end 

function main_menu:draw()
    for k, v in pairs(self.buttons) do 
        love.graphics.draw(v.sprite, v.x, v.y, nil, v.scale)
    end 
    love.graphics.draw(self.title.sprite, self.title.x, self.title.y, nil, self.title.scale)
    love.graphics.draw(self.credits.sprite, self.credits.x, self.credits.y, nil, self.credits.scale)

end 