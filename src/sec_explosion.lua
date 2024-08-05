sec_explosion = {}

function sec_explosion:init(ballons_, pointer_, shoot_, game_) 
    self.name = "explosion_sec"
    self.charge = 5
    self.sprite = love.graphics.newImage("assets/sprites/secondary_explosion.png") 
    self.grid = anim8.newGrid(32, 32, self.sprite:getWidth(), self.sprite:getHeight())
    self.animation = anim8.newAnimation(self.grid('1-13', 1), 0.02)
    self.active = false
    self.num_frames = 13
    self.x = 0
    self.y = 0
    self.scale = 12
    self.radius = 0
    self.ballons = ballons_
    self.pointer = pointer_
    self.shoot = shoot_
    self.game = game_
    return self
end 

function sec_explosion:update(dt)
    if self.active then 
        self.animation:update(dt) 
        local frame = self.animation.position
        self.radius = (frame + 1) * self.scale
        self:check_effect()
        if frame == 13 then 
            self.active = false
        end 
        self:check_effect(ballons)
    else 
        self.animation:gotoFrame('1')
        if not self.animation.timer then 
            self.animation = anim8.newAnimation(self.grid('1-13', 1), 0.025)
        end 
    end 
end 

function sec_explosion:draw()
    if self.active then 
        self.animation:draw(self.sprite, self.x, self.y, nil, self.scale)
    end 
end 

function sec_explosion:set_pos(x, y)
    local width = self.sprite:getWidth() * self.scale * (1 / self.num_frames)
    local height = self.sprite:getHeight() * self.scale
    self.x = x - width / 2
    self.y = y - height / 2
end 

function sec_explosion:activate(button)
    if button == 2 and not self.active then 
        if self.game.charge == self.game.total_charge then 
            self.game.charge = 0
            local x, y = love.mouse.getPosition()
            self:set_pos(x, y)
            self.active = true
        end
    end 
end 

-- calculates pointer distance to center and returns true if dist is within radius, returns false otherwise
function sec_explosion:check_effect()
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
        local combined_radius = b_r + self.radius 
        if dist < combined_radius then 
            self.game:suceed(v, i, self.shoot, self.pointer, self.ballons, false)
        end 
    end 
end 

function sec_explosion:level_up() 
    self.scale = math.floor(self.scale * 1.5)
end 

function sec_explosion:reset()
    self.active = false
    self.scale = 12
end 