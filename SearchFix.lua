local auctionFrame = CreateFrame("Frame")
local searchHooked = false

-- Retry clicking the search button until enabled, up to 10 attempts
local function TryClickSearch(attempts)
    if not AuctionHouseFrame or not AuctionHouseFrame:IsShown() then return end
    local searchButton = AuctionHouseFrame.SearchBar.SearchButton
    if not searchButton then return end
    if searchButton:IsEnabled() then
        searchButton:Click()
    elseif (attempts or 0) < 10 then
        C_Timer.After(0.1, function() TryClickSearch((attempts or 0) + 1) end)
    end
end

-- Hook the search box once to detect paste events via length jump
local function HookSearchBox()
    if searchHooked then return end
    if not AuctionHouseFrame or not AuctionHouseFrame.SearchBar then return end
    local searchBox  = AuctionHouseFrame.SearchBar.SearchBox
    local lastLength = 0
    searchBox:HookScript("OnTextChanged", function(self)
        local text = self:GetText()
        if text ~= "" and math.abs(#text - lastLength) > 1 then
            TryClickSearch(0)
        end
        lastLength = #text
    end)
    searchHooked = true
end

-- Apply the hook once when the auction house first opens
auctionFrame:RegisterEvent("AUCTION_HOUSE_SHOW")
auctionFrame:SetScript("OnEvent", function(_, event)
    if event == "AUCTION_HOUSE_SHOW" then HookSearchBox() end
end)
