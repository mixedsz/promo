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

                    -- ESX legacy: job.grade is a number. Newer ESX: job.grade is a
                    -- table and the numeric index lives in job.grade_index.
                    local jobGrade    = type(playerData.job.grade) == 'number'
                        and playerData.job.grade
                        or (playerData.job.grade_index or 0)
                    -- Jobs not listed in RequiredGrade default to 0 (all grades allowed)
                    local reqGrade    = Config.RequiredGrade[jobName] or 0

                    if reqGrade > jobGrade then
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

                    -- Server handles all broadcasting (chat, ox_lib, lb-phone to all players)
                    TriggerServerEvent('businessPromotion:showNotification', playerName, playerData.job.label, message)
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

                    -- Jobs not listed in RequiredGrade default to 0 (all grades allowed)
                    local reqGrade = Config.RequiredGrade[jobName] or 0

                    if reqGrade > playerData.job.grade.level then
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

                    -- Server handles all broadcasting (chat, ox_lib, lb-phone to all players)
                    TriggerServerEvent('businessPromotion:showNotification', playerName, playerData.job.label, message)
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

-- Relay: server broadcasts this to all clients so lb-phone export fires locally on every phone
RegisterNetEvent('businessPromotion:phoneNotify')
AddEventHandler('businessPromotion:phoneNotify', function(app, title, content)
    exports['lb-phone']:SendNotification({
        app     = app,
        title   = title,
        content = content,
    })
end)
