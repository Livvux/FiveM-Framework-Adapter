-- Minimal notify handler used by the adapters
RegisterNetEvent('fw:notify', function(message, kind)
  -- Try ox_lib if present, else fallback to chat
  if lib and lib.notify then
    lib.notify({ title = 'FW', description = message, type = kind or 'inform' })
  else
    TriggerEvent('chat:addMessage', { args = { '^2[FW]^0', tostring(message) } })
  end
end)
