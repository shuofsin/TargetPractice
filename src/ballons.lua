ballons = {}


-- initilize list of ballons
function ballons:init(debug)
    -- get the ballon object(s)
    require("src/ballon")
    require("src/red_ballon")
    require("src/blue_ballon")
    require("src/green_ballon")
    require("src/health_ballon")
    require("src/point_ballon")
    require("src/reload_boost_ballon")
    require("src/ammo_boost_ballon")
    require("src/multishot_ballon")
    require("src/portal_ballon")
    require("src/ghost_ballon")
    require("src/spiral_ballon")
    require("src/speed_ballon")
    require("src/sheild_ballon")
    require("src/pop")

    ballons.sounds = {}
    ballons.list = {} 
    ballons.sheild_list = {}
    ballons.speed_list = {}
    ballons.pop_list = {}
    ballons.debug = debug
end 

-- update ballons 
function ballons:update(dt, game)
    -- move the ballon upwards and remove if off-screen
    for i, v in ipairs(self.list) do 
        v:update(dt)
        if v.y + v.sprite:getHeight() * v.scale < 0 then 
            ballons:remove_ballon(i)
            game:add_health(-1)
        end
    end
    
    -- render pops
    for i,v in ipairs(self.pop_list) do 
        v:update(dt)
        if v:is_over() then 
            table.remove(self.pop_list, i)
            v = nil 
        end
    end 

    -- apply buffs to ballons
    self:apply_buffs()
end 

-- apply buffs
function ballons:apply_buffs()
    for i, v in ipairs(self.list) do
        v.is_sheilded = ballons:check_sheilded(v)
    end 
end 

function ballons:check_sheilded(ballon) 
    for i, v in ipairs(self.sheild_list) do 
        local x = v.x + v.sprite:getHeight() * v.scale / 2
        local y = v.y + v.sprite:getHeight() * v.scale / 2
        local rad = v.effect.sprite:getHeight() * v.scale * v.effect.rad / 2
        if not ballon.is_not_sheildable then 
            local center_x, center_y
            local width = ballon.sprite:getWidth() * ballon.scale 
            if ballon.num_frames then 
                width = width / ballon.num_frames
            end 
            center_x = ballon.x + (width) / 2
            center_y = ballon.x + (width) / 2.5

            if center_x < x + rad and center_x > x - rad and center_y < y + rad and center_y > y - rad then 
                return true
            end
        end 
    end 
    return false
end 

-- add ballon to list
function ballons:add_ballon(b_type, is_bonus, pos)
    if is_bonus then 
        self.list[#self.list + 1] = ballons:create_ballon(b_type, pos)
    else 
        table.insert(self.list, 0, ballons:create_ballon(b_type))
    end 
end 

-- add a new ballon at a position 
function ballons:add_ballon_at_pos(b_type, x_pos, y_pos)
    table.insert(self.list, 0, ballons:create_ballon(b_type, x_pos, y_pos))
end 

-- draw ballons
function ballons:draw()
    -- render pops and ballons based on y order
    local master_table = ballons:combine_lists(self.list, self.pop_list)
    for i, v in ipairs(master_table) do 
        v:draw()
    end 
end 

-- delete ballons 
function ballons:clear()
    for i, v in ipairs(self.list) do 
        ballons:destroy_ballon(i)
    end 
    self.list = {}
end 

-- delete a ballon
function ballons:remove_ballon(i) 
    self.list[i]:remove()
    table.remove(self.list, i)
end

-- destroy a ballon
function ballons:destroy_ballon(i)
    local pop = ballons:create_pop(i)
    local effect = self.list[i]:destroy()
    table.remove(self.list, i)
    return effect
end

function ballons:create_pop(i)
    local x_, y_, scale_, color_, num_frames, width = self.list[i]:get_info()
    new_pop = pop:new() 
    new_pop:init(x_, y_, scale_, color_, num_frames, width)
    self.pop_list[#self.pop_list + 1] = new_pop
    return true
end 

-- generate a ballon 
function ballons:create_ballon(b_type, x_pos, y_pos)
    new_ballon = {}
    if b_type == "red" then 
        new_ballon = red_ballon:new()
    elseif b_type == "blue" then 
        new_ballon = blue_ballon:new() 
    elseif b_type == "green" then 
        new_ballon = green_ballon:new() 
    elseif b_type == "health" then
        new_ballon = health_ballon:new()
    elseif b_type == "point" then 
        new_ballon = point_ballon:new()
    elseif b_type == "reload_boost" then 
        new_ballon = reload_boost_ballon:new()
    elseif b_type == "ammo_boost" then 
        new_ballon = ammo_boost_ballon:new()
    elseif b_type == "multishot" then 
        new_ballon = multishot_ballon:new()
    elseif b_type == "portal" then 
        new_ballon = portal_ballon:new()
        new_ballon:get_ballons(self)
    elseif b_type == "ghost" then 
        new_ballon = ghost_ballon:new()
    elseif b_type == "spiral" then 
        new_ballon = spiral_ballon:new()
    elseif b_type == "sheild" then
        new_ballon = sheild_ballon:new() 
        self.sheild_list[#self.sheild_list + 1] = new_ballon
    elseif b_type == "speed" then 
        new_ballon = speed_ballon:new() 
        self.speed_list[#self.speed_list + 1] = new_ballon
    end 

    new_ballon:init() 

    if x_pos and x_pos < 1 then 
        new_ballon:set_x_pos_rel(x_pos) 
    elseif x_pos then  
        new_ballon:set_x_pos_abs(x_pos) 
    end 
    if y_pos and y_pos < 1 then 
        new_ballon:set_y_pos_rel(y_pos) 
    elseif y_pos then  
        new_ballon:set_y_pos_abs(y_pos) 
    end 
    return new_ballon
end

-- is empty
function ballons:is_empty() 
    return self.list == nil
end 

function ballons:combine_lists(t1, t2)
    new_table = {}
    speed_ballons = {}
    sheilded = {}
    not_sheilded = {}
    for i=1,#t1 do 
        if t1[i].is_speed_ballon then 
            speed_ballons[#speed_ballons + 1] = t1[i]
        elseif t1[i].is_sheilded then 
            sheilded[#sheilded+1] = t1[i]
        else 
            not_sheilded[#not_sheilded + 1] = t1[i]
        end
    end
    for i=1,#t2 do
        if t2[i].is_speed_ballon then 
            speed_ballons[#speed_ballons + 1] = t2[i]
        elseif t2[i].is_sheilded then 
            sheilded[#sheilded+1] = t2[i]
        else 
            not_sheilded[#not_sheilded + 1] = t2[i]
        end 
    end

    table.sort(speed_ballons, function(a, b) return a.y < b.y end)
    table.sort(sheilded, function(a, b) return a.y < b.y end)
    table.sort(not_sheilded, function(a, b) return a.y < b.y end)

    for i=1,#speed_ballons do
        new_table[#new_table + 1] = speed_ballons[i]
    end 
    for i=1,#sheilded do 
        new_table[#new_table + 1] = sheilded[i]
    end
    for i=1,#not_sheilded do 
        new_table[#new_table + 1] = not_sheilded[i]
    end
    return new_table
end 