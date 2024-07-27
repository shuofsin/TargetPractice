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

    ballons.sounds = {}
    ballons.list = {} 
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
end 

-- add ballon to list
function ballons:add_ballon(b_type)
    if b_type == "health" or b_type == "point" then 
        self.list[#self.list + 1] = ballons:create_ballon(b_type)
    else 
        table.insert(self.list, 0, ballons:create_ballon(b_type))
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
    elseif b_type == "point" then 
        new_ballon = point_ballon:new()
    end 
    new_ballon:init() 
    return new_ballon
end

-- is empty
function ballons:is_empty() 
    return self.list == nil
end 