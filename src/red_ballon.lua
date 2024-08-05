red_ballon = ballon:new(
    {
        scale = 4,
        x = (gameWidth / 2),
        y = (gameHeight + 50),
        speed = 150,
        sprite_path = 'assets/sprites/red_ballon.png', 
        sound_path = 'assets/sounds/ballon_pop.wav',
        value = 1,
        color = "red"
    })

function red_ballon:new(new)
    new = new or {}
    setmetatable(new, self)
    self.__index = self 
    return new
end 