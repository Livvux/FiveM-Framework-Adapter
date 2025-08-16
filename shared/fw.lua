-- framework bridge bootstrap
FW = FW or {}

local function started(name)
  local st = GetResourceState(name)
  return st == 'started' or st == 'starting'
end

local which
if started('qbx_core') then which = 'qbox'
elseif started('qb-core') then which = 'qbcore'
elseif started('es_extended') then which = 'esx' end

if which == 'qbcore' then
  FW = Adapters.qb()
elseif which == 'qbox' then
  FW = Adapters.qbox()
elseif which == 'esx' then
  FW = Adapters.esx()
else
  error('[FW] No supported framework found (es_extended / qb-core / qbx_core).')
end

function FW.meta.has(res)
  local st = GetResourceState(res)
  return st == 'started' or st == 'starting'
end
