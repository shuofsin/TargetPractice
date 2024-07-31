portal_ballon = ballon:new(
    {
        scale = 4,
        x = (love.graphics.getWidth() / 2),
        y = (love.graphics.getHeight() + 50),
        speed = 100,
        sprite_path = 'assets/sprites/portal_ballon.png', 
        sound_path = 'assets/sounds/ballon_pop.wav',
        value = 4,
        color = "purple",
        num_frames = 16,
        chance = 50
    })

function portal_ballon:new(new)
    new = new or {}
    setmetatable(new, self)
    self.__index = self 
    return new
end 

function portal_ballon:init() 
    self.sprite = love.graphics.newImage(self.sprite_path)
    self.grid = anim8.newGrid(48, 48, self.sprite:getWidth(), self.sprite:getHeight())
    self.animation = anim8.newAnimation(self.grid('1-16', 1), 0.1)
    self.sound = love.audio.newSource(self.sound_path, "static")
    self.x = math.random(50, love.graphics.getWidth() - 50)
    self.sound:setVolume(0.05)
end

function portal_ballon:update(dt) 
    self.y = self.y - self.speed * dt
    self.animation:update(dt)
    local spawn = math.random(2000)
    if spawn < self.chance then 
        self.ballons:create_ballon("red", self.x, self.y)
    end 
end 

function portal_ballon:draw()
    self.animation:draw(self.sprite, self.x, self.y, nil, self.scale)
end 

function portal_ballon:get_func(ballons)
    self.ballons = ballons
end 