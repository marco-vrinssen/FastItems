-- AutoFilter.lua
-- Silently applies "Current Expansion Only" on the AH and Crafting Orders search bars.

local filterFrame              = CreateFrame("Frame")
local auctionHouseFilterHooked = false
local craftingOrdersHooked     = false


local function HookAuctionHouseFilter()
    if auctionHouseFilterHooked then return end
    local searchBar = AuctionHouseFrame.SearchBar
    local function applyFilter()
        searchBar.FilterButton.filters[Enum.AuctionHouseFilter.CurrentExpansionOnly] = true
        searchBar:UpdateClearFiltersButton()
    end
    searchBar:HookScript("OnShow", function() C_Timer.After(0, applyFilter) end)
    C_Timer.After(0, applyFilter)
    auctionHouseFilterHooked = true
end


local function HookCraftingOrdersFilter()
    if craftingOrdersHooked then return end
    local browseBar      = ProfessionsCustomerOrdersFrame.BrowseOrders.SearchBar
    local filterDropdown = browseBar.FilterDropdown
    local function applyFilter()
        filterDropdown.filters[Enum.AuctionHouseFilter.CurrentExpansionOnly] = true
        filterDropdown:ValidateResetState()
    end
    filterDropdown:HookScript("OnShow", function() C_Timer.After(0, applyFilter) end)
    C_Timer.After(0, applyFilter)
    craftingOrdersHooked = true
end


filterFrame:RegisterEvent("AUCTION_HOUSE_SHOW")
filterFrame:RegisterEvent("CRAFTINGORDERS_SHOW_CUSTOMER")

filterFrame:SetScript("OnEvent", function(_, event)
    if event == "AUCTION_HOUSE_SHOW" then
        HookAuctionHouseFilter()
    elseif event == "CRAFTINGORDERS_SHOW_CUSTOMER" then
        HookCraftingOrdersFilter()
    end
end)
