green_ballon = ballon:new(
    {
        scale = 4,
        x = (love.graphics.getWidth() / 2),
        y = (love.graphics.getHeight() + 50),
        speed = 200,
        sprite_path = 'assets/sprites/green_ballon.png', 
        sound_path = 'assets/sounds/ballon_pop.wav',
        value = 3
    })

function green_ballon:new(new)
    new = new or {}
    setmetatable(new, self)
    self.__index = self 
    return new
end 