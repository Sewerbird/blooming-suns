--Clickspace Polygon
local UI_Poly = class('UI_Poly', {
	x = 0,
	y = 0,
	w = 10,
	h = 10, --AABB
	z = 0, --UI height
	vertices = {{0,0},{10,0},{5,10}}
})

function UI_Poly:init (spec)
	self.x = (spec and spec.x) or self.x
	self.y = (spec and spec.y) or self.y
	self.w = (spec and spec.w) or self.w
	self.h = (spec and spec.h) or self.h
	self.z = (spec and spec.z) or self.z
	if spec and spec.vertices and #spec.vertices > 2 then
		self.vertices = spec.vertices
	else
		self.vertices = {{0,0},{self.w,0},{self.w,self.h},{0,self.h}}
	end
end

function UI_Poly:containsPoint (q_x, q_y)
	return self:coordInAABB(q_x, q_y) and self:coordInPoly(q_x, q_y)
end

function UI_Poly:coordInAABB (q_x, q_y)
	return q_x > 0 and q_x < self.w and q_y > 0 and q_y < self.h
end

function UI_Poly:coordInPoly (q_x, q_y)
	if not self:coordInAABB(q_x, q_y) then return false end

	local j = #self.vertices
	local result = false

	for i = 1, #self.vertices do
		local a = self.vertices[j]
		local b = self.vertices[i]
		--print('Checking (' .. a[1] .. ',' .. a[2] .. ') -> (' .. b[1] .. ',' .. b[2] .. ')')
		if ((b[2] > q_y) ~= (a[2] > q_y)) and (q_x < (a[1] - b[1]) * (q_y - b[2]) / (a[2] - b[2]) + b[1]) then
			result = not result
		end
		j = i
	end

	return result
end

return UI_Poly
