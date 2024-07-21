function love.load()
    -- stat trackers
    score = 0
    health = 10
    playing = true

    -- custom cursor
    pointer = {}
    pointer.x = 0
    pointer.y = 0
    pointer.sprite = love.graphics.newImage('assets/sprites/pointer.png')

    -- default target, will add more later prob 
    listOfBallons = {}

    -- set window size and background
    love.window.setMode(800, 600)
    background = love.graphics.newImage("assets/sprites/background.png")

    -- get font for text 
    font = love.graphics.newFont("assets/fonts/PixelOperator8.ttf", 30)

    -- get relative game time
    start = love.timer.getTime()
    time = love.timer.getTime() - start

    -- chance to spawn a ballon, will increase as time goes on 
    chance = 0.005
end 

function love.update(dt)
    -- set the custom cursor to mouse position and disable the default cursor
    local mouse_x, mouse_y = love.mouse.getPosition()
    pointer.x = mouse_x - pointer.sprite:getWidth() / 2
    pointer.y = mouse_y - pointer.sprite:getHeight() / 2
    love.mouse.setVisible(false)
    -- move the ballon upwards and remove it if it gets hit
    for i, v in ipairs(listOfBallons) do 
        v.y = v.y - v.speed * dt
        if love.mouse.isDown(1) and check_pointer(v) then 
            table.remove(listOfBallons, i)
            score = score + 1
        end
        if v.y + v.sprite:getHeight() < 0 then 
            health = health - 1
            table.remove(listOfBallons, i)
        end
    end
    -- quit game if player loses 
    if health <= 0 then 
        love.event.quit(0)
    end
    time = love.timer.getTime() - start
    spawn_ballon = math.random()
    if spawn_ballon < chance then 
        -- table.insert(listOfBallons, create_ballon())
    end
end

function love.draw()
    -- draw background
    love.graphics.draw(background, 0, 0)
    -- draw ballons
    for i, v in ipairs(listOfBallons) do 
        love.graphics.draw(v.sprite, v.x, v.y)
    end
    -- draw the cursor above the ballon
    love.graphics.draw(pointer.sprite, pointer.x, pointer.y)
    -- draw stats
    score_tracker = "Score: " .. score
    love.graphics.print(score_tracker, font, 10, 10)
    health_tracker = "Health: " .. health 
    love.graphics.print(health_tracker, font, 560, 10)
    -- format time and draw
    time_tracker = string.format("%02.0f:%02.0f", math.floor(time/60), math.floor(time % 60))
    love.graphics.print(time_tracker, font, 335, 10)
end 

-- calculates pointer distance to center and returns true if dist is within radius, returns false otherwise
function check_pointer(ballon)
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

-- generate a ballon 
function create_ballon()
    ballon = {}
    ballon.x = math.random(love.graphics.getWidth())
    ballon.y = love.graphics.getHeight() + 50
    ballon.sprite = love.graphics.newImage('assets/sprites/ballon.png')
    ballon.speed = 100
    ballon.exists = true
    return ballon
end
