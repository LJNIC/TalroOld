--Global libraries/utilities/classes
ROT = require 'lib/rotLove/rot'
UUID = require 'lib/uuid'
COLORS = require 'util/colors'
TileTypes = require 'util/tileTypes'
Logger = require 'logger'
Gamestate = require 'lib/gamestate'
PlayState = require 'states/play'
WhipState = require 'states/playwhip'
Util = require 'util/util'
Entity = require 'entities/entity'
Mummy = require 'entities/mummy'
Door = require 'entities/door'
Map = require 'map'
Player = require 'entities/player'
Bat = require 'entities/bat'
AStar = require 'lib/lua-star'
Serpent = require 'lib/serpent'
Options = require 'options'

--Loads options 
Options:loadOptions()
print(Options.options.actions.whip[1])

--Seeds the uuid creator for entities
UUID.seed()

SCREEN_HEIGHT = 22
SCREEN_WIDTH = 35

function love.load()
	love.keyboard.setKeyRepeat(true)
	Logger.init()
	Gamestate.switch(PlayState)
end

function love.textinput(t)
	Gamestate.textinput(t)
end

function love.keypressed(key, scancode, isrepeat)
	Gamestate.keypressed(key)
end

function love.update(dt)	
	Gamestate.update(dt)
end

function love.draw() 
	Gamestate.draw()
end
