Options = {}
local fileName = 'options.conf'

--keys that cannot be bound
Options.prohibited = {
		backspace = true, 
		capslock = true, 
		tab = true, 
		shift = true
}

--Generates default options and writes them to options.conf
function Options.generateDefaults()
	local options = {
	 movement = {
		up = {'up', 'k'},
		down = {'down', 'j'},
		right = {'right', 'l'},
		left = {'left', 'h'}
		},
	 actions = {
		whip = {'t'}
		}
	}
	local file = love.filesystem.newFile(fileName)
	file:open('w')
	file:write(Serpent.block(options, {comment = false}))
	file:close()
end



--Loads options table from options.conf
function Options:loadOptions()
	if not love.filesystem.getInfo(fileName) then
		self.generateDefaults()
	end
	
	err, self.options = Util.loadTable(fileName)
	if not err then 
		self.generateDefaults()
		err, self.options = Util.loadTable(fileName)
	end
	
	self.moveKeys = {}
	for _,keys in pairs(self.options.movement) do
		self.moveKeys[keys[1]] = true
		self.moveKeys[keys[2]] = true	
	end	
	
	self.actionKeys = {}
	for _,keys in pairs(self.options.actions) do
		self.actionKeys[keys[1]] = true
	end
	self.up = self.options.movement.up
	self.right = self.options.movement.right
	self.down = self.options.movement.down
	self.left = self.options.movement.left
	self.whip = self.options.actions.whip
end

function Options:reload()
	self.options.movement.up = self.up
	self.options.movement.down = self.down
	self.options.movement.right = self.right
	self.options.movement.left = self.left
	self.options.actions.whip = self.whip

	self.moveKeys = {}
	for _,keys in pairs(self.options.movement) do
		self.moveKeys[keys[1]] = true
		self.moveKeys[keys[2]] = true	
	end	
	
	self.actionKeys = {}
	for _,keys in pairs(self.options.actions) do
		self.actionKeys[keys[1]] = true
	end	
end

function Options:containsKey(key)
	return self.actionKeys[key] or self.moveKeys[key]	
end

function Options:save()
	love.filesystem.write(fileName, Serpent.block(self.options, {comment = false}))
	file:close()
end
				
--returns a 'vector' unit based on the key
function Options:keyToDirection(key)
	if key == self.up[1] or key == self.up[2] then
		return {x=0, y=-1}
	elseif key == self.right[1] or key == self.right[2] then
		return {x=1, y=0}
	elseif key == self.down[1] or key == self.down[2] then
		return {x=0, y=1}
	elseif key == self.left[1] or key == self.left[2] then
		return {x=-1, y=0}
	end
end

--Returns the state corresponding to the action key
function Options:keyToAction(key)
	if key == self.whip[1] then
		return WhipState
	end
end

return Options
