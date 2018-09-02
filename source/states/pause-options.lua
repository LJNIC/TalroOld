local base = require 'states/options-base'

pauseOptions = MenuOptionsState:extend(PlayState)

function pauseOptions:init()
	base.loadMenu(self, PauseState)
end

return pauseOptions
