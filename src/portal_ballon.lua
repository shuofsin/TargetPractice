portal_ballon = ballon:new(
    {
        scale = 4,
        x = (gameWidth / 2),
        y = (gameHeight + 50),
        speed = 100,
        sprite_path = 'assets/sprites/portal_ballon.png', 
        sound_path = 'assets/sounds/ballon_pop.wav',
        value = 4,
        color = "purple",
        num_frames = 16,
        chance = 20,
        spawn_table = {"red", "blue", "green"}
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
    self.x = math.random(gameWidth * 0.2, gameWidth * 0.8)
    self.sound:setVolume(0.05)
end

function portal_ballon:update(dt) 
    self.y = self.y - self.speed * dt
    self.animation:update(dt)
    local spawn = math.random(2000)
    if spawn < self.chance then 
        local spawn_x = self.x + self.sprite:getWidth() * 0.5 * (1 / 15) 
        local spawn_y = self.y + self.sprite:getWidth() * 0.5 * (1 / 15)
        local ballon_idx = (spawn % 3) + 1 
        self.ballons:add_ballon_at_pos(self.spawn_table[ballon_idx], spawn_x, spawn_y)
    end 
end 

function portal_ballon:draw()
    self.animation:draw(self.sprite, self.x, self.y, nil, self.scale)
    if self.effect_sprite then 
        love.graphics.draw(self.effect_sprite, self.x + self.sprite:getWidth() * 0.5 * (1 / 15) , self.y + self.sprite:getWidth() * 0.5 * (1 / 15), nil, self.scale)
    end 
end 

function portal_ballon:get_ballons(ballons)
    self.ballons = ballons
end 