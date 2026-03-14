-- QuickPost.lua
-- Binds Spacebar to the active sell frame's Post button while the AH is open.

local quickPostFrame = CreateFrame("Frame")
local postEnabled    = false

local function PostAuction()
    if not postEnabled then return end
    if not AuctionHouseFrame or not AuctionHouseFrame:IsShown() then return end
    local sellFrames = {
        AuctionHouseFrame.CommoditiesSellFrame,
        AuctionHouseFrame.ItemSellFrame,
        AuctionHouseFrame.SellFrame,
    }
    for _, sellFrame in ipairs(sellFrames) do
        if sellFrame and sellFrame:IsShown()
        and sellFrame.PostButton and sellFrame.PostButton:IsEnabled() then
            sellFrame.PostButton:Click()
            return
        end
    end
end

local function OnAuctionHouseShow()
    postEnabled = true
    quickPostFrame:SetScript("OnKeyDown", function(_, key)
        if key == "SPACE" and postEnabled then
            PostAuction()
            quickPostFrame:SetPropagateKeyboardInput(false)
        else
            quickPostFrame:SetPropagateKeyboardInput(true)
        end
    end)
    quickPostFrame:SetPropagateKeyboardInput(true)
    quickPostFrame:EnableKeyboard(true)
    quickPostFrame:SetFrameStrata("HIGH")
end


local function OnAuctionHouseClosed()
    postEnabled = false
    quickPostFrame:SetScript("OnKeyDown", nil)
    quickPostFrame:EnableKeyboard(false)
end


quickPostFrame:RegisterEvent("AUCTION_HOUSE_SHOW")
quickPostFrame:RegisterEvent("AUCTION_HOUSE_CLOSED")

quickPostFrame:SetScript("OnEvent", function(_, event)
    if event == "AUCTION_HOUSE_SHOW" then
        OnAuctionHouseShow()
    elseif event == "AUCTION_HOUSE_CLOSED" then
        OnAuctionHouseClosed()
    end
end)
