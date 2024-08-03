ghost_ballon = ballon:new(
    {
        scale = 4,
        x = (love.graphics.getWidth() / 2),
        y = (love.graphics.getHeight() + 50),
        speed = 200,
        sprite_path = 'assets/sprites/ghost_ballon.png', 
        sound_path = 'assets/sounds/ballon_pop.wav',
        value = 2,
        color = "cyan",
        opacity = 100,
    })

function ghost_ballon:new(new)
    new = new or {}
    setmetatable(new, self)
    self.__index = self 
    return new
end 

function ghost_ballon:init()
    self.sprite = love.graphics.newImage(self.sprite_path)
    self.sound = love.audio.newSource(self.sound_path, "static")
    self.x = math.random(200, love.graphics.getWidth() - 200)
    self.sound:setVolume(0.05)
    self.init_x = self.x
    self.x_speed = 150
    self.dir = math.random()
    if self.dir < 0.5 then
        self.dir = -1
    else
        self.dir = 1 
    end 
end 

function ghost_ballon:update(dt) 
    self.y = self.y - self.speed * dt
    self.x = self.x + self.x_speed * self.dir * dt
    local center_x, radius
    center_x = self.x + self.sprite:getWidth() * self.scale / 2
    radius = self.sprite:getWidth() * self.scale *  3 / 8 
    if center_x - radius <= 0 or center_x + radius >= love.graphics.getWidth() then 
        self.dir = self.dir * -1 
    end 
    if self.y < love.graphics.getWidth() * 0.3 then 
        self.opacity = self.opacity + 1
    elseif self.y < love.graphics.getWidth() * 1 then 
        self.opacity = self.opacity - 1
    end 
    if self.opacity < 0 then self.opacity = 0 end 
    if self.opacity > 100 then self.opacity = 100 end
end 

function ghost_ballon:draw()
    love.graphics.setColor(255, 255, 255, self.opacity / 100)
    love.graphics.draw(self.sprite, self.x, self.y, nil, self.scale) 
    if self.effect_sprite then 
        love.graphics.draw(self.effect_sprite, self.x, self.y, nil, self.scale)
    end 
    love.graphics.setColor(255, 255, 255, 1)
end 