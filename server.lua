function Identifier(player)
    for _,v in pairs(GetPlayerIdentifiers(player)) do
        if Config.Identifier == 'steam' then  
             if string.match(v, 'steam') then
                  return v
             end
        elseif Config.Identifier == 'license' then
             if string.match(v, 'license:') then
                  return string.sub(v, 9)
             end
        end
    end
    return ''
end

RegisterNetEvent('mx-serverman:Ban')
AddEventHandler('mx-serverman:Ban', function (admin, id, reason, time)
    local ReasonX = {}
    for i = 4, #reason do
         table.insert(ReasonX, reason[i])
    end
    if GetPlayerName(id) then
        local license, steam, liveid, xblid, discord, playerip = table.unpack(GetIdentifiers(id))
        local embed = {
            fields = {
                {name = 'Player ID', value = id},
                {name = 'Steam', value = steam},
                {name = 'Identifier', value = Identifier(id)},
                {name = 'License', value = license},
                {name = 'Ip Adress', value = playerip},
                {name = 'Admin', value = '<@'..admin.id..'>'},
                {name = 'Reason', value = table.concat(ReasonX, ' ')},
                {name = 'Time', value = os.date('%d.%m.%Y %H:%M', os.time() + time)}
            },
            color = "#0094ff", -- blue
            author = 'SUCCESS'
        }
        TriggerEvent('mx-serverman:SendEmbed', embed)
        local insert = [[INSERT INTO bannedplayers
        (identifier, name, admin, steam, rockstar, xbox, live, discord, ip, reason, time) 
        VALUES
        (@i, @n, @a, @s, @r, @x, @l, @d, @ip, @re, @t);]]
        local inserData = {
            ['@i'] = Identifier(id),
            ['@n'] = GetPlayerName(id),
            ['@a'] = admin.id,
            ['@s'] = steam,
            ['@r'] = license,
            ['@x'] = xblid,
            ['@l'] = liveid,
            ['@d'] = discord,
            ['@ip'] = playerip,
            ['@re'] = table.concat(ReasonX, ' '),
            ['@t'] = os.time() + time
        }
        MySQL.Sync.execute(insert, inserData)
        DropPlayer(id, 'You have been banned by the management bot. Reason: '..table.concat(ReasonX, ' ')..' When the ban will open: '..os.date('%d.%m.%Y %H:%M', os.time() + time))
    else
        local fetch = [[SELECT identifier FROM users WHERE identifier = @id;]]
        local fetchData = {['@id'] = id}
        local result = MySQL.Sync.fetchAll(fetch, fetchData)
        if result and result[1] then
            MySQL.Sync.execute('INSERT INTO bannedplayers (identifier, reason, time, admin) VALUES (@identifier, @reason, @time, @admin)', {
                ['@identifier'] = id,
                ['@reason'] = table.concat(ReasonX, ' '),
                ['@time'] = os.time() + time,
                ['@admin'] = admin.username
           })  
           local embed = {
                fields = {
                    {name = 'Player Identifier', value = id},
                    {name = 'Admin', value = '<@'..admin.id..'>'},
                    {name = 'Reason', value = table.concat(ReasonX, ' ')},
                    {name = 'Time', value = os.date('%d.%m.%Y %H:%M', os.time() + time)}
                },
                color = "#0094ff", -- blue
                author = 'SUCCESS'
            }
            TriggerEvent('mx-serverman:SendEmbed', embed)
        else
            local embed = {
                description = "Not finded identifier / id",
                color = "#ff0000",
                author = 'WARNING'
            }
            TriggerEvent('mx-serverman:SendEmbed', embed)
        end
    end
end)

IsAdmin = function (player)
     for _,v in pairs(Config.AdminGroups) do
          if player.getGroup() == v then
               return true
          end
     end
     return false
end

Ban = function(source, target, time, reason)
    if source == 0 then
        if GetPlayerName(target) then
            local license, steam, liveid, xblid, discord, playerip = table.unpack(GetIdentifiers(target))
            local insert = [[INSERT INTO bannedplayers
            (identifier, name, admin, steam, rockstar, xbox, live, discord, ip, reason, time) VALUES
            (@i, @n, @a, @s, @r, @x, @l, @d, @ip, @re, @t);]]
            local inserData = {
                ['@i'] = Identifier(target),
                ['@n'] = GetPlayerName(target),
                ['@a'] = 'CONSOLE',
                ['@s'] = steam,
                ['@r'] = license,
                ['@x'] = xblid,
                ['@l'] = liveid,
                ['@d'] = discord,
                ['@ip'] = playerip,
                ['@re'] = reason,
                ['@t'] = os.time() + time
            }
            MySQL.Sync.execute(insert, inserData)
            DropPlayer(target, 'You have been banned by the management bot. Reason: '..reason..' When the ban will open: '..os.date('%d.%m.%Y %H:%M', os.time() + time))
        else
            local fetch = [[SELECT identifier FROM users WHERE identifier = @id;]]
            local fetchData = {['@id'] = target}
            local result = MySQL.Sync.fetchAll(fetch, fetchData)
            if result and result[1] then
                MySQL.Sync.execute('INSERT INTO bannedplayers (identifier, reason, time, admin) VALUES (@identifier, @reason, @time, @admin)', {
                    ['@identifier'] = target,
                    ['@reason'] = reason,
                    ['@time'] = os.time() + time,
                    ['@admin'] = 'CONSOLE'
               })  
            else
                print('^1[MX-BANSYSTEM] ^2Player Is Not Online ^0')
            end
        end
    else
        if GetPlayerName(target) then
            local license, steam, liveid, xblid, discord, playerip = table.unpack(GetIdentifiers(target))
            local insert = [[INSERT INTO bannedplayers
            (identifier, name, admin, steam, rockstar, xbox, live, discord, ip, reason, time) VALUES
            (@i, @n, @a, @s, @r, @x, @l, @d, @ip, @re, @t);]]
            local inserData = {
                ['@i'] = Identifier(target),
                ['@n'] = GetPlayerName(target),
                ['@a'] = GetPlayerName(source),
                ['@s'] = steam,
                ['@r'] = license,
                ['@x'] = xblid,
                ['@l'] = liveid,
                ['@d'] = discord,
                ['@ip'] = playerip,
                ['@re'] = reason,
                ['@t'] = os.time() + time
            }
            MySQL.Sync.execute(insert, inserData)
            DropPlayer(target, 'You have been banned by the management bot. Reason: '..reason..' When the ban will open: '..os.date('%d.%m.%Y %H:%M', os.time() + time))
        else
            local fetch = [[SELECT identifier FROM users WHERE identifier = @id;]]
            local fetchData = {['@id'] = target}
            local result = MySQL.Sync.fetchAll(fetch, fetchData)
            if result and result[1] then
                MySQL.Sync.execute('INSERT INTO bannedplayers (identifier, reason, time, admin) VALUES (@identifier, @reason, @time, @admin)', {
                    ['@identifier'] = target,
                    ['@reason'] = reason,
                    ['@time'] = os.time() + time,
                    ['@admin'] = GetPlayerName(source)
               })  
            else
                 TriggerClientEvent('chat:addMessage', source, {
                      color = { 255, 0, 0},
                      multiline = true,
                      args = {"Me", "Player Is Not Online !"}
                 })   
            end
        end
    end
end

RegisterCommand('kick', function (source, args)
    if source == 0 then
        if args[1] and args[2] then
            if GetPlayerName(args[1]) then
                local reason = {}
                for i = 2, #args do
                     table.insert(reason, args[i])
                end
                DropPlayer(args[1], table.concat(reason, ' '))
            else
                print('^1[MX-BANSYSTEM] ^2Player Is Not Online ^0') 
            end
        else
            print('^1[MX-BANSYSTEM] ^2Usage: /kick id reason \n^3Example Usage /kick 1 Why Not xd ^0') 
        end
    else
        if args[1] and args[2] then
            if GetPlayerName(args[1]) then
                TriggerEvent('esx:getSharedObject', function(ESX) 
                    local xPlayer = ESX.GetPlayerFromId(source)
                    if xPlayer then
                         if IsAdmin(xPlayer) then
                              local reason = {}
                              for i = 2, #args do
                                   table.insert(reason, args[i])
                              end
                              DropPlayer(args[1], table.concat(reason, ' '))
                         else
                              TriggerClientEvent('chat:addMessage', source, {
                                   color = { 255, 0, 0},
                                   multiline = true,
                                   args = {"Me", "You Are Not Admin !"}
                              })  
                         end  
                    end
                end)
            else
                TriggerClientEvent('chat:addMessage', source, {
                     color = { 255, 0, 0},
                     multiline = true,
                     args = {"Me", "Player Is Not Online"}
                })   
            end
        else
            TriggerClientEvent('chat:addMessage', source, {
                 color = { 255, 0, 0},
                 multiline = true,
                 args = {"Me", "Usage: /kick id reason example /kick 1 Why Not xd"}
            })   
        end
    end
end)

RegisterNetEvent('mx-serverman:Kick')
AddEventHandler('mx-serverman:Kick', function (admin, id, reason)
    local playername = GetPlayerName(id)
    local ReasonX = {}
    for i = 3, #reason do
         table.insert(ReasonX, reason[i])
    end
    if GetPlayerName(id) then
        DropPlayer(id, table.concat(ReasonX, ' '))
        local embed = {
            fields = {
                {name = 'Player', value = playername},
                {name = 'Admin', value = '<@'..admin.id..'>'},
                {name = 'Reason', value = table.concat(ReasonX, ' ')}
            },
            color = "#0094ff", -- blue
            author = 'SUCCESS'
        }
        TriggerEvent('mx-serverman:SendEmbed', embed)
    else
        local embed = {
            description = "Not finded id",
            color = "#ff0000",
            author = 'WARNING'
        }
        TriggerEvent('mx-serverman:SendEmbed', embed)
    end
end)

RegisterNetEvent('mx-serverman:Unban')
AddEventHandler('mx-serverman:Unban', function (id)
    local fetch = [[SELECT identifier FROM bannedplayers WHERE identifier = @id LIMIT 1;]]
    local fetchData = {['@id'] = id}
    local result = MySQL.Sync.fetchAll(fetch, fetchData)
    if result and result[1] then
        MySQL.Sync.execute('DELETE FROM bannedplayers WHERE identifier = @identifier', {['@identifier'] = id})
        local embed = {
            title = id..' `Ban Removed`',
            color = "#0094ff",
            author = 'SUCCESS'
        }
        TriggerEvent('mx-serverman:SendEmbed', embed)
    else
        local embed = {
            description = "Player is not banned",
            color = "#ff0000",
            author = 'WARNING'
        }
        TriggerEvent('mx-serverman:SendEmbed', embed)
    end
end)

RegisterCommand('ban', function (source, args)
    if source == 0 then
        if args[1] and args[2] and tonumber(args[2]) and args[3] then
            local reason = {}
            for i = 3, #args do
                 table.insert(reason, args[i])
            end
            Ban(source, args[1], tonumber(args[2]), table.concat(reason, ' '))
       else
            print('^1[MX-BANSYSTEM] ^2Usage: /ban id or identifier time[second] reason \n^3Example Usage /ban 1 36000[second] Why Not xd ^0') 
       end
    else
        if args[1] and args[2] and tonumber(args[2]) and args[3] then
            TriggerEvent('esx:getSharedObject', function(ESX) 
                local xPlayer = ESX.GetPlayerFromId(source)
                if xPlayer then
                     if IsAdmin(xPlayer) then
                          local reason = {}
                          for i = 3, #args do
                               table.insert(reason, args[i])
                          end
                          Ban(source, args[1], tonumber(args[2]), table.concat(reason, ' '))
                     else
                          TriggerClientEvent('chat:addMessage', source, {
                               color = { 255, 0, 0},
                               multiline = true,
                               args = {"Me", "You Are Not Admin !"}
                          })  
                     end               
                end
            end)
       else
            TriggerClientEvent('chat:addMessage', source, {
                 color = { 255, 0, 0},
                 multiline = true,
                 args = {"Me", "Usage: /ban id or identifier time[second] reason example /ban 1 36000[second] Why Not xd"}
            })   
       end
    end
end)


function GetIdentifiers(id)
    local license, steam, liveid, xblid, discord, ipadress
    for _,v in ipairs(GetPlayerIdentifiers(id)) do
        if string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
        elseif string.sub(v, 1, string.len("steam:")) == "steam:" then
            steam = v
        elseif string.sub(v, 1, string.len("live:")) == "live:" then
            liveid = v
        elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
            xblid  = v
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discord = v
        elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
            ipadress = v
        end
    end
    return {
        license,
        steam,
        liveid,
        xblid,
        discord,
        ipadress
    }
end

AddEventHandler('playerConnecting', function(name, setCallback, deferrals) 
    local src = source
    local license, steam, liveid, xblid, discord, playerip = table.unpack(GetIdentifiers(src))
    deferrals.defer()
    deferrals.update('Checking Ban List')

    print(Identifier(src))
    
    local fetch = [[SELECT * FROM bannedplayers WHERE identifier = @i OR rockstar = @r OR steam = @s OR ip = @ip;]]
    local fetchData = {
        ['@i'] = Identifier(src),
        ['@r'] = license,
        ['@s'] = steam,
        ['@ip'] = playerip
    }
    local result = MySQL.Sync.fetchAll(fetch, fetchData)
    if result and result[1] then
        if result[1].time > os.time() then
            deferrals.done('You have been banned from this server. \n Reason: '..result[1].reason..'\n The date the ban will end: '..os.date('%d.%m.%Y %H:%M', result[1].time))
            return
        else
            MySQL.Sync.execute('DELETE FROM bannedplayers WHERE identifier = @identifier', {['@identifier'] = result[1].identifier})
            deferrals.done()
        end
    else
        deferrals.done()
    end
end)