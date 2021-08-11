ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local dumspterModel = {
    218085040,
    666561306,
    -58485588,
    -206690185,
    1511880420,
    682791951,
}

exports['qtarget']:AddTargetModel(dumspterModel, {
    options = {
        {
            event = 'dumpsterTrigger',
            icon = 'fas fa-dumpster',
            label = 'Search Dumpster',
            canInteract = function(entity)
                return true
            end
        },
    },
    job = {'all'},
    distance = 1.5
})


local Searched = {}

function CheckSearch(dumpster)
    local dumpstermodel = dumpster.entity
    for k, v in ipairs(Searched) do
        if v == dumpstermodel then
            return true
        end
    end
    return false
end


RegisterNetEvent('dumpsterTrigger')
AddEventHandler('dumpsterTrigger', function(data)
    local dumpstermodel = data.entity
    print(dumpstermodel)
    if CheckSearch(data) then
        exports['mythic_notify']:SendAlert('error', "You've already searched this dumpster")
    else
        exports['mythic_notify']:SendAlert('inform', "Searching Dumpster")
        table.insert(Searched, dumpstermodel)
        TriggerEvent('dumpster:starttimer', dumpstermodel)
        SearchDumpster()
    end
end)

function SearchDumpster()
    local time = math.random(30000, 40000)
    exports['mythic_progbar']:Progress({
        name = "unique_action_name",
        duration = time,
        label = 'Searching Dumpster',
        useWhileDead = false,
        canCancel = false,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
          animDict = "mini@repair",
          anim = "fixing_a_ped",
        },
    })
    Citizen.Wait(time)
    ClearPedTasks(PlayerPedId(-1))
    TriggerServerEvent('dumpster:givereward')
end

RegisterNetEvent('dumpster:starttimer')
AddEventHandler('dumpster:starttimer', function(dumpster)
    local timer = 7 * 60000
    while timer > 0 do
        Wait(1000)
        timer = timer - 1000
        if timer == 0 then
            for i = 1, #Searched do
                if Searched[i] == dumpster then
                    table.remove(Searched, i)
                end
            end
        end
    end
end)