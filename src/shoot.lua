shoot = {}

-- init shoot 
function shoot:init(debug) 
    -- shoot stats
    shoot.max_ammo = 5
    shoot.current_ammo = shoot.max_ammo
    shoot.begin_reload = nil
    -- create reload wheel
    shoot.reload_wheel = {}
    shoot.reload_wheel.visible = false
    shoot.reload_wheel.frame_delay = 0.05
    shoot.reload_wheel.sprite = love.graphics.newImage("assets/sprites/reload_wheel.png")
    shoot.reload_wheel.grid = anim8.newGrid(80, 80, self.reload_wheel.sprite:getWidth(), self.reload_wheel.sprite:getHeight())
    shoot.reload_wheel.animation = anim8.newAnimation(self.reload_wheel.grid('1-33', 1), self.reload_wheel.frame_delay)
    shoot.reload_wheel.time_to_reload = self.reload_wheel.frame_delay * 33
    -- create a list of darts 
    shoot.darts = {}
    shoot.dart_height = 25
    for i=1,self.max_ammo do 
        self.darts[i] = shoot:create_dart(i)
    end

    shoot.reload_sound = love.audio.newSource('assets/sounds/reload.mp3', 'static')
    shoot.reload_sound:setPitch(2.25)
    shoot.reload_sound:setVolume(0.8)
end 

-- update shoot 
function shoot:update(dt, time)
    -- check if the player is out of darts, and reload if so 
    if self.current_ammo <= 0 then 
        if self.begin_reload == nil then 
            self.begin_reload = love.timer.getTime()
            self.reload_wheel.visible = true
            self.reload_wheel.animation:gotoFrame(1)
            self.reload_sound:play()
        elseif love.timer.getTime() - self.begin_reload >= self.reload_wheel.time_to_reload and not game.paused then 
            shoot:reload_darts()
            self.reload_wheel.visible = false
            self.reload_sound:pause()
            self.reload_sound:seek(0)
        elseif not game.paused then 
            self.reload_wheel.animation:update(dt)
        end 
        if game.paused then 
            self.begin_reload = self.begin_reload + dt
        end 
    end
end

-- draw shoot UI
function shoot:draw() 
    -- draw the darts
    for i, v in ipairs(self.darts) do 
        love.graphics.draw(v.sprite, v.x, v.y, nil, v.scale)
    end
    -- draw reload wheel 
    if self.reload_wheel.visible then 
        self.reload_wheel.animation:draw(self.reload_wheel.sprite, 10, gameHeight * 0.15, nil, 0.75)
    end
end 


-- generate a dart 
function shoot:create_dart(i)
    dart = {}
    dart.x = 10
    dart.y = i * self.dart_height + gameHeight * 0.08
    dart.sprite = love.graphics.newImage("assets/sprites/dart_scaled.png")
    dart.scale = 2
    return dart
end 

-- reload the darts 
function shoot:reload_darts()
    for i=1,self.max_ammo do 
        self.darts[i] = shoot:create_dart(i)
    end
    self.current_ammo = self.max_ammo
    self.begin_reload = nil
end

-- remove a dart
function shoot:remove_dart(i)
    table.remove(self.darts, self.current_ammo)
    self.current_ammo = self.current_ammo - 1
end

-- get current ammo
function shoot:get_current_ammo()
    return self.current_ammo
end

function shoot:boost_reload(boost_percent)
    self.reload_wheel.frame_delay = self.reload_wheel.frame_delay * boost_percent
    self.reload_wheel.animation = anim8.newAnimation(self.reload_wheel.grid('1-33', 1), self.reload_wheel.frame_delay)
    self.reload_wheel.time_to_reload = self.reload_wheel.frame_delay * 33
    self.reload_sound:setPitch(self.reload_sound:getPitch() * (1 / boost_percent))
end 

function shoot:ammo_increase(val)
    self.max_ammo = self.max_ammo + val 
end 