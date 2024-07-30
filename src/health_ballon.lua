health_ballon = ballon:new(
    {
        scale = 5,
        x = (love.graphics.getWidth() / 2),
        y = (love.graphics.getHeight() + 50),
        speed = 200,
        sprite_path = 'assets/sprites/health_ballon.png', 
        sound_path = 'assets/sounds/ballon_pop.wav',
        value = 0,
        color = "pink"
    })

function health_ballon:new(new)
    new = new or {}
    setmetatable(new, self)
    self.__index = self 
    return new
end 

function health_ballon:update(dt)
    self.y = self.y - self.speed * dt
    if self.speed > 0 and self.y < love.graphics.getWidth() / 2 - 200 then 
        self.speed = -100
    elseif self.speed < 0 and self.y > love.graphics.getWidth() / 2 - 100 then 
        self.speed = 100
    end 
end 

function health_ballon:destroy()
    self.sound:play()
    return "health"
end 