sec_blackhole = {}

function sec_blackhole:init(ballons_, pointer_, shoot_, game_) 
    self.name = "blackhole_sec"
    self.charge = 10
    self.sprite = love.graphics.newImage("assets/sprites/blackhole.png") 
    self.grid = anim8.newGrid(48, 48, self.sprite:getWidth(), self.sprite:getHeight())
    self.animation = anim8.newAnimation(self.grid('1-12', 1), 0.075)
    self.active = false
    self.num_frames = 12
    self.x = 0
    self.y = 0
    self.scale = 12
    self.radius = 0
    self.ballons = ballons_
    self.pointer = pointer_
    self.shoot = shoot_
    self.game = game_
    self.timer = nil
    self.duration = 3
    self.g = 0.5
    self.sound = love.audio.newSource("assets/sounds/blackhole.mp3", "static")
    self.sound:setPitch(2)
    self.sound:setVolume(0.1)
    return self
end 

function sec_blackhole:update(dt)
    if self.active then 
        self.animation:update(dt) 
        self:check_effect(dt)
        if not self.timer then 
            self.timer = love.timer.getTime() 
        elseif love.timer.getTime() - self.timer > self.duration then 
            self.active = false
            self.timer = nil
            self.sound:seek(0)
            self.sound:pause()
        end 
    else 
        self.animation:gotoFrame('1')
        if not self.animation.timer then 
            self.animation = anim8.newAnimation(self.grid('1-12', 1), 0.075)
        end 
    end 
end 

function sec_blackhole:draw()
    if self.active then 
        self.animation:draw(self.sprite, self.x, self.y, nil, self.scale)
        local width = self.sprite:getWidth() * self.scale * (1 / self.num_frames)
        local height = self.sprite:getHeight() * self.scale
        local center_x = self.x + width / 2
        local center_y = self.y + height / 2
    end 
end 

function sec_blackhole:set_pos(x, y)
    local width = self.sprite:getWidth() * self.scale * (1 / self.num_frames)
    local height = self.sprite:getHeight() * self.scale
    self.x = x - width / 2
    self.y = y - height / 2
end 

function sec_blackhole:activate(button)
    if button == 2 and not self.active then 
        if self.game.charge == self.game.total_charge then 
            self.game.charge = 0
            local x, y = love.mouse.getPosition()
            self:set_pos(x, y)
            self.active = true
            self.sound:play()
        end
    end 
end 

-- calculates pointer distance to center and returns true if dist is within radius, returns false otherwise
function sec_blackhole:check_effect(dt)
    local width = self.sprite:getWidth() * self.scale * (1 / self.num_frames)
    local height = self.sprite:getHeight() * self.scale
    local center_x = self.x + width / 2
    local center_y = self.y + height / 2
    for i,v in ipairs(self.ballons.list) do
        local b_x, b_y, b_w
        b_w = v.sprite:getWidth() * v.scale 
        if v.num_frames then 
            b_w = b_w / v.num_frames
        end 
        b_x = v.x + b_w * 0.5
        b_y = v.y + b_w * 0.4
        b_r = b_w * 0.4

        local dist_x, dist_y, dist
        dist_x = b_x - center_x
        dist_y = b_y - center_y 
        dist = math.sqrt(dist_x * dist_x + dist_y * dist_y) 
        local combined_radius = b_r + width / 4
        if dist < combined_radius then 
            self:pull_ballon(dist_x, dist_y, v, dt)
        end 
    end 
end 

function sec_blackhole:pull_ballon(dist_x, dist_y, ballon, dt)
    ballon.x = ballon.x - self.g * dist_x * dt
    ballon.y = ballon.y - self.g * dist_y * 6 * dt
end 

function sec_blackhole:level_up() 
    self.duration = self.duration + 2
end 

function sec_blackhole:reset()
    self.duration = 3 
end 