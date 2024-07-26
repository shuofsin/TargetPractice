red_ballon = ballon:new(
    {
        scale = 4,
        x = (love.graphics.getWidth() / 2),
        y = (love.graphics.getHeight() + 50),
        speed = 100,
        sprite_path = 'assets/sprites/red_ballon.png', 
        sound_path = 'assets/sounds/ballon_pop.wav',
        value = 1
    })

function red_ballon:new(new)
    new = new or {}
    setmetatable(new, self)
    self.__index = self 
    return new
end 