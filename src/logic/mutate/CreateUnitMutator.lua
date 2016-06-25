CreateUnitMutator = {}

CreateUnitMutator.new = function (init)
  local init = init or {}
  local self = Mutator.new(init)

  self.state = init.state
  self.player = init.player
  self.tile = init.tile
  self.type = init.type
  self.unit = nil

  self.constructor = function ()
    if type == "Noble" then
      return Unit.new({
        sprite = "TestUnit",
        move_domain = "land",
        move_method = "walk",
        location = self.loc,
        owner = self.player,
        backColor = self.player.owner_color
        })
    elseif type == "Boat" then
      return Unit.new({
        sprite = "TestSeaUnit",
        move_domain = "land",
        move_method = "sail",
        location = self.loc,
        owner = self.player,
        backColor = self.player.owner_color
        })
    end
  end

  self.execute = function ()
    self.unit = self.constructor()
    self.tile.relocateUnit(self.unit)
  end

  self.undo = function ()
    self.tile.delocateUnit(self.unit)
  end

  return self
end
