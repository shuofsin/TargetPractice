game = {}

-- game init 
function game:init(debug, start_state, _ballons, _buff_ui)
    -- sounds 
    game.sounds = {}
    game.sounds.point = love.audio.newSource("assets/sounds/coin.wav", "static")
    game.sounds.point:setVolume(0.6)

    game.sounds.charge = love.audio.newSource("assets/sounds/charge.mp3", "static")
    game.sounds.charge:setVolume(0.1)
    game.sounds.charge:setPitch(0.8)

    game.sounds.gameover = love.audio.newSource("assets/sounds/lose-game.mp3", "static")
    game.sounds.gameover:setPitch(0.7)
    game.sounds.gameover:setVolume(0.8)

    game.sounds.restover = love.audio.newSource("assets/sounds/rest-over.mp3", "static")
    game.sounds.restover:setVolume(0.4)
    game.sounds.waveover = love.audio.newSource("assets/sounds/wave-over.mp3", "static")
    game.sounds.waveover:setVolume(0.4)
    
    -- few requires
    require("src/sec_explosion")
    require("src/sec_timeslow")
    require("src/sec_blackhole")
    require("src/secondary")

    game.debug = debug
    
    -- stat trackers
    game.score = 0
    game.prev_score = game.score
    game.starting_health = 3
    game.health = game.starting_health
    game.playing = true
    game.wave = 1
    game.wave_active = true
    game.wave_length = 61
    game.rest_length = 11

    -- get font for text 
    game.font = love.graphics.newFont("assets/fonts/PixelOperator8.ttf", 30)
    game.paused_font = love.graphics.newFont("assets/fonts/PixelOperator8.ttf", 70)


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
    game.spawn_table["point"] = 0
    game.spawn_table["health"] = 0
    game.spawn_table["child"] = 0


    -- buff spawn table 
    game.buff_table = {}
    game.buff_table["multishot"] = 1
    game.buff_table["ammo_boost"] = 1
    game.buff_table["reload_boost"] = 1
    game.buff_table["score_mult"] = 1
    game.buff_table["death_defiance"] = 0
    game.buff_table["timeslow_sec"] = 0
    game.buff_table["explosion_sec"] = 0
    game.buff_table["blackhole_sec"] = 0

    game.buff_msg, game.wait_msg = game:get_rand_msg() 

    -- other stuff
    game.buff_selected = false
    game.score_mult = 1
    game.death_defiance = 0

    -- secondary stuff 
    game.charge = 0
    game.total_charge = 5
    game.num_pointers = 1
    game.paused = false

    game.step = 0
    game.stage = "play"
end 

function game:get_secondary_init(secondary)
    game.secondary = secondary
    game.total_charge = secondary.ability.charge
    game.buff_ui:remove_sec()
    game.buff_ui:add_buff(game.secondary.ability.name)
end 

-- game update
function game:update(dt)
    if not game.paused then 
        game:wave_update(dt)
        if game.wave_active then 
            game:spawn_ballons(dt) 
            self.stage = 'play'
        else
            self.stage = 'rest'
        end 
        game.buff_ui:update(dt)
    else 
        game.start = game.start + dt
        game.time = game.time + dt
        self.stage = "paused"
    end 
end

function game:draw() 
    if game.paused then 
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle("fill", 0, 0, gameWidth, gameHeight)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Paused", self.paused_font, 0, gameHeight * 0.4, gameWidth, "center")
        love.graphics.printf("Give up", self.font, 0, gameHeight * 0.6, gameWidth, "center")
    end 
end 

function game:goToMenu(x, y, button)
    if button == 1 and game.paused then 
        local min_x, min_y, max_x, max_y
        min_x = gameWidth * 0.4
        min_y = gameHeight * 0.6
        max_x = gameWidth * 0.4 + gameWidth * 0.2
        max_y = gameHeight * 0.6 + gameHeight * 0.05
        if x > min_x and x < max_x and y > min_y and y < max_y then 
            self:set_state("main")
            self:reset()
        end
    end 
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
    local b_1 = game:select_random_buff_ballon()
    local b_2 = game:select_random_buff_ballon()
    while b_2 == b_1 do
        b_2 = game:select_random_buff_ballon()
    end 
    game.ballons:add_ballon(b_1, true, 0.25)
    game.ballons:add_ballon(b_2, true, 0.75)
end 

-- increase spawn chance
function game:update_chance()
    if self.wave == 2 then 
        self.spawn_table["green"] = self.spawn_table["green"] + 1
        self.spawn_table["red"] = self.spawn_table["red"] + 1
    end 
    if self.wave == 3 then 
        self.spawn_table["blue"] = self.spawn_table["blue"] + 1
        self.spawn_table["red"] = self.spawn_table["red"] + 1
        self.buff_table["explosion_sec"] = self.buff_table["explosion_sec"] + 1
    end 
    if self.wave == 4 then 
        self.spawn_table["spiral"] = self.spawn_table["spiral"] + 1
        self.spawn_table["red"] = self.spawn_table["red"] + 1
    end 
    if self.wave == 5 then 
        self.spawn_table["child"] = self.spawn_table["child"] + 1
        self.spawn_table["red"] = self.spawn_table["red"] + 1
        self.buff_table["timeslow_sec"] = self.buff_table["timeslow_sec"] + 1
    end 
    if self.wave == 6 then 
        self.spawn_table["ghost"] = self.spawn_table["ghost"] + 1
        self.spawn_table["red"] = self.spawn_table["red"] + 1
    end 
    if self.wave == 7 then 
        self.spawn_table["portal"] = self.spawn_table["portal"] + 1
        self.spawn_table["green"] = self.spawn_table["green"] + 1
        self.buff_table["blackhole_sec"] = self.buff_table["blackhole_sec"] + 1
    end 
    if self.wave == 8 then 
        self.spawn_table["speed"] = self.spawn_table["speed"] + 1
        self.spawn_table["red"] = self.spawn_table["red"] + 1
    end 
    if self.wave == 9 then
        for k,v in pairs(self.spawn_table) do
            v = v + 10
        end
        self.spawn_table["health"] = 1
        self.spawn_table["point"] = 1
        self.buff_table["death_defiance"] = self.buff_table["death_defiance"] + 1
    end 
    if self.wave > 7 then
        self.spawn_chance = self.spawn_chance * 1.1
    end 

    if self.wave % 4 == 0 then
        self.step = (self.step + 1) % 3
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
            love.audio.stop()
            self.sounds.gameover:play()
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
    game.spawn_table["point"] = 0
    game.spawn_table["health"] = 0
    game.spawn_table["child"] = 0

    -- buff spawn table 
    game.buff_table = {}
    game.buff_table["multishot"] = 1
    game.buff_table["ammo_boost"] = 1
    game.buff_table["reload_boost"] = 1
    game.buff_table["score_mult"] = 1
    game.buff_table["death_defiance"] = 0
    game.buff_table["timeslow_sec"] = 0
    game.buff_table["explosion_sec"] = 0
    game.buff_table["blackhole_sec"] = 0
    

    -- other stuff
    game.buff_selected = false
    game.score_mult = 1
    game.death_defiance = 0

    -- secondary stuff 
    game.secondary = secondary:init(ballons, pointers, shoot, game)
    game.charge = 0
    game.total_charge = game.secondary.ability.charge

    -- reset pointers
    pointers = {}
    add_pointer()
    game.paused = false
    game.ballons:clear()
    game.buff_ui:clear()
    game.num_pointers = 1

    game.step = 0
    game.stage = "play"
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
        self:set_pointers(1)
        self.sounds.waveover:play()
    elseif self.time >= self.rest_length and not self.wave_active then 
        self.start = love.timer.getTime()
        self.time = self.start
        self.ballons:clear()
        game:update_chance()
        self.wave_active = true
        self.buff_selected = false
        self:set_pointers(self.num_pointers)
    elseif self.time >= (self.rest_length - 3) and not self.wave_active then 
        self.sounds.restover:play()
    end 
end 

function game:set_pointers(num)
    pointers = {}
    for i=1,num do
        add_pointer()
    end 
end 

-- add score if ballon is hit
function game:success_check(x, y, button, shoot, pointers, ballons)
    if button == 1 and shoot.current_ammo >= 0 and not game.paused then
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
    local x,y,width,height = v:getInfo()
    local score = math.ceil(v:get_value() * self.score_mult)
    if v:get_value() > 0 then game:add_score(score) end 
    local effect = ballons:destroy_ballon(i)
    if score > 0 then 
        local point = love.audio.newSource('assets/sounds/coin.wav', 'static')
        point:setVolume(0.1)
        point:play()
    end 
    if effect == "health" then 
        game:add_health(1)
    end
    if effect == "reload_boost" then
        shoot:boost_reload(0.65)
        self.buff_ui:add_buff(effect)
    end 
    if effect == "ammo_boost" then
        shoot:ammo_increase(2)
        self.buff_ui:add_buff(effect)
    end 
    if effect == "multishot" then 
        self.buff_ui:add_buff(effect)
        self.num_pointers = self.num_pointers + 2
    end 
    if effect == "score_mult" then 
        self.score_mult = self.score_mult * 1.2
        self.buff_ui:add_buff(effect)
    end 
    if effect == "death_defiance" then 
        self.death_defiance = self.death_defiance + 1
        self.buff_ui:add_buff(effect)
    end  
    if effect == "timeslow_sec" then 
        if self.secondary.ability.name ~= "timeslow_sec" then 
            local ballons, pointer, shoot, game = self.secondary:get_reference()
            self.secondary.ability = sec_timeslow:init(ballons, pointer, shoot, game)
            self.total_charge = self.secondary.ability.charge
            self.buff_ui:remove_sec()
            self.buff_ui:add_buff(effect)
            if self.charge > self.total_charge then self.charge = self.total_charge end
        else
            self.secondary.ability:level_up()
            self.buff_ui:add_buff(effect) 
        end 
    end 
    if effect == "explosion_sec" then 
        if self.secondary.ability.name ~= "explosion_sec" then 
            local ballons, pointer, shoot, game = self.secondary:get_reference()
            self.secondary.ability = sec_explosion:init(ballons, pointer, shoot, game)
            self.total_charge = self.secondary.ability.charge
            self.buff_ui:remove_sec()
            self.buff_ui:add_buff(effect)
            if self.charge > self.total_charge then self.charge = self.total_charge end
        else
            self.secondary.ability:level_up()
            self.buff_ui:add_buff(effect) 
        end 
    end 
    if effect == "blackhole_sec" then 
        if self.secondary.ability.name ~= "blackhole_sec" then 
            local ballons, pointer, shoot, game = self.secondary:get_reference()
            self.secondary.ability = sec_blackhole:init(ballons, pointer, shoot, game)
            self.total_charge = self.secondary.ability.charge
            self.buff_ui:remove_sec()
            self.buff_ui:add_buff(effect)
            if self.charge > self.total_charge then self.charge = self.total_charge end
        else
            self.secondary.ability:level_up()
            self.buff_ui:add_buff(effect) 
        end 
    end 
    if not self.wave_active then 
        ballons:clear()
        self.buff_selected = true
    end  

    if self.charge < self.total_charge and gain_charge then 
        self.charge = self.charge + 1
        if self.charge == self.total_charge then 
            self.sounds.charge:play()
        end 
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