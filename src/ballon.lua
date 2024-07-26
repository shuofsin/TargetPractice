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
    self.x = math.random(50, love.graphics.getWidth() - 50)
    self.sound:setVolume(0.05)
end

function ballon:update(dt) 
    self.y = self.y - self.speed * dt
end 

function ballon:draw()
    love.graphics.draw(self.sprite, self.x, self.y, nil, self.scale)
end 

function ballon:remove() 
    self.sound:play()
end

function ballon:destroy() 
    self.sound:play()
    return "default"
end

function ballon:get_value()
    return self.value
end