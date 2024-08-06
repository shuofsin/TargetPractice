point_ballon = ballon:new(
    {
        scale = 5,
        x = math.random(gameWidth * 0.1, gameWidth * 0.9),
        y = (gameHeight + 50),
        speed = 200,
        sprite_path = 'assets/sprites/point_ballon.png', 
        sound_path = 'assets/sounds/ballon_pop.wav',
        value = 5,
        color = "orange"
    })

function point_ballon:new(new)
    new = new or {}
    setmetatable(new, self)
    self.__index = self 
    return new
end 

function point_ballon:update(dt)
    self.y = self.y - self.speed * dt
end 