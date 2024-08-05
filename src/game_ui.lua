game_ui = {}


function game_ui:init(g_)
    game_ui.game = g_
    game_ui.health_sprite = love.graphics.newImage('assets/sprites/heart.png')
    game_ui.point_sprite = love.graphics.newImage('assets/sprites/point.png')
    game_ui.font = love.graphics.newFont("assets/fonts/PixelOperator8.ttf", 40)
    game_ui.s_font = love.graphics.newFont("assets/fonts/PixelOperator8.ttf", 20)
    game_ui.health_scale = 3
    game_ui.point_scale = 2.5
    game_ui.bar_length = gameWidth * 0.3

    -- charge bar 
    game_ui.c_empty_sprite = love.graphics.newImage('assets/sprites/special_symbol_empty.png')
    game_ui.c_filled_sprite = love.graphics.newImage('assets/sprites/special_symbol_filled.png')
    game_ui.c_charged_sprite = love.graphics.newImage('assets/sprites/special_symbol_charged.png')
    game_ui.c_scale = 1
    game_ui.c_width = game_ui.c_empty_sprite:getWidth() * game_ui.c_scale
end

function game_ui:draw()
    -- draw stats
    love.graphics.draw(self.health_sprite, gameWidth - self.health_sprite:getWidth() * self.health_scale * 0.925, 0, nil, self.health_scale)
    love.graphics.draw(self.point_sprite, 0, 0, nil, self.point_scale)
    love.graphics.print(self.game.score, self.font, self.point_sprite:getWidth() * self.point_scale, self.point_sprite:getWidth() * self.point_scale * 0.25)
    if self.game.health > 9 then 
        love.graphics.printf(self.game.health, self.font, 
                        gameWidth - self.health_sprite:getWidth() * self.health_scale * 1.7, 
                        self.health_sprite:getWidth() * self.health_scale * 0.215, self.health_sprite:getWidth() * self.health_scale, "center")
    else 
        love.graphics.print(self.game.health, self.font, 
                        gameWidth - self.health_sprite:getWidth() * self.health_scale * 1.225, 
                        self.health_sprite:getWidth() * self.health_scale * 0.215)
    end 
    -- format time and draw
    -- local time_tracker
    -- if self.game.wave_active then 
    --     local clock_time = math.floor(self.game.time % 60)
    --     if clock_time ~= 0 then 
    --         time_tracker = string.format("%02.0f", math.floor(self.game.time % 60))
    --     else
    --         time_tracker = string.format("Go")
    --     end 
    -- else
    --     time_tracker = string.format("%02.0f", math.floor(-1 * ((self.game.time % 60) - self.game.rest_length)))
    -- end 
    --love.graphics.print(time_tracker, self.game.font, 375, 50)
    love.graphics.setColor(1, (1 - self.game.time_remaining * 0.75), (1 - self.game.time_remaining * 0.75))
    love.graphics.rectangle("fill", gameWidth * 0.35, gameHeight * 0.08, game_ui.bar_length * (1 - self.game.time_remaining), gameHeight * 0.025)
    love.graphics.setColor(0, 0, 0)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle("line", gameWidth * 0.35, gameHeight * 0.08, game_ui.bar_length, gameHeight * 0.025)
    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineWidth(1)

    -- draw charge 
    local total_charge_length = gameWidth * 0.3
    local charge_bar_start = gameWidth * 0.5 - total_charge_length * 0.5
    local dist_between_symbols = total_charge_length / (self.game.total_charge - 1)
    for i=1, self.game.total_charge do 
        love.graphics.draw(self.c_empty_sprite, charge_bar_start + (i - 1) * dist_between_symbols - self.c_width / 2, gameHeight * 0.125, nil, game_ui.c_scale)
    end 
    for i=1, self.game.charge do 
        local sprite = self.c_filled_sprite
        if self.game.charge == self.game.total_charge then 
            sprite = self.c_charged_sprite
        end 
        love.graphics.draw(sprite, charge_bar_start + (i - 1) * dist_between_symbols - self.c_width / 2, gameHeight * 0.125, nil, game_ui.c_scale)
    end 
   

    -- draw title message
    local wave_tracker
    if self.game.wave_active then 
        wave_tracker = string.format("Level %d", self.game.wave)
    elseif not self.game.buff_selected then 
        if self.game.buff_msg == 1 then wave_tracker = "Select buff!" end
        if self.game.buff_msg == 2 then wave_tracker = "Your choice..." end 
        if self.game.buff_msg == 3 then wave_tracker = "This or that?" end
    else 
        if self.game.wait_msg == 1 then wave_tracker = "Good choice!" end 
        if self.game.wait_msg == 2 then wave_tracker = "Interesting..." end
        if self.game.wait_msg == 3 then wave_tracker = "Oh?" end
    end 
    love.graphics.printf(wave_tracker, self.game.font, 0, gameHeight * 0.0166, gameWidth, "center")
    -- draw buffs
    self.game.buff_ui:draw()
end 