health_ballon = ballon:new(
    {
        scale = 5,
        x = math.random(gameWidth * 0.2, gameWidth * 0.8),
        y = (gameHeight + 50),
        speed = 400,
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
end 

function health_ballon:destroy()
    self.sound:play()
    self = nil
    return "health"
end 