game = {}

-- game init 
function game:init(debug)
    game.debug = debug
    
    -- stat trackers
    game.score = 0
    game.health = 10
    game.playing = true
    game.wave = 1
    game.wave_active = true
    game.wave_length = 31
    game.rest_length = 11

    -- get font for text 
    game.font = love.graphics.newFont("assets/fonts/PixelOperator8.ttf", 30)

    -- get relative game time
    game.start = love.timer.getTime()
    game.time = love.timer.getTime() - self.start
end 

-- game update
function game:update(dt)
    self.time = love.timer.getTime() - self.start
    if self.time >= self.wave_length and self.wave_active then 
        self.start = love.timer.getTime()
        self.time = self.start
        self.wave = self.wave + 1
        self.wave_active = false
    elseif self.time >= self.rest_length and not self.wave_active then 
        self.start = love.timer.getTime()
        self.time = self.start
        self.wave_active = true
    end
    if self.health <= 0 then 
        love.event.quit(0)
    end
end

-- game draw
function game:draw()
    -- draw stats
    local score_tracker = "Score: " .. game.score
    love.graphics.print(score_tracker, game.font, 10, 10)
    local health_tracker = "Health: " .. game.health 
    love.graphics.print(health_tracker, game.font, 560, 10)
    -- format time and draw
    local time_tracker
    if game.wave_active then 
        time_tracker = string.format("%02.0f", math.floor(self.time % 60))
    else
        time_tracker = string.format("%02.0f", math.floor(-1 * ((self.time % 60) - self.rest_length)))
    end 
    love.graphics.print(time_tracker, game.font, 375, 50)
    -- draw wave counter 
    local wave_tracker
    if game.wave_active then 
        wave_tracker = string.format("Wave %d", game.wave)
        love.graphics.print(wave_tracker, game.font, 320, 10)
    else 
        wave_tracker = "Prepare"
        love.graphics.print(wave_tracker, game.font, 310, 10)
    end
end 

-- add score if ballon is hit
function game:success_check(x, y, button, shoot, pointer, ballons)
    if button == 1 and shoot.current_ammo >= 0 then
        pointer.shooting = true
        local hit_ballon = false
        for i, v in ipairs(ballons.list) do
            if pointer:check_shot(v, shoot.current_ammo) and not hit_ballon then 
                table.remove(ballons.list, i)
                self.score = self.score + 1
                hit_ballon = true
            end
        end
        table.remove(shoot.darts, shoot.current_ammo)
        shoot.current_ammo = shoot.current_ammo - 1
        hit_ballon = false
    end
end