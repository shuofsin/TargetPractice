secondary = {}

function secondary:init(ballons_, pointer_, shoot_, game_) 
    require("src/sec_explosion")
    require("src/sec_timeslow")
    self.ability = sec_explosion:init(ballons_, pointer_, shoot_, game_)
end 

function secondary:update(dt)
    self.ability:update(dt)
end 

function secondary:draw()
    self.ability:draw()
end 

function secondary:activate(button)
    self.ability:activate(button)
end 

function secondary:reset()
    self:init(self.ability.ballons, self.ability.pointer, self.ability.shoot, self.ability.game)
end 

function secondary:get_reference() 
    return self.ability.ballons, self.ability.pointer, self.ability.shoot, self.ability.game
end 