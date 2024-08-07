secondary = {}

function secondary:init(ballons_, pointer_, shoot_, game_) 
    require("src/sec_explosion")
    require("src/sec_timeslow")
    require("src/sec_blackhole")
    self.ability = sec_explosion:init(ballons_, pointer_, shoot_, game_)
    return self
end 

function secondary:update(dt)
    self.ability:update(dt)
end 

function secondary:draw()
    self.ability:draw()
end 

function secondary:activate(button)
    if not self.ability.game.paused then self.ability:activate(button)   end 
end 

function secondary:reset()
    self:init(self.ability.ballons, self.ability.pointer, self.ability.shoot, self.ability.game)
end 

function secondary:get_reference() 
    return self.ability.ballons, self.ability.pointer, self.ability.shoot, self.ability.game
end 