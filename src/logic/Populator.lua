--Populator
Populator = {}

Populator.new = function (init)
  local init = init or {}
  local self = {}

  self.generateGameState = function()
    local gamestate = Gamestate.new()
    --Add players
    gamestate.addPlayer('Hazat', Player.new())
    gamestate.addPlayer('Hawkwood', Player.new())
    gamestate.setPlayerOrder({'Hazat', 'Hawkwood'})
    --Make Spacemap
    gamestate.addSpacemap(1, Spacemap.new())
    --Make Planetsides
    local rtilemap = self.generateTileMapTerrainRandom(1)
    gamestate.addTilemap(1, rtilemap)

    return gamestate
  end

  self.generateTileMapTerrainRandom = function (tilemap_id)
    local map = Tilemap.new()
    local nr = map.num_rows
    local nc = map.num_cols

    for j = 0, nc - 1 do
      for i = 0, nr - 1 do
        local terrain_type = "Grass";
        local rand = math.random()
        if i <= 1 or nr - i  < 3 then
          terrain_type = "Ice"
        elseif (i <= 4 or nr - i < 6) and rand > 0.5 then
          terrain_type = "Tundra"
        elseif rand > 0.345 then
          terrain_type = "Ocean"
        elseif rand > 0.22 then
          terrain_type = "Desert"
        elseif rand > 0.18 then
          terrain_type = "Steppe"
        end


        --Figure out Array, Pixel, & Grid Coordinates
        local col = j
        local row = i
        local idx = col * nr + row
        local size = map.hex_size

        local px_x = size * 3 / 2 * col
        local px_y = size * math.sqrt(3) * (row - 0.5 * (col % 2))

        local new_tile = Tile.new({
          location = Location.new({
            x = px_x,
            y = px_y,
            col = col,
            row = row,
            idx = idx,
            map = tilemap_id
          }),
          owning_map = map,
          idx = idx
        })
        new_tile.setTerrain(terrain_type)

        --Make a random stack of units maybe
        rand = math.random()
        if rand < 0.05 then
          local r_owner = "Hazat"
          local owner_color = {200,50,50}
          if math.random() > 0.5 then
            r_owner = "Hawkwood"
            owner_color = {50,50,200}
          end
          for i = 1 , math.floor(math.random() * 5) + 1 do
            if terrain_type ~= "Ocean" then
              local definition = require('assets/definitions/TestLandPaperUnit')
              definition.location = Location.new(new_tile.location)
              definition.owner = r_owner
              definition.backColor = owner_color
              local new_unit = Unit.new(definition)
              new_tile.relocateUnit(new_unit)
            end
          end
        end

        map.tiles[idx] = new_tile

        --Figure my neighborhood
        local N = idx - 1
        local S = idx + 1
        local NW, SW
        if j % 2 == 0 then
          NW = idx - nr
          SW = idx - nr + 1
        else
          NW = idx - nr - 1
          SW = idx - nr
        end
        local NE, SE
        if j % 2 == 0 then
          NE = idx + nr
          SE = idx + nr + 1
        else
          NE = idx + nr - 1
          SE = idx + nr
        end
        --Make worlds round
        if j == 0 then
          NW = (nc - 1) * nr + i
          SW = (nc - 1) * nr + 1 + i
        end
        if j == nc - 1 then
          NE = i - 1
          SE = i
        end

        --Generate Adjacency Graph
        map.terrain_connective_matrix[idx] = {air = {}, land = {}, sea = {}}
        if i ~= nr - 1 then
          map.terrain_connective_matrix[idx]['air'][S] = "S"
        end
        if i ~= 0 then
          map.terrain_connective_matrix[idx]['air'][N] = "N"
        end
        if i ~= 0 or (i == 0 and j % 2 == 0 )then
          map.terrain_connective_matrix[idx]['air'][NE] = "NE"
          map.terrain_connective_matrix[idx]['air'][NW] = "NW"
        end
        if i ~= nr - 1 or (i == nr - 1 and j % 2 ~= 0) then
          map.terrain_connective_matrix[idx]['air'][SE] = "SE"
          map.terrain_connective_matrix[idx]['air'][SW] = "SW"
        end
        --Generate Terrain Costs
        map.terrain_connective_matrix[idx]['mpcost'] = map.terrain_type_move_costs[terrain_type]

      end
    end

    --Check Air Adjacency Grid
    local wrongConnects = 0
    for i, v in pairs(map.terrain_connective_matrix) do
      for j, k in pairs(map.terrain_connective_matrix[i]['air']) do
        if j > #map.tiles then
          wrongConnects = wrongConnects + 1
        end
      end
    end
    --Generate Land Connectedness Graph
    for i, v in pairs(map.tiles) do
      for j, k in pairs(map.terrain_connective_matrix[v.idx]['air']) do
        if map.tiles[j] ~= nil and map.tiles[j].terrain_type ~= 'Ocean' and map.tiles[v.idx].terrain_type ~= 'Ocean' then
          map.terrain_connective_matrix[v.idx]['land'][j] = true
        end
      end
    end
    --Generate Sea Connectedness Graph
    for i, v in pairs(map.tiles) do
      for j, k in pairs(map.terrain_connective_matrix[v.idx]['air']) do
        if map.tiles[j] ~= nil and map.tiles[j].terrain_type == 'Ocean' and map.tiles[v.idx].terrain_type == 'Ocean' then
          map.terrain_connective_matrix[v.idx]['sea'][j] = true
        end
      end
    end

    return map;
  end

  return self
end
