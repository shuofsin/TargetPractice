ballons = {}

-- initilize list of ballons
function ballons:init(debug)
    ballons.sounds = {}
    ballons.sounds.pop = love.audio.newSource("assets/sounds/ballon_pop.wav", "static")
    ballons.sounds.pop:setVolume(0.05)
    ballons.chance = 5
    ballons.chance_increase = 1.25
    ballons.list = {} 
    ballons.debug = debug
end 

-- update ballons 
function ballons:update(dt, wave_active, game)
    -- move the ballon upwards and remove if off-screen
    for i, v in ipairs(self.list) do 
        v.y = v.y - v.speed * dt
        if v.y + v.sprite:getHeight() * v.scale < 0 then 
            table.remove(self.list, i)
            game:add_health(-1)
        end
    end
    -- spawn ballons if wave active 
    local spawn_ballon = math.random(2000)
    if spawn_ballon < self.chance and wave_active then 
        table.insert(self.list, 0, ballons:create_ballon())
    end
    -- remove ballons if wave over 
    if not wave_active then 
        self.list = {}
    end 
    -- increment ballons if wave is over 
    if not wave_active then 
        ballons:wave_update(wave)
    end 
end 

-- draw ballons
function ballons:draw() 
    for i = #self.list, 1, -1 do 
        local v = self.list[i]
        love.graphics.draw(v.sprite, v.x, v.y, nil, v.scale)
        if debug then 
            local center_x, center_y, radius
            center_x = v.x + (v.sprite:getWidth() * v.scale) / 2
            center_y = v.y + (v.sprite:getWidth() * v.scale) / 2.5
            radius = (v.sprite:getWidth() * v.scale) / 2.5
            love.graphics.setLineWidth(5)
            love.graphics.circle("line", center_x, center_y, radius)
        end 
    end 
end 

-- delete ballons 
function ballons:clear()
    self.list = {}
end 

-- delete a ballon
function ballons:remove_ballon(i) 
    table.remove(self.list, i)
    ballons:play_sound("pop")
end

-- generate a ballon 
function ballons:create_ballon()
    ballon = {}
    ballon.scale = 4
    ballon.x = math.random(50, love.graphics.getWidth() - 50)
    ballon.y = love.graphics.getHeight() + 50
    ballon.sprite = love.graphics.newImage('assets/sprites/ballon_scaled.png')
    ballon.speed = 100
    ballon.exists = true
    return ballon
end

-- chance parameters for new wave 
function ballons:wave_update(wave)
    self.chance = self.chance * self.chance_increase
end

-- play a sound
function ballons:play_sound(sound)
    ballons.sounds[sound]:play()
end