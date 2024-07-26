game = {}

-- game init 
function game:init(debug, start_state, _ballons)
    game.debug = debug
    
    -- stat trackers
    game.score = 0
    game.health = 100000
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

    -- store game state 
    game.state = start_state

    -- get the ballon object to control the ballons
    game.ballons = _ballons 
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
        self.ballons:wave_update()
        self.wave_active = true
    end
    if self.health <= 0 then 
        self.state = "post_game"
    end
end

-- game draw
function game:draw()
    -- draw stats
    local score_tracker = "Score: " .. self.score
    love.graphics.print(score_tracker, self.font, 10, 10)
    local health_tracker = "Health: " .. self.health 
    love.graphics.print(health_tracker, self.font, 560, 10)
    -- format time and draw
    local time_tracker
    if self.wave_active then 
        time_tracker = string.format("%02.0f", math.floor(self.time % 60))
    else
        time_tracker = string.format("%02.0f", math.floor(-1 * ((self.time % 60) - self.rest_length)))
    end 
    love.graphics.print(time_tracker, self.font, 375, 50)
    -- draw wave counter 
    local wave_tracker
    if self.wave_active then 
        wave_tracker = string.format("Wave %d", self.wave)
        love.graphics.print(wave_tracker, self.font, 320, 10)
    else 
        wave_tracker = "Prepare"
        love.graphics.print(wave_tracker, self.font, 310, 10)
    end
end 

-- add score if ballon is hit
function game:success_check(x, y, button, shoot, pointer, ballons)
    if button == 1 and shoot.current_ammo >= 0 then
        pointer:set_shooting(true)
        local hit_ballon = false
        for i, v in ipairs(ballons.list) do
            if pointer:check_shot(v, shoot.current_ammo) and not hit_ballon then 
                self.score = self.score + v:get_value() 
                ballons:remove_ballon(i)
                hit_ballon = true
            end
        end
        shoot:remove_dart(shoot:get_current_ammo())
        hit_ballon = false
    end
end

-- get the state
function game:get_state()
    return self.state
end

-- set the state
function game:set_state(new_state)
    self.state = new_state
end 

-- get health
function game:add_health(val)
    if val then self.health = self.health + val end
end