Adapters = Adapters or {}

Adapters.qb = function()
  local QBCore = exports['qb-core']:GetCoreObject()

  local M = {
    meta = { name = function() return 'qbcore' end },
    Player = {}, Job = {}, Money = {}, Inv = {}, Events = {}
  }

  -- Player
  function M.Player.getBySrc(src) return QBCore.Functions.GetPlayer(src) end
  function M.Player.getStateId(p) return p.PlayerData.citizenid end
  function M.Player.getServerId(p) return p.PlayerData.source end
  function M.Player.getName(p)
    local pd = p.PlayerData
    return (pd.charinfo and (pd.charinfo.firstname .. ' ' .. pd.charinfo.lastname)) or GetPlayerName(pd.source)
  end

  -- Job
  function M.Job.getName(p) return p.PlayerData.job.name end
  function M.Job.getGrade(p)
    local g = p.PlayerData.job.grade
    return type(g) == 'table' and (g.level or g.grade) or g
  end
  function M.Job.onChange(handler)
    RegisterNetEvent('QBCore:Server:OnJobUpdate', function(job)
      handler(source, nil, job and job.name)
    end)
  end

  -- Money
  function M.Money.get(p, account) return p.PlayerData.money[account] or 0 end
  function M.Money.add(p, account, amount, reason) p.Functions.AddMoney(account, amount, reason or 'fw') end
  function M.Money.remove(p, account, amount, reason) p.Functions.RemoveMoney(account, amount, reason or 'fw') end

  -- Inventory (qb-inventory or ox)
  local hasOX = GetResourceState('ox_inventory') == 'started'
  if hasOX then
    function M.Inv.addItem(p, name, count, meta) return exports.ox_inventory:AddItem(p.PlayerData.source, name, count, meta) end
    function M.Inv.removeItem(p, name, count, meta) return exports.ox_inventory:RemoveItem(p.PlayerData.source, name, count, meta) end
  else
    function M.Inv.addItem(p, name, count, meta) return p.Functions.AddItem(name, count, false, meta) end
    function M.Inv.removeItem(p, name, count) return p.Functions.RemoveItem(name, count) end
  end

  -- Events
  function M.Events.notify(target, msg, kind)
    TriggerClientEvent('fw:notify', target, msg, kind or 'info')
  end
  function M.Events.onPlayerLoaded(handler)
    RegisterNetEvent('QBCore:Server:PlayerLoaded', function()
      handler(source)
    end)
  end

  return M
end
