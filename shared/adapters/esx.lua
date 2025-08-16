Adapters = Adapters or {}

Adapters.esx = function()
  local ESX = exports['es_extended']:getSharedObject()

  local M = {
    meta = { name = function() return 'esx' end },
    Player = {}, Job = {}, Money = {}, Inv = {}, Events = {}
  }

  -- Player
  function M.Player.getBySrc(src) return ESX.GetPlayerFromId(src) end
  function M.Player.getStateId(p) return p.identifier end
  function M.Player.getServerId(p) return p.source end
  function M.Player.getName(p) return p.getName and p.getName() or GetPlayerName(p.source) end

  -- Job
  function M.Job.getName(p) return (p.getJob and p.getJob().name) or (p.job and p.job.name) end
  function M.Job.getGrade(p)
    local j = p.getJob and p.getJob() or p.job
    return j and (j.grade or (j.grade and j.grade.grade))
  end
  function M.Job.onChange(handler)
    RegisterNetEvent('esx:setJob', function(job)
      local src = source
      handler(src, nil, job and job.name)
    end)
  end

  -- Money
  local function norm(account) return account == 'cash' and 'money' or account end
  function M.Money.get(p, account)
    account = norm(account)
    if account == 'money' then return p.getMoney() end
    local acc = p.getAccount and p.getAccount(account)
    return acc and acc.money or 0
  end
  function M.Money.add(p, account, amount)
    account = norm(account)
    if account == 'money' then p.addMoney(amount) else p.addAccountMoney(account, amount) end
  end
  function M.Money.remove(p, account, amount)
    account = norm(account)
    if account == 'money' then p.removeMoney(amount) else p.removeAccountMoney(account, amount) end
  end

  -- Inventory (ESX native, with ox fallback)
  local hasOX = GetResourceState('ox_inventory') == 'started'
  if hasOX then
    function M.Inv.addItem(p, name, count, meta) return exports.ox_inventory:AddItem(p.source, name, count, meta) end
    function M.Inv.removeItem(p, name, count, meta) return exports.ox_inventory:RemoveItem(p.source, name, count, meta) end
  else
    function M.Inv.addItem(p, name, count) p.addInventoryItem(name, count); return true end
    function M.Inv.removeItem(p, name, count) p.removeInventoryItem(name, count); return true end
  end

  -- Events
  function M.Events.notify(target, msg, kind)
    kind = kind or 'info'
    TriggerClientEvent('fw:notify', target, msg, kind)
  end
  function M.Events.onPlayerLoaded(handler)
    RegisterNetEvent('esx:playerLoaded', function(_)
      handler(source)
    end)
  end

  return M
end
