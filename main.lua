function love.load()
    -- custom cursor
    pointer = {}
    pointer.x = 0
    pointer.y = 0
    pointer.sprite = love.graphics.newImage('assets/sprites/pointer.png')

    -- default target, will add more later prob 
    ballon = {}
    ballon.x = 400
    ballon.y = 600
    ballon.sprite = love.graphics.newImage('assets/sprites/ballon.png')
    ballon.speed = 100
    ballon.exists = true
end 

function love.update(dt)
    -- set the custom cursor to mouse position and disable the default cursor
    local mouse_x, mouse_y = love.mouse.getPosition()
    pointer.x = mouse_x - pointer.sprite:getWidth() / 2
    pointer.y = mouse_y - pointer.sprite:getHeight() / 2
    love.mouse.setVisible(false)
    -- move the ballon upwards and remove it if it gets hit
    ballon.y = ballon.y - ballon.speed * dt
    if love.mouse.isDown(1) and check_pointer() then 
        ballon.exists = false 
    end
end

function love.draw()
    -- only draw the ballon if it exists
    if ballon.exists then 
        love.graphics.draw(ballon.sprite, ballon.x, ballon.y)
    end
    -- draw the cursor above the ballon
    love.graphics.draw(pointer.sprite, pointer.x, pointer.y)
    -- draw target bounts
    love.graphics.circle("line", ballon.x + ballon.sprite:getWidth() / 2, ballon.y + ballon.sprite:getWidth() / 3, ballon.sprite:getWidth() / 3.5)
end 

-- calculates pointer distance to center and returns true if dist is within radius, returns false otherwise
function check_pointer()
    local center_x, center_y, radius
    center_x = ballon.x + ballon.sprite:getWidth() / 2
    center_y = ballon.y + ballon.sprite:getWidth() / 3
    radius = ballon.sprite:getWidth() / 3.5
    
    local x, y = love.mouse.getPosition()
    dist_x = x - center_x 
    dist_y = y - center_y
    dist_to_center = math.sqrt(dist_x * dist_x + dist_y * dist_y) 
    if dist_to_center < radius then 
        return true
    end
    return false
end 