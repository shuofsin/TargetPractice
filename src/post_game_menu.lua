-- post game menu
post_game_menu = menu:new() 

function post_game_menu:init(debug)
    menu:init(debug)

    -- buttons
    post_game_menu.buttons.play = menu:create_button("game", love.graphics.getWidth() / 2, love.graphics.getHeight() / 4, "assets/sprites/play.png", 1.3)
    post_game_menu.buttons.exit = menu:create_button("exit", love.graphics.getWidth() / 2, love.graphics.getHeight() / 2.5, "assets/sprites/exit.png", 1.3)
end 