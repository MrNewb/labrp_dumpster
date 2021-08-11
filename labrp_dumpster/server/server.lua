ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--[[ item setup
chance (1-10) - lower = more common
id - Item ID
name - Item Name
quantity = amount you get when you find the item
]]
   local dumpsterItems = {
    [1] = {chance = 3, id = 'advancedlockpick', name = 'Advanced Lockpick', quantity = 1},
}


RegisterServerEvent('dumpster:givereward')
AddEventHandler('dumpster:givereward', function()
 local source = tonumber(source)
 local item = {}
 local xPlayer = ESX.GetPlayerFromId(source)
 local gotID = {}


 for i=1, math.random(1, 2) do
  item = dumpsterItems[math.random(1, #dumpsterItems)]
  if math.random(1, 10) >= item.chance then
   if tonumber(item.id) == 0 and not gotID[item.id] then
    gotID[item.id] = true
    xPlayer.addMoney(item.quantity)
   elseif not gotID[item.id] then
    gotID[item.id] = true
    xPlayer.addInventoryItem(item.id, item.quantity)
   end
  end
 end
end)

