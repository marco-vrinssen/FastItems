local vendorFrame  = CreateFrame("Frame")
local vendorVisited = false

local handlers = {
    -- Repair with own funds and sell junk once per vendor visit
    MERCHANT_SHOW = function()
        if vendorVisited then return end
        vendorVisited = true
        RunNextFrame(function()
            if CanMerchantRepair() then RepairAllItems() end
            C_MerchantFrame.SellAllJunkItems()
        end)
    end,

    -- Reset visit flag when the merchant window closes
    MERCHANT_CLOSED = function()
        vendorVisited = false
    end,

    -- Auto-confirm the trade timer removal popup
    MERCHANT_CONFIRM_TRADE_TIMER_REMOVAL = function()
        local popup = StaticPopup_FindVisible("CONFIRM_MERCHANT_TRADE_TIMER_REMOVAL")
        if popup and popup.button1 then popup.button1:Click() end
    end,
}

vendorFrame:SetScript("OnEvent", function(_, event)
    if handlers[event] then handlers[event]() end
end)

for event in pairs(handlers) do
    vendorFrame:RegisterEvent(event)
end
