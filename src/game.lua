game = {}

-- game init 
function game:init(debug, start_state, _ballons, _buff_ui)
    game.debug = debug
    
    -- stat trackers
    game.score = 0
    game.prev_score = game.score
    game.starting_health = 5
    game.health = game.starting_health
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

    -- get the other objects to control the ballons
    game.ballons = _ballons 
    game.buff_ui = _buff_ui

    -- time remaining
    game.time_remaining = self.time / self.wave_length 

    -- spawn table
    game.spawn_chance = 20
    game.spawn_table = {}
    game.spawn_table["red"] = 1
    game.spawn_table["green"] = 0
    game.spawn_table["blue"] = 0
    game.spawn_table["portal"] = 0
    game.spawn_table["ghost"] = 0
    game.spawn_table["spiral"] = 0
    game.spawn_table["speed"] = 0

    -- buff spawn table 
    game.buff_table = {}
    game.buff_table["multishot"] = 1
    game.buff_table["ammo_boost"] = 1
    game.buff_table["reload_boost"] = 1
    game.buff_table["score_mult"] = 1
    game.buff_table["death_defiance"] = 1

    -- bonus table
    game.bonus_table = {}
    game.bonus_table["health"] = 1
    game.bonus_table["point"] = 1

    game.buff_msg, game.wait_msg = game:get_rand_msg() 

    -- other stuff
    game.buff_selected = false
    game.score_mult = 1
    game.death_defiance = 0

    -- secondary stuff 
    game.charge = 0
    game.total_charge = 5
end 

function game:set_secondary(secondary)
    game.secondary = secondary
    game.total_charge = secondary.ability.charge
    game.buff_ui:remove_sec()
    game.buff_ui:add_buff(game.secondary.ability.name)
end 

-- game update
function game:update(dt)
    game:wave_update(dt)
    if game.wave_active then 
        game:spawn_ballons(dt) 
    end
    game.buff_ui:update(dt)
end

-- reset time 
function game:reset_time()
    game.start = love.timer.getTime()
    game.time = love.timer.getTime() - self.start
end 

-- spawn ballons
function game:spawn_ballons(dt)
    local val = math.random(2000)
    if val < game.spawn_chance then 
        game:spawn_random_ballon()
    end 
end 

-- spawn random ballon
function game:spawn_random_ballon()
    game.ballons:add_ballon(game:select_random_ballon())
end

-- select a random ballon from the table 
function game:select_random_ballon()
    local total_weight = 0 
    for k, v in pairs(game.spawn_table) do
        total_weight = total_weight + v
    end 
    local b_type = ""
    local rand_val = math.random(1, total_weight)
    for k, v in pairs(game.spawn_table) do 
        rand_val = rand_val - v
        if rand_val <= 0 then 
            return k
        end 
    end 
    return "red"
end 

-- select random buff ballon
function game:select_random_buff_ballon()
    local total_weight = 0 
    for k, v in pairs(game.buff_table) do
        total_weight = total_weight + v
    end 
    local b_type = ""
    local rand_val = math.random(1, total_weight)
    for k, v in pairs(game.buff_table) do 
        rand_val = rand_val - v
        if rand_val <= 0 then 
            return k
        end 
    end 
    return "reload_bonus"
end 

function game:select_random_bonus_ballon()
    local total_weight = 0 
    for k, v in pairs(game.bonus_table) do
        total_weight = total_weight + v
    end 
    local b_type = ""
    local rand_val = math.random(1, total_weight)
    for k, v in pairs(game.bonus_table) do 
        rand_val = rand_val - v
        if rand_val <= 0 then 
            return k
        end 
    end 
    return "point"
end 

-- spawn bonus 
function game:spawn_bonus_ballons()
    if (game.wave - 1) % 3 == 0 then
        local b_1 = game:select_random_buff_ballon()
        local b_2 = game:select_random_buff_ballon()
        while b_2 == b_1 do
            b_2 = game:select_random_buff_ballon()
        end 
        game.ballons:add_ballon(b_1, true, 0.25)
        game.ballons:add_ballon(b_2, true, 0.75)
    else 
        game.ballons:add_ballon("point", true, 0.25)
        game.ballons:add_ballon("health", true, 0.75)
    end
end 

-- increase spawn chance
function game:update_chance()
    if self.wave == 19 then 
        game.spawn_table["speed"] = game.spawn_table["speed"] + 1
    end
    if self.wave == 16 then 
        game.spawn_table["portal"] = game.spawn_table["portal"] + 1
    end
    if self.wave == 13 then 
        game.spawn_table["ghost"] = game.spawn_table["ghost"] + 1
    end 
    if self.wave == 10 then 
        game.spawn_table["spiral"] = game.spawn_table["spiral"] + 1
    end 
    if self.wave == 7 then 
        game.spawn_table["blue"] = game.spawn_table["blue"] + 1
    end
    if self.wave == 4 then 
        game.spawn_table["green"] = game.spawn_table["green"] + 1
    end
    if (self.wave - 1) % 3 == 0 then 
        game.spawn_chance = game.spawn_chance * 1.1
        if self.wave > 4 then
            game.spawn_table["red"] = game.spawn_table["red"] + 1
        end
    end
end 

-- wave update 
function game:wave_update(dt)
    self.time = love.timer.getTime() - self.start
    ballons:update(dt, self)
    game:control_waves(dt)
    if self.health <= 0 then
        if self.death_defiance > 0 then 
            self.health = self.starting_health 
            self.death_defiance = self.death_defiance - 1
            self.buff_ui:remove_buff("death_defiance")
            pop_up_message = "SAVED!"
        else  
            game:reset()
            self.ballons:clear()
            self.state = "post_game"
        end 
    end
end 

-- reset game values
function game:reset()
    -- stat trackers
    game.prev_score = game.score
    game.score = 0
    game.health = self.starting_health
    game.playing = true
    game.wave = 1
    game.wave_active = true

    -- get relative game time
    game.start = love.timer.getTime()
    game.time = love.timer.getTime() - self.start

    game.spawn_table = {}
    game.spawn_table["red"] = 1
    game.spawn_table["green"] = 0
    game.spawn_table["blue"] = 0
    game.spawn_table["portal"] = 0
    game.spawn_table["ghost"] = 0
    game.spawn_table["spiral"] = 0
    game.spawn_table["speed"] = 0

    -- other stuff
    game.buff_selected = false
    game.score_mult = 1
    game.death_defiance = 0

    -- secondary stuff 
    game.charge = 0
    game.total_charge = game.secondary.ability.charge
end 

-- function control waves
function game:control_waves(dt)
    if self.wave_active then 
        self.time_remaining = self.time / self.wave_length 
    else 
        self.time_remaining = self.time / self.rest_length
    end 
    if self.time >= self.wave_length and self.wave_active then 
        self.start = love.timer.getTime()
        self.time = self.start
        self.wave = self.wave + 1
        self.ballons:clear()
        game:spawn_bonus_ballons()
        self.wave_active = false
        self.buff_msg, self.wait_msg = game:get_rand_msg() 
    elseif self.time >= self.rest_length and not self.wave_active then 
        self.start = love.timer.getTime()
        self.time = self.start
        game:update_chance()
        self.wave_active = true
        self.buff_selected = false
    end
end 

-- add score if ballon is hit
function game:success_check(x, y, button, shoot, pointers, ballons)
    if button == 1 and shoot.current_ammo >= 0 then
        pointer:set_shooting(true)
        for j, w in ipairs(pointers) do
            for i, v in ipairs(ballons.list) do
                if w:check_shot(v, shoot.current_ammo) then 
                    game:suceed(v, i, shoot, pointers, ballons, true)
                end
            end 
        end
        shoot:remove_dart(shoot:get_current_ammo())
    end
end

function game:suceed(v, i, shoot, pointers, ballons, gain_charge) 
    game:add_score(math.ceil(v:get_value() * self.score_mult))
    local effect = ballons:destroy_ballon(i)
    if effect == "health" then 
        game:add_health(1)
    end
    if effect == "reload_boost" then
        shoot:boost_reload(0.65)
        self.buff_ui:add_buff(effect)
    end 
    if effect == "ammo_boost" then
        shoot:ammo_increase(1)
        self.buff_ui:add_buff(effect)
    end 
    if effect == "multishot" then 
        add_pointer()
        self.buff_ui:add_buff(effect)
    end 
    if effect == "score_mult" then 
        self.score_mult = self.score_mult * 1.2
        self.buff_ui:add_buff(effect)
    end 
    if effect == "death_defiance" then 
        self.death_defiance = self.death_defiance + 1
        self.buff_ui:add_buff(effect)
    end 
    if not self.wave_active then 
        ballons:clear()
        self.buff_selected = true
    end  

    if self.charge < self.total_charge and gain_charge then 
        self.charge = self.charge + 1
    end 
end 

-- get the state
function game:get_state()
    return self.state
end

-- set the state
function game:set_state(new_state)
    self.state = new_state
    game:reset_time()
end 

-- get health
function game:add_health(val)
    if val then self.health = self.health + val end
end

-- add score
function game:add_score(score)
    if score then self.score = self.score + score end 
end 

-- add score
function game:get_score(score)
    return self.score
end 

function game:get_prev_score(score)
    return self.prev_score
end 

-- save score
function game:save_score(name)
    local file, err = io.open("scores.txt", 'a')
    local score_ = name .. "#" .. self.prev_score .. "\n"
    if file then 
        file:write(score_)
        file:close()
    else
        print("error: ", err)
    end 
end 

function game:get_rand_msg() 
    return math.random(3), math.random(3)
end 