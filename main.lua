function love.load()
    pointer = {}
    pointer.x = 0
    pointer.y = 0
    pointer.sprite = love.graphics.newImage('assets/sprites/pointer.png')
end 

function love.update(dt)
    local mouse_x, mouse_y = love.mouse.getPosition()
    pointer.x = mouse_x - 64
    pointer.y = mouse_y - 64
    love.mouse.setVisible(false)
end

function love.draw()
    love.graphics.draw(pointer.sprite, pointer.x, pointer.y)
end 
