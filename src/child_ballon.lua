child_ballon = ballon:new(
    {
        scale = 3,
        x = (gameWidth / 2),
        y = (gameHeight + 50),
        speed = 300,
        sprite_path = 'assets/sprites/child_ballon.png', 
        sound_path = 'assets/sounds/ballon_pop.wav',
        value = 3,
        color = "cyan",
        dir = 1
    })

function child_ballon:new(new)
    new = new or {}
    setmetatable(new, self)
    self.__index = self 
    return new
end 

function child_ballon:init()
    self.sprite = love.graphics.newImage(self.sprite_path)
    self.sound = love.audio.newSource(self.sound_path, "static")
    self.x = math.random(gameWidth * 0.2, gameWidth * 0.8)
    self.sound:setVolume(0.05)
    self.init_x = self.x
    self.x_speed = 100
    self.dir = math.random()
    if self.dir < 0.5 then
        self.dir = -1
    else
        self.dir = 1 
    end 
end 

function child_ballon:update(dt)
    self.y = self.y - self.speed * dt
    self.x = self.x + self.x_speed * self.dir * dt
    if self.x > self.init_x + self.x_speed * 0.25 or self.x < self.init_x - self.x_speed * 0.25 then 
        self.dir = self.dir * -1
    end 
end 

function child_ballon:draw()
    love.graphics.draw(self.sprite, self.x, self.y, nil, self.scale)
    if self.effect_sprite then 
        love.graphics.draw(self.effect_sprite, self.x, self.y + 3 * self.scale, nil, self.scale)
    end 
end 