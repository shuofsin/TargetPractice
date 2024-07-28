menu = {buttons = {}}

function menu:new(new)
    new = new or {}
    setmetatable(new, self)
    self.__index = self 
    return new
end 

function menu:init(debug) 
    menu.debug = debug
end

function menu:update(dt) 
    -- for debug reasons
end 

function menu:draw()
    for k, v in pairs(self.buttons) do 
        love.graphics.draw(v.sprite, v.x, v.y, nil, v.scale)
    end 
end 

-- enter the game 
function menu:use_menu(x, y, button, game)
    if button == 1 then
        for k, v in pairs(self.buttons) do
            local min_x, min_y, max_x, max_y
            min_x = v.x 
            min_y = v.y
            max_x = min_x + v.sprite:getWidth() * v.scale 
            max_y = min_y + v.sprite:getHeight() * v.scale
            if x > min_x and x < max_x and y > min_y and y < max_y then 
                game:set_state(v.state)
            end
        end 
    end
end

-- create menu button
function menu:create_button(state_name, x, y, sprite_path, render_scale)
    local button = {}
    button.state = state_name
    button.sprite = love.graphics.newImage(sprite_path)
    button.scale = render_scale
    button.x = x - button.sprite:getWidth() *  button.scale / 2
    button.y = y - button.sprite:getHeight() *  button.scale / 2
    return button
end 