pointer = {}

-- initalize pointer
function pointer:init(debug) 
    pointer.x = 0 
    pointer.y = 0
    pointer.scale = 3
    pointer.sprite_size = 32
    pointer.sprite = love.graphics.newImage("assets/sprites/pointer_scaled.png")
    pointer.debug = debug
    pointer.shooting = false
    pointer.isEmpty = false
    pointer.sounds = {}
    pointer.sounds.hit = love.audio.newSource("assets/sounds/dart_throw.mp3", "static")
    pointer.sounds.empty = love.audio.newSource("assets/sounds/empty_throw.mp3", "static")
    pointer.sounds.empty:setVolume(0.8)
    love.mouse.setVisible(false)
end

-- update pointer 
function pointer:update(dt)
    -- set the custom cursor to mouse position
    local mouse_x, mouse_y = love.mouse.getPosition()
    self.x = mouse_x - self.sprite_size * self.scale / 2
    self.y = mouse_y - self.sprite_size * self.scale / 2 
end 

-- draw pointer
function pointer:draw(dt)
    love.graphics.draw(self.sprite, self.x, self.y, 0, self.scale)
end 

-- calculates pointer distance to center and returns true if dist is within radius, returns false otherwise
function pointer:check_shot(ballon, ammo)
        local center_x, center_y, radius
    center_x = ballon.x + (ballon.sprite:getWidth() * ballon.scale) / 2
    center_y = ballon.y + (ballon.sprite:getWidth() * ballon.scale) / 2.5
    radius = (ballon.sprite:getWidth() * ballon.scale) / 2.5

    local x,y = love.mouse.getPosition()
    dist_x = x - center_x 
    dist_y = y - center_y
    dist_to_center = math.sqrt(dist_x * dist_x + dist_y * dist_y) 
            if dist_to_center < radius and ammo > 0 then
        return true
    end
    return false
end 

-- plays a sound 
function pointer:play_sound(sound)
    self.sounds[sound]:play()
end 

-- signal that the player is shooting
function pointer:set_shooting(is_shooting)
    self.shooting = is_shooting 
end