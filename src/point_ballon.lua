point_ballon = ballon:new(
    {
        scale = 5,
        x = (love.graphics.getWidth() / 2),
        y = (love.graphics.getHeight() + 50),
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
    self.x = love.graphics.getWidth() * 0.25 - self.sprite:getWidth() * self.scale / 2
    self.y = self.y - self.speed * dt
    if self.speed > 0 and self.y < love.graphics.getWidth() / 2 - 200 then 
        self.speed = -100
    elseif self.speed < 0 and self.y > love.graphics.getWidth() / 2 - 100 then 
        self.speed = 100
    end 
end 

function point_ballon:destroy()
    self.sound:play()
    return "point"
end 