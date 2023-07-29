-- [Jay Script's] --

-- Simple GTA Notification
function Notify( text )
    SetNotificationTextEntry( "STRING" )
    AddTextComponentString( text )
    DrawNotification( false, false )
end

-- Client-side event handler for the 'showNotification' event
RegisterNetEvent('JayScripts:Notify')
AddEventHandler('JayScripts:Notify', function(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end)