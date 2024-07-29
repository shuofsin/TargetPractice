blue_ballon = ballon:new(
    {
        scale = 4,
        x = (love.graphics.getWidth() / 2),
        y = (love.graphics.getHeight() + 50),
        speed = 400,
        sprite_path = 'assets/sprites/blue_ballon.png', 
        sound_path = 'assets/sounds/ballon_pop.wav',
        value = 3,
        color = "blue"
    })

function blue_ballon:new(new)
    new = new or {}
    setmetatable(new, self)
    self.__index = self 
    return new
end 