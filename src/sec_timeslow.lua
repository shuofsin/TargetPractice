sec_timeslow = {}

function sec_timeslow:init(ballons_, pointer_, shoot_, game_) 
    self.name = "timeslow_sec"
    self.charge = 8
    self.active = false
    self.ballons = ballons_
    self.pointer = pointer_
    self.shoot = shoot_
    self.game = game_
    self.duration = 2
    self.speed_mult = 0.5
    self.sound = love.audio.newSource("assets/sounds/power_up.wav", "static")
    self.sound:setVolume(0.5)
    return self
end 

function sec_timeslow:update(dt)
    if self.active then
        for i, v in ipairs(self.ballons.list) do
            if not v.sped_up then v:set_speed_mult(self.speed_mult) end
            v.sped_up = true
        end  
        if not self.timer then 
            self.timer = love.timer.getTime() 
        elseif love.timer.getTime() - self.timer  >= self.duration and not self.game.paused then 
            self.active = false 
            self.timer = nil
            for i, v in ipairs(self.ballons.list) do
                if v.sped_up then v:set_speed_mult(1 / self.speed_mult) end
                v.sped_up = false
            end 
            self.sound:setPitch(1)
            self.sound:play()
        elseif self.game.paused then 
            self.timer = self.timer + dt
        end 
    end
end 

function sec_timeslow:draw()
    if self.active then 
        love.graphics.setColor(love.math.colorFromBytes(118, 168, 233, 80))
        love.graphics.rectangle("fill", 0, 0, gameWidth, gameHeight)
        love.graphics.setColor(1, 1, 1)
    end 
end 

function sec_timeslow:activate(button)
    if button == 2 and not self.active then 
        if self.game.charge == self.game.total_charge then 
            self.game.charge = 0
            self.active = true
            self.sound:setPitch(0.5)
            self.sound:play()
        end
    end 
end 

function sec_timeslow:level_up() 
    self.duraction = self.duration + 2
end 

function sec_timeslow:reset()
    self.duration = 2
end 