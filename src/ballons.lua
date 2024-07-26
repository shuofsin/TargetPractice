ballons = {}

-- initilize list of ballons
function ballons:init(debug)
    -- get the ballon object(s)
    require("src/ballon")
    require("src/red_ballon")
    require("src/blue_ballon")
    require("src/green_ballon")
    require("src/health_ballon")

    ballons.sounds = {}
    ballons.chance = 5
    ballons.chance_increase = 1.25
    ballons.list = {} 
    ballons.debug = debug
end 

-- update ballons 
function ballons:update(dt, wave_active, game)
    -- move the ballon upwards and remove if off-screen
    for i, v in ipairs(self.list) do 
        v:update(dt)
        if v.y + v.sprite:getHeight() * v.scale < 0 then 
            ballons:remove_ballon(i)
            game:add_health(-1)
        end
    end
    -- spawn ballons if wave active 
    local spawn_ballon = math.random(2000)
    if spawn_ballon < self.chance and wave_active then 
        if spawn_ballon / self.chance >= 0.99 then 
            table.insert(self.list, 0, ballons:create_ballon("health"))
        elseif spawn_ballon / self.chance >= 0.9 then 
            table.insert(self.list, 0, ballons:create_ballon("blue"))
        elseif spawn_ballon / self.chance >= 0.7 then 
            table.insert(self.list, 0, ballons:create_ballon("green"))
        else 
            table.insert(self.list, 0, ballons:create_ballon("red"))
        end 
    end
    -- remove ballons if wave over 
    if not wave_active then 
        self.list = {}
    end 
end 

-- draw ballons
function ballons:draw() 
    for i = #self.list, 1, -1 do 
        local v = self.list[i]
        love.graphics.draw(v.sprite, v.x, v.y, nil, v.scale)
    end 
end 

-- delete ballons 
function ballons:clear()
    self.list = {}
end 

-- delete a ballon
function ballons:remove_ballon(i) 
    self.list[i]:remove()
    table.remove(self.list, i)
end

-- destroy a ballon
function ballons:destroy_ballon(i)
    local effect = self.list[i]:destroy()
    table.remove(self.list, i)
    return effect
end

-- chance parameters for new wave 
function ballons:wave_update(wave)
    self.chance = self.chance * self.chance_increase
end

-- generate a ballon 
function ballons:create_ballon(b_type)
    new_ballon = {}
    if b_type == "red" then 
        new_ballon = red_ballon:new()
    elseif b_type == "blue" then 
        new_ballon = blue_ballon:new() 
    elseif b_type == "green" then 
        new_ballon = green_ballon:new() 
    elseif b_type == "health" then
        new_ballon = health_ballon:new()
    end 
    new_ballon:init() 
    return new_ballon
end