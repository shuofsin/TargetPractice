health_ballon = ballon:new(
    {
        scale = 5,
        x = (love.graphics.getWidth() / 2),
        y = (love.graphics.getHeight() + 50),
        speed = 100,
        sprite_path = 'assets/sprites/health_ballon.png', 
        sound_path = 'assets/sounds/ballon_pop.wav',
        value = 1
    })

function health_ballon:new(new)
    new = new or {}
    setmetatable(new, self)
    self.__index = self 
    return new
end 

function health_ballon:update(dt)
    self.y = self.y - self.speed * dt
end 


function health_ballon:destroy()
    self.sound:play()
    return "health"
end 