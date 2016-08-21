local GameObject = class("GameObject", {
	description = "Default Game Object"
})

function GameObject:getDescription()
	print self.description
end

return GameObject