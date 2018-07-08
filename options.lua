Options = {}

function Options.generateDefaults()
	local options = {
	 movement = {
		up = {'up', 'k'},
		down = {'down', 'j'},
		right = {'right', 'l'},
		left = {'left', 'h'}
		},
	 actions = {
		whip = 't'
		}
	}
	local file = io.open('options.conf', 'w')
	file:write(Serpent.block(options, {comment = false}))
	file:close()
end

function Options:loadOptions()
	optionsFile = io.open('options.conf', 'r')
	if optionsFile == nil then
		self.generateDefaults()
	end
	
	err, self.options = Util.loadTable('options.conf')
	if err then 
		self.generateDefaults()
		err, self.options = Util.loadTable('options.conf')
	end
	
	self.moveKeys = {}
	for _,keys in pairs(options.movement) do
		self.moveKeys[keys[1]] = true
		self.moveKeys[keys[2]] = true	
	end	
	
	self.actionKeys = {}
	for _,keys in pairs(options.actions) do
		self.actionKeys[keys[1]] = true
	end
	self.up = self.options.movement.up
	self.right = self.options.movement.right
	self.down = self.options.movement.down
	self.left = self.options.movement.left
end
				
--returns a 'vector' unit based on the key
function Options:keyToDirection(key)
	if self.up[key] then
		return {x=0, y=-1}
	elseif self.right[key] then
		return {x=1, y=0}
	elseif self.down[key] then
		return {x=0, y=1}
	elseif self.left[key] then
		return {x=-1, y=0}
	end
end

--Returns the state corresponding to the action key
function Options:keyToAction(key)
	if key == whip then
		return WhipState
	end
end

return Options
