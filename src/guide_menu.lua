-- post game menu
guide_menu = menu:new() 

function guide_menu:init(debug)
    menu:init(debug)

    -- buttons
    guide_menu.buttons = {}
    guide_menu.buttons.back = options_menu:create_button("main", gameWidth / 2, gameHeight * 0.9, "assets/sprites/back.png", 1.3)

    -- main page
    guide_menu.page = {}
    guide_menu.page.sprite = love.graphics.newImage("assets/sprites/guide_page.png")

    -- font
    guide_menu.font = love.graphics.newFont("assets/fonts/PixelOperator8.ttf", 30)
    guide_menu.font_title = love.graphics.newFont("assets/fonts/PixelOperator8.ttf", 50)
    guide_menu.scores = {}
end 

function guide_menu:update(dt)
end 

function guide_menu:draw()
    for k, v in pairs(self.buttons) do 
        love.graphics.draw(v.sprite, v.x, v.y, nil, v.scale)
    end 
    love.graphics.draw(self.page.sprite, 0, 0)
end 