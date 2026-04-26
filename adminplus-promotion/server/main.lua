local ESX, QBCore

if Config.Framework == 1 then
    ESX = exports[Config.FrameworkExport]:getSharedObject()
elseif Config.Framework == 2 then
    QBCore = exports[Config.FrameworkExport]:GetCoreObject()
else
    print('[AdminPlus Promotion] No Framework Detected Server')
end

-- ─── Helpers ─────────────────────────────────────────────────────────────────

-- Send a lb-phone notification to every connected player individually so the
-- correct app icon appears on their lock screen (NotifyEveryone uses a generic
-- display and does not resolve per-app icons reliably).
local function lbPhoneSendAll(app, title, content)
    for _, playerId in ipairs(GetPlayers()) do
        exports['lb-phone']:SendNotification(tonumber(playerId), {
            app     = app,
            title   = title,
            content = content,
        })
    end
end

-- Send lb-phone EmergencyNotification to every connected player (amber alert).
local function lbPhoneEmergencyAll(title, content)
    for _, playerId in ipairs(GetPlayers()) do
        exports['lb-phone']:EmergencyNotification(tonumber(playerId), {
            title   = title,
            content = content,
            icon    = 'warning',
        })
    end
end

local function broadcastPromotion(src, playerName, jobLabel, message)
    local title      = Config.Strings.business_promotion2 .. jobLabel
    local phoneTitle = playerName .. ' - ' .. jobLabel

    if Config.ChatMessage then
        TriggerClientEvent('chat:addMessage', -1, {
            color     = { 255, 133, 0 },
            multiline = true,
            args      = { title, playerName .. ': ' .. message },
        })
    end

    if Config.Ox_LibNotify then
        TriggerClientEvent('ox_lib:notify', -1, {
            title       = title,
            description = playerName .. '\n\n' .. Config.Strings.job .. jobLabel .. '\n\n- ' .. message,
            position    = Config.NotifyPosition,
            icon        = Config.BusinessIcon,
            iconColor   = '#f59e0b',
            type        = 'inform',
            duration    = 10000,
        })
    end

    -- Phone number used for Birdy username lookup and YellowPages DB insert
    local phoneNumber = src and exports['lb-phone']:GetEquippedPhoneNumber(src) or nil

    -- Birdy (Twitter): PostBirdy creates an actual post in the feed
    if Config.LbPhone.Twitter then
        local posted = false
        if phoneNumber then
            local username = exports['lb-phone']:GetSocialMediaUsername(phoneNumber, 'birdy')
            if username then
                local success, postId = exports['lb-phone']:PostBirdy(username, phoneTitle .. '\n' .. message, nil, nil, nil)
                if success then
                    print(('[AdminPlus Promotion] Birdy post created: %s (id: %s)'):format(username, tostring(postId)))
                    posted = true
                else
                    print(('[AdminPlus Promotion] Birdy PostBirdy failed for username: %s'):format(username))
                end
            else
                print(('[AdminPlus Promotion] Birdy: no username found for phone %s'):format(phoneNumber))
            end
        else
            print('[AdminPlus Promotion] Birdy: player has no equipped phone number')
        end
        lbPhoneSendAll('Birdy', phoneTitle, message)
        if not posted then
            print('[AdminPlus Promotion] Birdy: fell back to notification-only (no post created)')
        end
    end

    -- Instagram (InstaPic): notification to all phones
    if Config.LbPhone.Instagram then
        lbPhoneSendAll('InstaPic', phoneTitle, message)
    end

    -- YellowPages: DB insert creates actual Pages listing + notification to all phones
    if Config.LbPhone.YellowPages then
        if phoneNumber then
            local insertId = MySQL.insert.await(
                'INSERT INTO phone_yellow_pages_posts (phone_number, title, description, attachment, price, timestamp) VALUES (?, ?, ?, NULL, NULL, NOW())',
                { phoneNumber, phoneTitle, message }
            )
            if insertId then
                TriggerClientEvent('lb-phone:pages:newPost', -1, {
                    id          = tostring(insertId),
                    number      = phoneNumber,
                    title       = phoneTitle,
                    description = message,
                })
            end
        end
        lbPhoneSendAll('YellowPages', phoneTitle, message)
    end

    -- Marketplace: notification to all phones
    if Config.LbPhone.Marketplace then
        lbPhoneSendAll('Marketplace', phoneTitle, message)
    end

    -- Mail: notification to all phones
    if Config.LbPhone.Mail then
        lbPhoneSendAll('Mail', phoneTitle, message)
    end

    print(('[AdminPlus Promotion] %s (%s): %s'):format(playerName, jobLabel, message))
end

local function isAuthorizedForAmberAlert(jobName, jobGrade)
    for _, entry in ipairs(Config.AuthorizedJobs) do
        if entry.job == jobName and jobGrade >= entry.grade then
            return true
        end
    end
    return false
end

-- ─── ESX ─────────────────────────────────────────────────────────────────────

if Config.Framework == 1 then

    ESX.RegisterServerCallback('businessPromotion:getJobs', function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then return cb(0) end
        local cost = Config.PromotionCosts[xPlayer.getJob().name] or 0
        cb(cost)
    end)

    ESX.RegisterServerCallback('businessPromotion:getPlayerName', function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then return cb('Unknown') end
        cb(xPlayer.getName())
    end)

    ESX.RegisterServerCallback('businessPromotion:getPlayerMoney', function(source, cb)
        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then return cb(0) end
        cb(xPlayer.getMoney())
    end)

    RegisterNetEvent('businessPromotion:removeMoney')
    AddEventHandler('businessPromotion:removeMoney', function(cost)
        local src     = source
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer then
            xPlayer.removeMoney(math.abs(tonumber(cost) or 0))
            print(('[AdminPlus Promotion] Charged $%s from player %s'):format(cost, src))
        end
    end)

    RegisterNetEvent('businessPromotion:showNotification')
    AddEventHandler('businessPromotion:showNotification', function(playerName, jobLabel, message)
        local src = source
        broadcastPromotion(src, playerName, jobLabel, message)
    end)

    -- /promotion command
    RegisterCommand('promotion', function(source, args)
        if source == 0 then return end
        if #args == 0 then return end
        TriggerClientEvent('businessPromotion:getCost', source, args)
    end, false)

    -- /amberalert command
    RegisterCommand(Config.AmberAlertCommand, function(source, args)
        if source == 0 then return end
        if not Config.AmberAlert then return end
        if #args == 0 then return end

        local xPlayer = ESX.GetPlayerFromId(source)
        if not xPlayer then return end

        local job = xPlayer.getJob()
        if not isAuthorizedForAmberAlert(job.name, job.grade) then
            TriggerClientEvent('ox_lib:notify', source, {
                title       = Config.Strings.amber_alert,
                description = Config.Strings.you_are_not_allowed_amberalert,
                position    = Config.NotifyPosition,
                icon        = Config.Icon,
                type        = 'error',
                duration    = 10000,
            })
            return
        end

        local alertMsg = table.concat(args, ' ')
        lbPhoneEmergencyAll(Config.Strings.amber_alert, alertMsg)
        print(('[AdminPlus Promotion] Amber Alert by %s: %s'):format(xPlayer.getName(), alertMsg))
    end, false)

-- ─── QB-Core ──────────────────────────────────────────────────────────────────

elseif Config.Framework == 2 then

    QBCore.Functions.CreateCallback('businessPromotion:getJobs', function(source, cb)
        local Player = QBCore.Functions.GetPlayer(source)
        if not Player then return cb(0) end
        local cost = Config.PromotionCosts[Player.PlayerData.job.name] or 0
        cb(cost)
    end)

    QBCore.Functions.CreateCallback('businessPromotion:getPlayerName', function(source, cb)
        local Player = QBCore.Functions.GetPlayer(source)
        if not Player then return cb('Unknown') end
        local info = Player.PlayerData.charinfo
        cb(info.firstname .. ' ' .. info.lastname)
    end)

    QBCore.Functions.CreateCallback('businessPromotion:getPlayerMoney', function(source, cb)
        local Player = QBCore.Functions.GetPlayer(source)
        if not Player then return cb(0) end
        cb(Player.PlayerData.money['cash'])
    end)

    RegisterNetEvent('businessPromotion:removeMoney')
    AddEventHandler('businessPromotion:removeMoney', function(cost)
        local src    = source
        local Player = QBCore.Functions.GetPlayer(src)
        if Player then
            Player.Functions.RemoveMoney('cash', math.abs(tonumber(cost) or 0))
            print(('[AdminPlus Promotion] Charged $%s from player %s'):format(cost, src))
        end
    end)

    RegisterNetEvent('businessPromotion:showNotification')
    AddEventHandler('businessPromotion:showNotification', function(playerName, jobLabel, message)
        local src = source
        broadcastPromotion(src, playerName, jobLabel, message)
    end)

    -- /promotion command
    QBCore.Commands.Add('promotion', 'Send a business promotion to all players.', {
        { name = 'message', help = 'Promotion message.' },
    }, false, function(source, args)
        if #args == 0 then return end
        TriggerClientEvent('businessPromotion:getCost', source, args)
    end)

    -- /amberalert command
    QBCore.Commands.Add(Config.AmberAlertCommand, 'Send an Amber Alert to all players.', {
        { name = 'message', help = 'Alert message.' },
    }, false, function(source, args)
        if not Config.AmberAlert then return end
        if #args == 0 then return end

        local Player = QBCore.Functions.GetPlayer(source)
        if not Player then return end

        local jobName  = Player.PlayerData.job.name
        local jobGrade = Player.PlayerData.job.grade.level

        if not isAuthorizedForAmberAlert(jobName, jobGrade) then
            TriggerClientEvent('ox_lib:notify', source, {
                title       = Config.Strings.amber_alert,
                description = Config.Strings.you_are_not_allowed_amberalert,
                position    = Config.NotifyPosition,
                icon        = Config.Icon,
                type        = 'error',
                duration    = 10000,
            })
            return
        end

        local alertMsg = table.concat(args, ' ')
        lbPhoneEmergencyAll(Config.Strings.amber_alert, alertMsg)
        print(('[AdminPlus Promotion] Amber Alert by QB player %s: %s'):format(source, alertMsg))
    end)

end
