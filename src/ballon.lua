ballon = {scale = 1, x = 0, y = 0, sprite = nil, sprite_path = nil, speed = 0, exists = true, sound = nil, sound_path = nil, value = 1}

-- should never be called! always instance a subtype of ballon
function ballon:new(new) 
    new = new or {}
    setmetatable(new, self)
    self.__index = self 
    return new
end 

function ballon:init() 
    self.sprite = love.graphics.newImage(self.sprite_path)
    self.sound = love.audio.newSource(self.sound_path, "static")
    self.x = math.random(50, gameWidth - 50)
    self.sound:setVolume(0.05)
end

function ballon:update(dt) 
    self.y = self.y - self.speed * dt
end 

function ballon:draw()
    love.graphics.draw(self.sprite, self.x, self.y, nil, self.scale)
    if self.effect_sprite then 
        love.graphics.draw(self.effect_sprite, self.x, self.y, nil, self.scale)
    end 
end 

function ballon:remove() 
    self.sound:play()
end

function ballon:destroy() 
    self.sound:play()
    self = nil
    return "default"
end

function ballon:get_value()
    return self.value
end

function ballon:get_info()
    return self.x, self.y, self.scale, self.color, self.num_frames, self.sprite:getWidth()
end 

function ballon:set_x_pos_rel(pos)
    self.x = gameWidth * pos - self.sprite:getWidth() * self.scale / 2
end 

function ballon:set_y_pos_rel(pos)
    self.y = gameHeight * pos - self.sprite:getHeight() * self.scale / 2
end 

function ballon:set_x_pos_abs(pos)
    self.x = pos
end 

function ballon:set_y_pos_abs(pos)
    self.y = pos
end 

function ballon:get_speed_boost() 
    local speed_diff = 400 - self.speed 
    local boost = speed_diff * 0.35
    self.speed = self.speed + boost
    self.effect_sprite = love.graphics.newImage('assets/sprites/speed_boost_effect.png')
end 

function ballon:set_speed_mult(mult)
    self.speed = self.speed * mult 
end 

function ballon:getInfo() 
    return self.x, self.y, self.sprite:getWidth() * self.scale, self.sprite:getHeight() * self.scale
end 