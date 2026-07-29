local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Barudak Fishit v 1.0",
    SubTitle = "by Zcus",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

local Tabs = {
    Crystal = Window:AddTab({ Title = "Crystal Drop", Icon = "" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local CrystalSection = Tabs.Crystal:AddSection("Drop Options")

-- ======================================
-- Crystal Drop All + Platform (1 Tombol)
-- ======================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Event = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CrystalDropRequest")

local dropping = false

CrystalSection:AddToggle("AutoDrop", {
    Title = "Drop All Crystal",
    Description = "Toggle ON = mulai drop, OFF = stop",
    Default = false,
}):OnChanged(function(state)
    dropping = state

    if dropping then
        task.spawn(function()
            local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local root = character:FindFirstChild("HumanoidRootPart")

            -- Freeze character biar ga jatoh
            if root then
                root.Anchored = true
                root.CFrame = CFrame.new(-12, 150, 1076)
            end

            Fluent:Notify({ Title = "Crystal Drop", Content = "Mulai drop semua crystal...", Duration = 4 })

            local dropped = 0

            while dropping do
                local backpack = LocalPlayer:FindFirstChild("Backpack")
                local found = false

                if backpack then
                    for _, item in ipairs(backpack:GetChildren()) do
                        if item.Name:match("%[") and item.Name:match("%]") then
                            Event:FireServer(item.Name)
                            dropped = dropped + 1
                            found = true
                            break
                        end
                    end
                end

                if not found then
                    break
                end

                task.wait(0.2)
                if root and dropping then
                    root.CFrame = CFrame.new(-12, 150, 1076)
                end
            end

            -- Unfreeze character
            if root then
                root.Anchored = false
            end

            Fluent:Notify({
                Title = "Crystal Drop",
                Content = "Selesai! " .. dropped .. " crystal dropped.",
                Duration = 4
            })
        end)
    else
        -- Unfreeze langsung kalo toggle OFF
        local character = LocalPlayer.Character
        if character then
            local root = character:FindFirstChild("HumanoidRootPart")
            if root then root.Anchored = false end
        end
        Fluent:Notify({ Title = "Crystal Drop", Content = "Dihentikan.", Duration = 3 })
    end
end)

-- ======================================
-- SaveManager & Interface
-- ======================================
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FishingHub")
SaveManager:SetFolder("FishingHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Fishing Hub",
    Content = "Script loaded!",
    Duration = 6
})
