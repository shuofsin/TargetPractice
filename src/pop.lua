pop = {}

function pop:new(new) 
    new = new or {}
    setmetatable(new, self)
    self.__index = self 
    return new
end 

function pop:init(x_, y_, scale_, color_, num_frames, width)
    self.x = x_ 
    self.y = y_ 
    if num_frames then 
        self.x = self.x + width * 0.5 * (1 / num_frames)
        self.y = self.y + width * 0.5 * (1 / num_frames)
    end 
    self.frame_delay = 0.075
    self.base = {}
    
    self.base.sprite_sheet = love.graphics.newImage("assets/sprites/pop.png") 
    self.base.grid = anim8.newGrid(32, 32, self.base.sprite_sheet:getWidth(), self.base.sprite_sheet:getHeight())
    self.base.animation = anim8.newAnimation(self.base.grid('1-7', 1), self.frame_delay)

    self.color = {}
    local color_path = "assets/sprites/pop_color_" .. color_ .. ".png"
    self.color.sprite_sheet = love.graphics.newImage(color_path) 
    self.color.grid = anim8.newGrid(32, 32, self.color.sprite_sheet:getWidth(), self.color.sprite_sheet:getHeight())
    self.color.animation = anim8.newAnimation(self.color.grid('1-7', 1), self.frame_delay)

    self.scale = scale_
end 

function pop:update(dt)
   self.base.animation:update(dt)
   self.color.animation:update(dt)
end 

function pop:draw()
    self.base.animation:draw(self.base.sprite_sheet, self.x, self.y, nil, self.scale)
    self.color.animation:draw(self.color.sprite_sheet, self.x, self.y, nil, self.scale)
end 

function pop:is_over()
    return self.base.animation.position == 7
end 