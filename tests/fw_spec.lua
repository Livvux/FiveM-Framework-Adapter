-- Busted unit tests for the adapter surface (runs in CI, not on FiveM)
package.path = package.path .. ';./?.lua;./?/init.lua'

local function makeStub(framework)
  _G.Adapters = {}
  if framework == 'esx' then
    _G.exports = { ['es_extended'] = { getSharedObject = function()
      return {
        GetPlayerFromId = function(src)
          return {source = src, identifier = 'license:abc', getMoney = function() return 100 end,
                  addMoney = function() end, removeMoney = function() end,
                  getJob = function() return {name='mechanic', grade=2} end,
                  addAccountMoney=function() end, removeAccountMoney=function() end,
                  addInventoryItem=function() end, removeInventoryItem=function() end,
                  getName=function() return 'Alex ESX' end }
        end
      }
    end } }
    _G.GetResourceState = function(n) return n=='es_extended' and 'started' or 'missing' end
    dofile('shared/adapters/esx.lua')
  elseif framework == 'qbcore' then
    _G.exports = { ['qb-core'] = { GetCoreObject = function()
      return { Functions = { GetPlayer=function(src)
        return { PlayerData={source=src,citizenid='CITZ123',job={name='mechanic',grade=2},
                              money={cash=100,bank=500},charinfo={firstname='Alex',lastname='QB'}},
                 Functions={AddMoney=function() end, RemoveMoney=function() end, AddItem=function() return true end, RemoveItem=function() return true end} }
      end } }
    end } }
    _G.GetResourceState = function(n) return n=='qb-core' and 'started' or 'missing' end
    dofile('shared/adapters/qb.lua')
  elseif framework == 'qbox' then
    _G.exports = { ['qbx_core'] = setmetatable({}, { __index = function()
      return function(...) end
    end }) }
    _G.GetResourceState = function(n) return n=='qbx_core' and 'started' or 'missing' end
    dofile('shared/adapters/qbox.lua')
  end
  dofile('shared/fw.lua')
end

describe('FW contract', function()
  it('resolves player and money (esx)', function()
    makeStub('esx')
    assert.are.equal('esx', FW.meta.name())
    local p = FW.Player.getBySrc(1)
    assert.are.equal('license:abc', FW.Player.getStateId(p))
    assert.are.equal(100, FW.Money.get(p, 'cash'))
  end)

  it('resolves player and money (qbcore)', function()
    makeStub('qbcore')
    assert.are.equal('qbcore', FW.meta.name())
    local p = FW.Player.getBySrc(2)
    assert.are.equal('CITZ123', FW.Player.getStateId(p))
    assert.are.equal(100, FW.Money.get(p, 'cash'))
  end)
end)
