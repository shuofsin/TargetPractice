blue_ballon = ballon:new(
    {
        scale = 4,
        x = (gameWidth / 2),
        y = (gameHeight + 50),
        speed = 400,
        sprite_path = 'assets/sprites/blue_ballon.png', 
        sound_path = 'assets/sounds/ballon_pop.wav',
        value = 2,
        color = "blue"
    })

function blue_ballon:new(new)
    new = new or {}
    setmetatable(new, self)
    self.__index = self 
    return new
end 