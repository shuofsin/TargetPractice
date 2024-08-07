spiral_ballon = ballon:new(
    {
        scale = 4,
        x = (gameWidth / 2),
        y = (gameHeight + 50),
        speed = 150,
        sprite_path = 'assets/sprites/spiral_ballon-no_anim.png', 
        sound_path = 'assets/sounds/ballon_pop.wav',
        value = 4,
        color = "purple",
        num_frames = 1,
        rot = 0,
        rot_speed = 100, 
    })

function spiral_ballon:new(new)
    new = new or {}
    setmetatable(new, self)
    self.__index = self 
    return new
end 

function spiral_ballon:init() 
    self.sprite = love.graphics.newImage(self.sprite_path)
    --[[
    self.grid = anim8.newGrid(32, 32, self.sprite:getWidth(), self.sprite:getHeight())
    self.animation = anim8.newAnimation(self.grid('1-9', 1), 0.04)
    ]]
    self.sound = love.audio.newSource(self.sound_path, "static")
    self.sound:setVolume(0.05)
    self.x = math.random(gameWidth * 0.3, gameWidth * 0.6)
    self.c = {}
    self.c.x = self.x 
    self.c.y = self.y
    self.spiral_radius = self.sprite:getWidth() * self.scale * 1.4
    self.y = self.c.y + self.spiral_radius
    local temp = math.random(2)
    if temp == 1 then self.rot_speed = -100 else self.rot_speed = 100 end 
end

function spiral_ballon:update(dt) 
    -- this math sucks and I am GOING to kill myself over it (on the inside)
    --[[
        we have a center point, c, which represents the center of the circle upon which the spiral is set 
        c = (init_x, init_y) to start. We also have a parametric function m(c), which controls the motion of c 
        m(c) => {c.y = c.y + dt * s}, where s is how much the center point moves upwards per unit delta time, dt 
        
        we also have a point b, which represents the actualized postion of the ballon at a given time 
        To start, b = (init_x, init_y + r), where r is the radius of the spiral. This position also means that the ballon is at rad 0 in the unit circle
        The parametric function r(b) will rotate the ballon around c. 
            Remember that a point on a circle can be defined as:
                x = r cos a
                y = r sin a 
            where a is an radian value between 0 and 2pi 
        For the formal formula, we assume the center of the circle is the origin. However, the center of this circle is c, thus: 
            r(b) => {
                b.x = c.x + r cos a 
                b.y = c.y + r sin a 
            }
        Therefore, to move a ballon in a spiral upwards we simply need to do three things each update
            1. call f(c) 
            2. increment the angle, a
            3. set the ballons coordinates x,y according to the adjusted formula
    ]]

    -- f(c)
    self.c.y = self.c.y - self.speed * dt

    -- increment rotation. We increment by a number of degrees
    self.rot = self.rot + (2 * math.pi / 360) * self.rot_speed * dt

    -- set the physical ballon position
    self.x = self.c.x + self.spiral_radius * math.cos(self.rot)
    self.y = self.c.y + self.spiral_radius * math.sin(self.rot)
end 

function spiral_ballon:draw()
    love.graphics.draw(self.sprite, self.x, self.y, nil, self.scale)
    if self.effect_sprite then 
        love.graphics.draw(self.effect_sprite, self.x, self.y, nil, self.scale)
    end 
    --[[
        local center_x, center_y, radius
        local width = self.sprite:getWidth() * self.scale
        if self.num_frames then 
            width = width / self.num_frames
        end 
        center_x = self.x + (width) / 2
        center_y = self.y + (width) / 2.5
        radius = (width) * 0.4

        love.graphics.circle("fill", center_x, center_y, radius)
    ]]
end 