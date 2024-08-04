secondary = {}

function secondary:init() 
    self.name = "explosion"
    self.charge = 5
    self.sprite = love.graphics.newImage("assets/sprites/secondary_explosion.png") 
    self.grid = anim8.newGrid(32, 32, self.sprite:getWidth(), self.sprite:getHeight())
    self.animation = anim8.newAnimation(self.grid('1-13', 1), 0.025)
    self.active = false
    self.num_frames = 13
    self.x = 0
    self.y = 0
    self.scale = 7
end 

function secondary:update(dt)
    if self.active then 
        self.animation:update(dt) 
        local frame = self.animation.position
        print(frame)
        if frame == 13 then 
            self.active = false
        end 
    else 
        self.animation:gotoFrame('1')
        self.animation = anim8.newAnimation(self.grid('1-13', 1), 0.025)
    end 
end 

function secondary:draw()
    if self.active then 
        self.animation:draw(self.sprite, self.x, self.x, nil, self.scale)
    end 
end 

function secondary:set_pos(x, y)
    local width = self.sprite:getWidth() * self.scale
    local height = self.sprite:getHeight() * self.scale
    self.x = x + width / 26
    self.y = y + height / 2
end 

function secondary:activate(button)
    if button == 2 then 
        local x, y = love.mouse.getPosition()
        self:set_pos(x, y)
        self.active = true
        print("active")
    end 
end 
