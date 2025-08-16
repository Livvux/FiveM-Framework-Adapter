local resourceName = GetCurrentResourceName()
print(('[%s] starting with framework: %s'):format(resourceName, FW.meta.name()))

-- Simple demo command: /fwbonus
RegisterCommand('fwbonus', function(source, args, raw)
  local src = source
  local p = FW.Player.getBySrc(src)
  if not p then return end

  if FW.Job.getName(p) == 'delivery' then
    FW.Money.add(p, 'cash', 250, 'delivery-bonus')
    FW.Events.notify(src, 'Bonus paid (+$250).', 'success')
  else
    FW.Events.notify(src, 'You are not on duty as Delivery.', 'error')
  end
end, false)

-- Example event for blog snippet
RegisterNetEvent('myres:payBonus', function()
  local src = source
  local p = FW.Player.getBySrc(src)
  if not p then return end
  FW.Money.add(p, 'cash', 250, 'delivery-bonus')
  FW.Events.notify(src, 'Bonus paid (+$250).', 'success')
end)

-- Give starter items when player loads (ox inventory or framework inventory)
local function giveStarter(src)
  local p = FW.Player.getBySrc(src)
  if p then FW.Inv.addItem(p, 'water', 2) end
end
FW.Events.onPlayerLoaded(giveStarter)
