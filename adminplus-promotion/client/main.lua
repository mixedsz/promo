local L0_1, L1_1, L2_1, L3_1, L4_1, L5_1
L0_1 = Config
L0_1 = L0_1.Framework
if 1 == L0_1 then
  L0_1 = exports
  L1_1 = Config
  L1_1 = L1_1.FrameworkExport
  L0_1 = L0_1[L1_1]
  L1_1 = L0_1
  L0_1 = L0_1.getSharedObject
  L0_1 = L0_1(L1_1)
  ESX = L0_1
else
  L0_1 = Config
  L0_1 = L0_1.Framework
  if 2 == L0_1 then
    L0_1 = exports
    L1_1 = Config
    L1_1 = L1_1.FrameworkExport
    L0_1 = L0_1[L1_1]
    L1_1 = L0_1
    L0_1 = L0_1.GetCoreObject
    L0_1 = L0_1(L1_1)
    QBCore = L0_1
  else
    L0_1 = print
    L1_1 = "No Framework Detected Server"
    L0_1(L1_1)
  end
end
function L0_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2
  L1_2 = string
  L1_2 = L1_2.lower
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  A0_2 = L1_2
  L2_2 = A0_2
  L1_2 = A0_2.gsub
  L3_2 = "[%s%p%d]"
  L4_2 = ""
  L1_2 = L1_2(L2_2, L3_2, L4_2)
  A0_2 = L1_2
  return A0_2
end
function L1_1(A0_2)
  local L1_2, L2_2, L3_2, L4_2, L5_2, L6_2, L7_2, L8_2, L9_2, L10_2, L11_2, L12_2, L13_2
  L1_2 = L0_1
  L2_2 = A0_2
  L1_2 = L1_2(L2_2)
  L2_2 = ipairs
  L3_2 = Config
  L3_2 = L3_2.BlacklistWords
  L2_2, L3_2, L4_2, L5_2 = L2_2(L3_2)
  for L6_2, L7_2 in L2_2, L3_2, L4_2, L5_2 do
    L8_2 = L0_1
    L9_2 = L7_2
    L8_2 = L8_2(L9_2)
    L9_2 = string
    L9_2 = L9_2.find
    L10_2 = L1_2
    L11_2 = L8_2
    L12_2 = 1
    L13_2 = true
    L9_2 = L9_2(L10_2, L11_2, L12_2, L13_2)
    if L9_2 then
      L9_2 = lib
      L9_2 = L9_2.notify
      L10_2 = {}
      L11_2 = Config
      L11_2 = L11_2.Strings
      L11_2 = L11_2.business_promotion
      L10_2.title = L11_2
      L11_2 = Config
      L11_2 = L11_2.Strings
      L11_2 = L11_2.blacklisted_words
      L10_2.description = L11_2
      L11_2 = Config
      L11_2 = L11_2.NotifyPosition
      L10_2.position = L11_2
      L11_2 = Config
      L11_2 = L11_2.Icon
      L10_2.icon = L11_2
      L10_2.type = "error"
      L10_2.duration = 10000
      L9_2(L10_2)
      L9_2 = true
      return L9_2
    end
  end
  L2_2 = false
  return L2_2
end
L2_1 = false
L3_1 = Config
L3_1 = L3_1.Framework
if 1 == L3_1 then
  L3_1 = RegisterNetEvent
  L4_1 = "businessPromotion:getCost"
  L3_1(L4_1)
  L3_1 = AddEventHandler
  L4_1 = "businessPromotion:getCost"
  function L5_1(A0_2)
    local L1_2, L2_2, L3_2
    L1_2 = ESX
    L1_2 = L1_2.TriggerServerCallback
    L2_2 = "businessPromotion:getJobs"
    function L3_2(A0_3)
      local L1_3, L2_3, L3_3, L4_3
      L1_3 = table
      L1_3 = L1_3.concat
      L2_3 = A0_2
      L3_3 = " "
      L1_3 = L1_3(L2_3, L3_3)
      L2_3 = ESX
      L2_3 = L2_3.TriggerServerCallback
      L3_3 = "businessPromotion:getPlayerName"
      function L4_3(A0_4)
        local L1_4, L2_4, L3_4
        L1_4 = ESX
        L1_4 = L1_4.TriggerServerCallback
        L2_4 = "businessPromotion:getPlayerMoney"
        function L3_4(A0_5)
          local L1_5, L2_5, L3_5, L4_5, L5_5, L6_5, L7_5, L8_5
          L1_5 = ESX
          L1_5 = L1_5.GetPlayerData
          L1_5 = L1_5()
          L2_5 = Config
          L2_5 = L2_5.AllowedJobs
          L3_5 = L1_5.job
          L3_5 = L3_5.name
          L2_5 = L2_5[L3_5]
          if L2_5 then
            L2_5 = Config
            L2_5 = L2_5.RequiredGrade
            L3_5 = L1_5.job
            L3_5 = L3_5.name
            L2_5 = L2_5[L3_5]
            L3_5 = L1_5.job
            L3_5 = L3_5.grade
            if L2_5 <= L3_5 then
              L3_5 = L2_1
              if L3_5 then
                L3_5 = lib
                L3_5 = L3_5.notify
                L4_5 = {}
                L5_5 = Config
                L5_5 = L5_5.Strings
                L5_5 = L5_5.business_promotion
                L4_5.title = L5_5
                L5_5 = Config
                L5_5 = L5_5.Strings
                L5_5 = L5_5.wait_for_promotion
                L4_5.description = L5_5
                L5_5 = Config
                L5_5 = L5_5.NotifyPosition
                L4_5.position = L5_5
                L5_5 = Config
                L5_5 = L5_5.Icon
                L4_5.icon = L5_5
                L4_5.type = "error"
                L4_5.duration = 10000
                L3_5(L4_5)
                return
              end
              L3_5 = L1_1
              L4_5 = L1_3
              L3_5 = L3_5(L4_5)
              if L3_5 then
                return
              end
              L3_5 = A0_3
              if A0_5 >= L3_5 then
                L3_5 = Config
                L3_5 = L3_5.Ox_LibNotify
                if not L3_5 then
                  L3_5 = Config
                  L3_5 = L3_5.ChatMessage
                  if not L3_5 then
                    goto lbl_69
                  end
                end
                L3_5 = TriggerServerEvent
                L4_5 = "businessPromotion:showNotification"
                L5_5 = A0_4
                L6_5 = L1_5.job
                L6_5 = L6_5.label
                L7_5 = L1_3
                L3_5(L4_5, L5_5, L6_5, L7_5)
                ::lbl_69::
                L3_5 = Config
                L3_5 = L3_5.LbPhone
                L3_5 = L3_5.Twitter
                if L3_5 then
                  L3_5 = exports
                  L3_5 = L3_5["lb-phone"]
                  L4_5 = L3_5
                  L3_5 = L3_5.SendNotification
                  L5_5 = {}
                  L5_5.app = "Twitter"
                  L6_5 = A0_4
                  L7_5 = " - "
                  L8_5 = L1_5.job
                  L8_5 = L8_5.label
                  L6_5 = L6_5 .. L7_5 .. L8_5
                  L5_5.title = L6_5
                  L6_5 = L1_3
                  L5_5.content = L6_5
                  L3_5(L4_5, L5_5)
                end
                L3_5 = Config
                L3_5 = L3_5.LbPhone
                L3_5 = L3_5.Instagram
                if L3_5 then
                  L3_5 = exports
                  L3_5 = L3_5["lb-phone"]
                  L4_5 = L3_5
                  L3_5 = L3_5.SendNotification
                  L5_5 = {}
                  L5_5.app = "Instagram"
                  L6_5 = A0_4
                  L7_5 = " - "
                  L8_5 = L1_5.job
                  L8_5 = L8_5.label
                  L6_5 = L6_5 .. L7_5 .. L8_5
                  L5_5.title = L6_5
                  L6_5 = L1_3
                  L5_5.content = L6_5
                  L3_5(L4_5, L5_5)
                end
                L3_5 = Config
                L3_5 = L3_5.LbPhone
                L3_5 = L3_5.Marketplace
                if L3_5 then
                  L3_5 = exports
                  L3_5 = L3_5["lb-phone"]
                  L4_5 = L3_5
                  L3_5 = L3_5.SendNotification
                  L5_5 = {}
                  L5_5.app = "Marketplace"
                  L6_5 = A0_4
                  L7_5 = " - "
                  L8_5 = L1_5.job
                  L8_5 = L8_5.label
                  L6_5 = L6_5 .. L7_5 .. L8_5
                  L5_5.title = L6_5
                  L6_5 = L1_3
                  L5_5.content = L6_5
                  L3_5(L4_5, L5_5)
                end
                L3_5 = Config
                L3_5 = L3_5.LbPhone
                L3_5 = L3_5.Mail
                if L3_5 then
                  L3_5 = exports
                  L3_5 = L3_5["lb-phone"]
                  L4_5 = L3_5
                  L3_5 = L3_5.SendNotification
                  L5_5 = {}
                  L5_5.app = "Mail"
                  L6_5 = A0_4
                  L7_5 = " - "
                  L8_5 = L1_5.job
                  L8_5 = L8_5.label
                  L6_5 = L6_5 .. L7_5 .. L8_5
                  L5_5.title = L6_5
                  L6_5 = L1_3
                  L5_5.content = L6_5
                  L3_5(L4_5, L5_5)
                end
                L3_5 = Config
                L3_5 = L3_5.LbPhone
                L3_5 = L3_5.YellowPages
                if L3_5 then
                  L3_5 = exports
                  L3_5 = L3_5["lb-phone"]
                  L4_5 = L3_5
                  L3_5 = L3_5.SendNotification
                  L5_5 = {}
                  L5_5.app = "YellowPages"
                  L6_5 = A0_4
                  L7_5 = " - "
                  L8_5 = L1_5.job
                  L8_5 = L8_5.label
                  L6_5 = L6_5 .. L7_5 .. L8_5
                  L5_5.title = L6_5
                  L6_5 = L1_3
                  L5_5.content = L6_5
                  L3_5(L4_5, L5_5)
                end
                L3_5 = TriggerServerEvent
                L4_5 = "businessPromotion:removeMoney"
                L5_5 = A0_3
                L3_5(L4_5, L5_5)
                L3_5 = true
                L2_1 = L3_5
                L3_5 = SetTimeout
                L4_5 = Config
                L4_5 = L4_5.CooldownTime
                L4_5 = L4_5 * 1000
                function L5_5()
                  local L0_6, L1_6
                  L0_6 = false
                  L2_1 = L0_6
                end
                L3_5(L4_5, L5_5)
              else
                L3_5 = lib
                L3_5 = L3_5.notify
                L4_5 = {}
                L5_5 = Config
                L5_5 = L5_5.Strings
                L5_5 = L5_5.business_promotion
                L4_5.title = L5_5
                L5_5 = Config
                L5_5 = L5_5.Strings
                L5_5 = L5_5.not_enough_money
                L4_5.description = L5_5
                L5_5 = Config
                L5_5 = L5_5.NotifyPosition
                L4_5.position = L5_5
                L5_5 = Config
                L5_5 = L5_5.Icon
                L4_5.icon = L5_5
                L4_5.type = "error"
                L4_5.duration = 10000
                L3_5(L4_5)
              end
            else
              L3_5 = lib
              L3_5 = L3_5.notify
              L4_5 = {}
              L5_5 = Config
              L5_5 = L5_5.Strings
              L5_5 = L5_5.business_promotion
              L4_5.title = L5_5
              L5_5 = Config
              L5_5 = L5_5.Strings
              L5_5 = L5_5.not_required_job_grade
              L4_5.description = L5_5
              L5_5 = Config
              L5_5 = L5_5.NotifyPosition
              L4_5.position = L5_5
              L5_5 = Config
              L5_5 = L5_5.Icon
              L4_5.icon = L5_5
              L4_5.type = "error"
              L4_5.duration = 10000
              L3_5(L4_5)
            end
          else
            L2_5 = lib
            L2_5 = L2_5.notify
            L3_5 = {}
            L4_5 = Config
            L4_5 = L4_5.Strings
            L4_5 = L4_5.business_promotion
            L3_5.title = L4_5
            L4_5 = Config
            L4_5 = L4_5.Strings
            L4_5 = L4_5.you_are_not_allowed
            L3_5.description = L4_5
            L4_5 = Config
            L4_5 = L4_5.NotifyPosition
            L3_5.position = L4_5
            L4_5 = Config
            L4_5 = L4_5.Icon
            L3_5.icon = L4_5
            L3_5.type = "error"
            L3_5.duration = 10000
            L2_5(L3_5)
          end
        end
        L1_4(L2_4, L3_4)
      end
      L2_3(L3_3, L4_3)
    end
    L1_2(L2_2, L3_2)
  end
  L3_1(L4_1, L5_1)
  L3_1 = RegisterNetEvent
  L4_1 = "esx:setJob"
  L3_1(L4_1)
  L3_1 = AddEventHandler
  L4_1 = "esx:setJob"
  function L5_1(A0_2)
    local L1_2
    L1_2 = ESX
    L1_2 = L1_2.GetPlayerData
    L1_2 = L1_2()
  end
  L3_1(L4_1, L5_1)
else
  L3_1 = Config
  L3_1 = L3_1.Framework
  if 2 == L3_1 then
    L3_1 = RegisterNetEvent
    L4_1 = "businessPromotion:getCost"
    L3_1(L4_1)
    L3_1 = AddEventHandler
    L4_1 = "businessPromotion:getCost"
    function L5_1(A0_2)
      local L1_2, L2_2, L3_2
      L1_2 = QBCore
      L1_2 = L1_2.Functions
      L1_2 = L1_2.TriggerCallback
      L2_2 = "businessPromotion:getJobs"
      function L3_2(A0_3)
        local L1_3, L2_3, L3_3, L4_3
        L1_3 = table
        L1_3 = L1_3.concat
        L2_3 = A0_2
        L3_3 = " "
        L1_3 = L1_3(L2_3, L3_3)
        L2_3 = QBCore
        L2_3 = L2_3.Functions
        L2_3 = L2_3.TriggerCallback
        L3_3 = "businessPromotion:getPlayerName"
        function L4_3(A0_4)
          local L1_4, L2_4, L3_4
          L1_4 = QBCore
          L1_4 = L1_4.Functions
          L1_4 = L1_4.TriggerCallback
          L2_4 = "businessPromotion:getPlayerMoney"
          function L3_4(A0_5)
            local L1_5, L2_5, L3_5, L4_5, L5_5, L6_5, L7_5, L8_5
            L1_5 = QBCore
            L1_5 = L1_5.Functions
            L1_5 = L1_5.GetPlayerData
            L1_5 = L1_5()
            L2_5 = Config
            L2_5 = L2_5.AllowedJobs
            L3_5 = L1_5.job
            L3_5 = L3_5.name
            L2_5 = L2_5[L3_5]
            if L2_5 then
              L2_5 = Config
              L2_5 = L2_5.RequiredGrade
              L3_5 = L1_5.job
              L3_5 = L3_5.name
              L2_5 = L2_5[L3_5]
              L3_5 = L1_5.job
              L3_5 = L3_5.grade
              L3_5 = L3_5.level
              if L2_5 <= L3_5 then
                L3_5 = L2_1
                if L3_5 then
                  L3_5 = lib
                  L3_5 = L3_5.notify
                  L4_5 = {}
                  L5_5 = Config
                  L5_5 = L5_5.Strings
                  L5_5 = L5_5.business_promotion
                  L4_5.title = L5_5
                  L5_5 = Config
                  L5_5 = L5_5.Strings
                  L5_5 = L5_5.wait_for_promotion
                  L4_5.description = L5_5
                  L5_5 = Config
                  L5_5 = L5_5.NotifyPosition
                  L4_5.position = L5_5
                  L5_5 = Config
                  L5_5 = L5_5.Icon
                  L4_5.icon = L5_5
                  L4_5.type = "error"
                  L4_5.duration = 10000
                  L3_5(L4_5)
                  return
                end
                L3_5 = L1_1
                L4_5 = L1_3
                L3_5 = L3_5(L4_5)
                if L3_5 then
                  return
                end
                L3_5 = A0_3
                if A0_5 >= L3_5 then
                  L3_5 = Config
                  L3_5 = L3_5.Ox_LibNotify
                  if not L3_5 then
                    L3_5 = Config
                    L3_5 = L3_5.ChatMessage
                    if not L3_5 then
                      goto lbl_71
                    end
                  end
                  L3_5 = TriggerServerEvent
                  L4_5 = "businessPromotion:showNotification"
                  L5_5 = A0_4
                  L6_5 = L1_5.job
                  L6_5 = L6_5.label
                  L7_5 = L1_3
                  L3_5(L4_5, L5_5, L6_5, L7_5)
                  ::lbl_71::
                  L3_5 = Config
                  L3_5 = L3_5.LbPhone
                  L3_5 = L3_5.Twitter
                  if L3_5 then
                    L3_5 = exports
                    L3_5 = L3_5["lb-phone"]
                    L4_5 = L3_5
                    L3_5 = L3_5.SendNotification
                    L5_5 = {}
                    L5_5.app = "Twitter"
                    L6_5 = A0_4
                    L7_5 = " - "
                    L8_5 = L1_5.job
                    L8_5 = L8_5.label
                    L6_5 = L6_5 .. L7_5 .. L8_5
                    L5_5.title = L6_5
                    L6_5 = L1_3
                    L5_5.content = L6_5
                    L3_5(L4_5, L5_5)
                  end
                  L3_5 = Config
                  L3_5 = L3_5.LbPhone
                  L3_5 = L3_5.Instagram
                  if L3_5 then
                    L3_5 = exports
                    L3_5 = L3_5["lb-phone"]
                    L4_5 = L3_5
                    L3_5 = L3_5.SendNotification
                    L5_5 = {}
                    L5_5.app = "Instagram"
                    L6_5 = A0_4
                    L7_5 = " - "
                    L8_5 = L1_5.job
                    L8_5 = L8_5.label
                    L6_5 = L6_5 .. L7_5 .. L8_5
                    L5_5.title = L6_5
                    L6_5 = L1_3
                    L5_5.content = L6_5
                    L3_5(L4_5, L5_5)
                  end
                  L3_5 = Config
                  L3_5 = L3_5.LbPhone
                  L3_5 = L3_5.Marketplace
                  if L3_5 then
                    L3_5 = exports
                    L3_5 = L3_5["lb-phone"]
                    L4_5 = L3_5
                    L3_5 = L3_5.SendNotification
                    L5_5 = {}
                    L5_5.app = "Marketplace"
                    L6_5 = A0_4
                    L7_5 = " - "
                    L8_5 = L1_5.job
                    L8_5 = L8_5.label
                    L6_5 = L6_5 .. L7_5 .. L8_5
                    L5_5.title = L6_5
                    L6_5 = L1_3
                    L5_5.content = L6_5
                    L3_5(L4_5, L5_5)
                  end
                  L3_5 = Config
                  L3_5 = L3_5.LbPhone
                  L3_5 = L3_5.Mail
                  if L3_5 then
                    L3_5 = exports
                    L3_5 = L3_5["lb-phone"]
                    L4_5 = L3_5
                    L3_5 = L3_5.SendNotification
                    L5_5 = {}
                    L5_5.app = "Mail"
                    L6_5 = A0_4
                    L7_5 = " - "
                    L8_5 = L1_5.job
                    L8_5 = L8_5.label
                    L6_5 = L6_5 .. L7_5 .. L8_5
                    L5_5.title = L6_5
                    L6_5 = L1_3
                    L5_5.content = L6_5
                    L3_5(L4_5, L5_5)
                  end
                  L3_5 = Config
                  L3_5 = L3_5.LbPhone
                  L3_5 = L3_5.YellowPages
                  if L3_5 then
                    L3_5 = exports
                    L3_5 = L3_5["lb-phone"]
                    L4_5 = L3_5
                    L3_5 = L3_5.SendNotification
                    L5_5 = {}
                    L5_5.app = "YellowPages"
                    L6_5 = A0_4
                    L7_5 = " - "
                    L8_5 = L1_5.job
                    L8_5 = L8_5.label
                    L6_5 = L6_5 .. L7_5 .. L8_5
                    L5_5.title = L6_5
                    L6_5 = L1_3
                    L5_5.content = L6_5
                    L3_5(L4_5, L5_5)
                  end
                  L3_5 = TriggerServerEvent
                  L4_5 = "businessPromotion:removeMoney"
                  L5_5 = A0_3
                  L3_5(L4_5, L5_5)
                  L3_5 = true
                  L2_1 = L3_5
                  L3_5 = SetTimeout
                  L4_5 = Config
                  L4_5 = L4_5.CooldownTime
                  L4_5 = L4_5 * 1000
                  function L5_5()
                    local L0_6, L1_6
                    L0_6 = false
                    L2_1 = L0_6
                  end
                  L3_5(L4_5, L5_5)
                else
                  L3_5 = lib
                  L3_5 = L3_5.notify
                  L4_5 = {}
                  L5_5 = Config
                  L5_5 = L5_5.Strings
                  L5_5 = L5_5.business_promotion
                  L4_5.title = L5_5
                  L5_5 = Config
                  L5_5 = L5_5.Strings
                  L5_5 = L5_5.not_enough_money
                  L4_5.description = L5_5
                  L5_5 = Config
                  L5_5 = L5_5.NotifyPosition
                  L4_5.position = L5_5
                  L5_5 = Config
                  L5_5 = L5_5.Icon
                  L4_5.icon = L5_5
                  L4_5.type = "error"
                  L4_5.duration = 10000
                  L3_5(L4_5)
                end
              else
                L3_5 = lib
                L3_5 = L3_5.notify
                L4_5 = {}
                L5_5 = Config
                L5_5 = L5_5.Strings
                L5_5 = L5_5.business_promotion
                L4_5.title = L5_5
                L5_5 = Config
                L5_5 = L5_5.Strings
                L5_5 = L5_5.not_required_job_grade
                L4_5.description = L5_5
                L5_5 = Config
                L5_5 = L5_5.NotifyPosition
                L4_5.position = L5_5
                L5_5 = Config
                L5_5 = L5_5.Icon
                L4_5.icon = L5_5
                L4_5.type = "error"
                L4_5.duration = 10000
                L3_5(L4_5)
              end
            else
              L2_5 = lib
              L2_5 = L2_5.notify
              L3_5 = {}
              L4_5 = Config
              L4_5 = L4_5.Strings
              L4_5 = L4_5.business_promotion
              L3_5.title = L4_5
              L4_5 = Config
              L4_5 = L4_5.Strings
              L4_5 = L4_5.you_are_not_allowed
              L3_5.description = L4_5
              L4_5 = Config
              L4_5 = L4_5.NotifyPosition
              L3_5.position = L4_5
              L4_5 = Config
              L4_5 = L4_5.Icon
              L3_5.icon = L4_5
              L3_5.type = "error"
              L3_5.duration = 10000
              L2_5(L3_5)
            end
          end
          L1_4(L2_4, L3_4)
        end
        L2_3(L3_3, L4_3)
      end
      L1_2(L2_2, L3_2)
    end
    L3_1(L4_1, L5_1)
    L3_1 = RegisterNetEvent
    L4_1 = "QBCore:Client:OnJobUpdate"
    L3_1(L4_1)
    L3_1 = AddEventHandler
    L4_1 = "QBCore:Client:OnJobUpdate"
    function L5_1(A0_2)
      local L1_2
      L1_2 = QBCore
      L1_2 = L1_2.Functions
      L1_2 = L1_2.GetPlayerData
      L1_2 = L1_2()
    end
    L3_1(L4_1, L5_1)
  end
end
