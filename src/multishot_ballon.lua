multishot_ballon = ballon:new(
    {
        scale = 6,
        x = (gameWidth / 2),
        y = (gameHeight + 50),
        speed = 200,
        sprite_path = 'assets/sprites/multishot_ballon.png', 
        sound_path = 'assets/sounds/ballon_pop.wav',
        value = 0,
        color = "cyan"
    })

function multishot_ballon:new(new)
    new = new or {}
    setmetatable(new, self)
    self.__index = self 
    return new
end 

function multishot_ballon:update(dt)
    self.y = self.y - self.speed * dt
    if self.speed > 0 and self.y < gameWidth / 2 - 200 then 
        self.speed = -100
    elseif self.speed < 0 and self.y > gameWidth / 2 - 100 then 
        self.speed = 100
    end 
end 


function multishot_ballon:destroy()
    self.sound:play()
    self = nil
    return "multishot"
end 