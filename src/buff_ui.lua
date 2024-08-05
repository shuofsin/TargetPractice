buff_ui = {
    start_x = 0,
    start_y = 0,
    scale = 2, 
    font = love.graphics.newFont("assets/fonts/PixelOperator8.ttf", 25),
    buffs = {
        {buff = "ammo_boost", num = 0, sprite = nil},
        {buff = "reload_boost", num = 0, sprite = nil},
        {buff = "multishot", num = 0, sprite = nil},
        {buff = "score_mult", num = 0, sprite = nil},
        {buff = "death_defiance", num = 0, sprite = nil}
    },
    num_active = 0,
}

function buff_ui:init(debug) 
    self.debug = debug
    self.start_x = gameWidth * 0.91
    self.start_y = gameHeight * 0.15
end 

function buff_ui:update(dt)
    for i, v in ipairs(self.buffs) do 
        if not v.sprite and v.num > 0 then 
            local path = "assets/sprites/" .. v.buff .. "_buff.png"
            v.sprite = love.graphics.newImage(path)
        end 
    end 
end 

function buff_ui:draw()
    local y_idx = 0
    for i, v in ipairs(self.buffs) do
        if v.sprite and v.num > 0 then
            y_idx = y_idx + 1
            love.graphics.draw(v.sprite, self.start_x, self.start_y + (y_idx - 1) * v.sprite:getHeight() * self.scale, nil, self.scale) 
            if v.num > 1 then 
                love.graphics.print("x" .. v.num, self.font, self.start_x + v.sprite:getWidth() * 0.75, self.start_y + (y_idx - 1) * v.sprite:getHeight() * self.scale + v.sprite:getHeight() * self.scale / 2)
            end 
        end 
    end 
    y_idx = 0
end 

function buff_ui:add_buff(buff_name)
    for i, v in ipairs(self.buffs) do
        if v.buff == buff_name then 
            v.num = v.num + 1
        end  
    end
end 

function buff_ui:remove_buff(buff_name)
    for i, v in ipairs(self.buffs) do
        if v.buff == buff_name then 
            v.num = v.num - 1
        end  
    end
end 