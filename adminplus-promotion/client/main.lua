local ESX, QBCore

if Config.Framework == 1 then
    ESX = exports[Config.FrameworkExport]:getSharedObject()
elseif Config.Framework == 2 then
    QBCore = exports[Config.FrameworkExport]:GetCoreObject()
else
    print('[AdminPlus Promotion] No Framework Detected Client')
end

local function normalizeText(text)
    text = string.lower(text)
    text = text:gsub('[%s%p%d]', '')
    return text
end

local function containsBlacklistedWord(message)
    local normalized = normalizeText(message)
    for _, word in ipairs(Config.BlacklistWords) do
        if string.find(normalized, normalizeText(word), 1, true) then
            lib.notify({
                title       = Config.Strings.business_promotion,
                description = Config.Strings.blacklisted_words,
                position    = Config.NotifyPosition,
                icon        = Config.Icon,
                type        = 'error',
                duration    = 10000,
            })
            return true
        end
    end
    return false
end

local onCooldown = false

-- ─── ESX ─────────────────────────────────────────────────────────────────────

if Config.Framework == 1 then

    RegisterNetEvent('businessPromotion:getCost')
    AddEventHandler('businessPromotion:getCost', function(messageWords)
        ESX.TriggerServerCallback('businessPromotion:getJobs', function(cost)
            local message = table.concat(messageWords, ' ')

            ESX.TriggerServerCallback('businessPromotion:getPlayerName', function(playerName)
                ESX.TriggerServerCallback('businessPromotion:getPlayerMoney', function(playerMoney)
                    local playerData = ESX.GetPlayerData()
                    local jobName    = playerData.job.name

                    if not Config.AllowedJobs[jobName] then
                        lib.notify({
                            title       = Config.Strings.business_promotion,
                            description = Config.Strings.you_are_not_allowed,
                            position    = Config.NotifyPosition,
                            icon        = Config.Icon,
                            type        = 'error',
                            duration    = 10000,
                        })
                        return
                    end

                    -- ESX legacy stores grade as a number; newer ESX stores it as a
                    -- table {name,label} with the numeric index in grade_index
                    local jobGrade = type(playerData.job.grade) == 'number'
                        and playerData.job.grade
                        or (playerData.job.grade_index or 0)

                    if Config.RequiredGrade[jobName] > jobGrade then
                        lib.notify({
                            title       = Config.Strings.business_promotion,
                            description = Config.Strings.not_required_job_grade,
                            position    = Config.NotifyPosition,
                            icon        = Config.Icon,
                            type        = 'error',
                            duration    = 10000,
                        })
                        return
                    end

                    if onCooldown then
                        lib.notify({
                            title       = Config.Strings.business_promotion,
                            description = Config.Strings.wait_for_promotion,
                            position    = Config.NotifyPosition,
                            icon        = Config.Icon,
                            type        = 'error',
                            duration    = 10000,
                        })
                        return
                    end

                    if containsBlacklistedWord(message) then return end

                    if playerMoney < cost then
                        lib.notify({
                            title       = Config.Strings.business_promotion,
                            description = Config.Strings.not_enough_money,
                            position    = Config.NotifyPosition,
                            icon        = Config.Icon,
                            type        = 'error',
                            duration    = 10000,
                        })
                        return
                    end

                    if Config.Ox_LibNotify or Config.ChatMessage then
                        TriggerServerEvent('businessPromotion:showNotification', playerName, playerData.job.label, message)
                    end

                    if Config.LbPhone.Twitter then
                        exports['lb-phone']:SendNotification({
                            app     = 'Twitter',
                            title   = playerName .. ' - ' .. playerData.job.label,
                            content = message,
                        })
                    end

                    if Config.LbPhone.Instagram then
                        exports['lb-phone']:SendNotification({
                            app     = 'Instagram',
                            title   = playerName .. ' - ' .. playerData.job.label,
                            content = message,
                        })
                    end

                    if Config.LbPhone.Marketplace then
                        exports['lb-phone']:SendNotification({
                            app     = 'Marketplace',
                            title   = playerName .. ' - ' .. playerData.job.label,
                            content = message,
                        })
                    end

                    if Config.LbPhone.Mail then
                        exports['lb-phone']:SendNotification({
                            app     = 'Mail',
                            title   = playerName .. ' - ' .. playerData.job.label,
                            content = message,
                        })
                    end

                    if Config.LbPhone.YellowPages then
                        exports['lb-phone']:SendNotification({
                            app     = 'YellowPages',
                            title   = playerName .. ' - ' .. playerData.job.label,
                            content = message,
                        })
                    end

                    TriggerServerEvent('businessPromotion:removeMoney', cost)

                    onCooldown = true
                    SetTimeout(Config.CooldownTime * 1000, function()
                        onCooldown = false
                    end)
                end)
            end)
        end)
    end)

    RegisterNetEvent('esx:setJob')
    AddEventHandler('esx:setJob', function()
        ESX.GetPlayerData()
    end)

-- ─── QB-Core ──────────────────────────────────────────────────────────────────

elseif Config.Framework == 2 then

    RegisterNetEvent('businessPromotion:getCost')
    AddEventHandler('businessPromotion:getCost', function(messageWords)
        QBCore.Functions.TriggerCallback('businessPromotion:getJobs', function(cost)
            local message = table.concat(messageWords, ' ')

            QBCore.Functions.TriggerCallback('businessPromotion:getPlayerName', function(playerName)
                QBCore.Functions.TriggerCallback('businessPromotion:getPlayerMoney', function(playerMoney)
                    local playerData = QBCore.Functions.GetPlayerData()
                    local jobName    = playerData.job.name

                    if not Config.AllowedJobs[jobName] then
                        lib.notify({
                            title       = Config.Strings.business_promotion,
                            description = Config.Strings.you_are_not_allowed,
                            position    = Config.NotifyPosition,
                            icon        = Config.Icon,
                            type        = 'error',
                            duration    = 10000,
                        })
                        return
                    end

                    if Config.RequiredGrade[jobName] > playerData.job.grade.level then
                        lib.notify({
                            title       = Config.Strings.business_promotion,
                            description = Config.Strings.not_required_job_grade,
                            position    = Config.NotifyPosition,
                            icon        = Config.Icon,
                            type        = 'error',
                            duration    = 10000,
                        })
                        return
                    end

                    if onCooldown then
                        lib.notify({
                            title       = Config.Strings.business_promotion,
                            description = Config.Strings.wait_for_promotion,
                            position    = Config.NotifyPosition,
                            icon        = Config.Icon,
                            type        = 'error',
                            duration    = 10000,
                        })
                        return
                    end

                    if containsBlacklistedWord(message) then return end

                    if playerMoney < cost then
                        lib.notify({
                            title       = Config.Strings.business_promotion,
                            description = Config.Strings.not_enough_money,
                            position    = Config.NotifyPosition,
                            icon        = Config.Icon,
                            type        = 'error',
                            duration    = 10000,
                        })
                        return
                    end

                    if Config.Ox_LibNotify or Config.ChatMessage then
                        TriggerServerEvent('businessPromotion:showNotification', playerName, playerData.job.label, message)
                    end

                    if Config.LbPhone.Twitter then
                        exports['lb-phone']:SendNotification({
                            app     = 'Twitter',
                            title   = playerName .. ' - ' .. playerData.job.label,
                            content = message,
                        })
                    end

                    if Config.LbPhone.Instagram then
                        exports['lb-phone']:SendNotification({
                            app     = 'Instagram',
                            title   = playerName .. ' - ' .. playerData.job.label,
                            content = message,
                        })
                    end

                    if Config.LbPhone.Marketplace then
                        exports['lb-phone']:SendNotification({
                            app     = 'Marketplace',
                            title   = playerName .. ' - ' .. playerData.job.label,
                            content = message,
                        })
                    end

                    if Config.LbPhone.Mail then
                        exports['lb-phone']:SendNotification({
                            app     = 'Mail',
                            title   = playerName .. ' - ' .. playerData.job.label,
                            content = message,
                        })
                    end

                    if Config.LbPhone.YellowPages then
                        exports['lb-phone']:SendNotification({
                            app     = 'YellowPages',
                            title   = playerName .. ' - ' .. playerData.job.label,
                            content = message,
                        })
                    end

                    TriggerServerEvent('businessPromotion:removeMoney', cost)

                    onCooldown = true
                    SetTimeout(Config.CooldownTime * 1000, function()
                        onCooldown = false
                    end)
                end)
            end)
        end)
    end)

    RegisterNetEvent('QBCore:Client:OnJobUpdate')
    AddEventHandler('QBCore:Client:OnJobUpdate', function()
        QBCore.Functions.GetPlayerData()
    end)

end
