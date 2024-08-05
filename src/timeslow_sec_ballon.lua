timeslow_sec_ballon = ballon:new(
    {
        scale = 6,
        x = (gameWidth / 2),
        y = (gameHeight + 50),
        speed = 200,
        sprite_path = 'assets/sprites/timeslow_sec_ballon.png', 
        sound_path = 'assets/sounds/ballon_pop.wav',
        value = 0,
        color = "blue"
    })

function timeslow_sec_ballon:new(new)
    new = new or {}
    setmetatable(new, self)
    self.__index = self 
    return new
end 

function timeslow_sec_ballon:update(dt)
    self.y = self.y - self.speed * dt
    if self.speed > 0 and self.y < gameWidth / 2 - 200 then 
        self.speed = -100
    elseif self.speed < 0 and self.y > gameWidth / 2 - 100 then 
        self.speed = 100
        
    end 
end 

function timeslow_sec_ballon:destroy()
    self.sound:play()
    self = nil
    return "timeslow_sec"
end 