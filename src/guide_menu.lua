-- post game menu
guide_menu = menu:new() 

function guide_menu:init(debug)
    menu:init(debug)

    -- buttons
    guide_menu.buttons = {}
    guide_menu.buttons.back = options_menu:create_button("main", gameWidth / 2, gameHeight * 0.95, "assets/sprites/back.png", 1)

    -- main page
    guide_menu.page = {}
    guide_menu.page.sprite = love.graphics.newImage("assets/sprites/guide_page.png")

    guide_menu.page.guideOne = love.graphics.newImage("assets/sprites/guide-1-sprite.png")
    guide_menu.page.guideTwo = love.graphics.newImage("assets/sprites/guide-2-sprite.png")
    guide_menu.page.guideThree = love.graphics.newImage("assets/sprites/guide-3-sprite.png")

    -- font
    guide_menu.font = love.graphics.newFont("assets/fonts/PixelOperator8.ttf", 30)
    guide_menu.font_title = love.graphics.newFont("assets/fonts/PixelOperator8.ttf", 50)
    guide_menu.scores = {}
end 


function guide_menu:draw()
    for k, v in pairs(self.buttons) do 
        love.graphics.draw(v.sprite, v.x, v.y, nil, v.scale)
    end 
    love.graphics.draw(self.page.sprite, 0, 0)
    love.graphics.setLineWidth(3)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", gameWidth * 0.038 - 1, gameHeight * 0.18, self.page.guideOne:getWidth() * 0.25 + 1, self.page.guideOne:getHeight() * 0.25)
    love.graphics.rectangle("line", gameWidth * 0.36, gameHeight * 0.18, self.page.guideTwo:getWidth() * 0.3 + 1, self.page.guideTwo:getHeight() * 0.3)
    love.graphics.rectangle("line", gameWidth * 0.7, gameHeight * 0.18, self.page.guideThree:getWidth() * 0.25, self.page.guideThree:getHeight() * 0.25 + 1)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(self.page.guideOne, gameWidth * 0.038, gameHeight * 0.18, nil, 0.25)
    love.graphics.draw(self.page.guideTwo, gameWidth * 0.36, gameHeight * 0.18, nil, 0.3)
    love.graphics.draw(self.page.guideThree, gameWidth * 0.7, gameHeight * 0.18, nil, 0.25)
    
end 