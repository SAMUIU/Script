### Solo el código Lua (para archivo `.lua`)

Si solo necesitas el código Lua para un archivo `.lua` en GitHub:

```lua
-- Roblox FPS Booster with Mobile GUI
-- Description: Optimizes game performance with a mobile-friendly GUI to toggle FPS boosts.
-- Author: [Your Name or Handle]
-- Compatibility: Works with most Roblox games, but some anti-cheat systems may block it.
-- Last Updated: September 12, 2025

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Terrain = game:GetService("Workspace").Terrain
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Optimization state
local optimizationsEnabled = false
local connection -- To store the DescendantAdded connection

-- Function to apply FPS optimizations
local function applyOptimizations()
    -- Disable textures on all parts
    for _, object in pairs(game:GetDescendants()) do
        if object:IsA("BasePart") then
            object.Material = Enum.Material.SmoothPlastic
            object.Reflectance = 0
        elseif object:IsA("Decal") or object:IsA("Texture") then
            object:Destroy()
        end
    end

    -- Optimize terrain
    if Terrain then
        Terrain.WaterWaveSize = 0
        Terrain.WaterWaveSpeed = 0
        Terrain.WaterReflectance = 0
        Terrain.WaterTransparency = 1
    end

    -- Lower graphics settings
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 100000
    Lighting.Brightness = 1
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0
    Lighting.ClockTime = 12

    -- Disable post-processing effects
    for _, effect in pairs(Lighting:GetChildren()) do
        if effect:IsA("PostEffect") then
            effect.Enabled = false
        end
    end

    -- Set lowest graphics quality
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end)

    print("FPS optimizations enabled.")
end

-- Function to disable FPS optimizations (restore defaults, where possible)
local function disableOptimizations()
    -- Note: Some settings (like textures) can't be easily restored without game-specific data
    Lighting.GlobalShadows = true
    Lighting.FogEnd = 500
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
    end)
    print("FPS optimizations disabled.")
end

-- Function to toggle optimizations
local function toggleOptimizations()
    optimizationsEnabled = not optimizationsEnabled
    if optimizationsEnabled then
        applyOptimizations()
        -- Monitor new objects
        connection = game:GetService("Workspace").DescendantAdded:Connect(function(descendant)
            if descendant:IsA("BasePart") then
                descendant.Material = Enum.Material.SmoothPlastic
                descendant.Reflectance = 0
            elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
                descendant:Destroy()
            end
        end)
    else
        if connection then
            connection:Disconnect()
        end
        disableOptimizations()
    end
end

-- Create mobile-friendly GUI
local function createGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = Player:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true

    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 100, 0, 100) -- Large size for easy tapping on mobile
    ToggleButton.Position = UDim2.new(0.85, -110, 0.1, 10) -- Top-right corner
    ToggleButton.Text = "FPS Boost\n(OFF)"
    ToggleButton.TextScaled = true
    ToggleButton.TextColor3 = Color3.new(1, 1, 1)
    ToggleButton.BackgroundColor3 = Color3.new(0, 0.5, 0)
    ToggleButton.BackgroundTransparency = 0.3
    ToggleButton.BorderSizePixel = 2
    ToggleButton.Parent = ScreenGui

    -- Update button text based on state
    local function updateButtonText()
        ToggleButton.Text = optimizationsEnabled and "FPS Boost\n(ON)" or "FPS Boost\n(OFF)"
        ToggleButton.BackgroundColor3 = optimizationsEnabled and Color3.new(0, 1, 0) or Color3.new(0, 0.5, 0)
    end

    -- Connect button click
    ToggleButton.MouseButton1Click:Connect(function()
        toggleOptimizations()
        updateButtonText()
    end)

    -- Support for touch input (mobile)
    UserInputService.TouchTapInWorld:Connect(function(touch, processed)
        if not processed then
            local touchPos = Vector2.new(touch.X, touch.Y)
            local guiPos = ToggleButton.AbsolutePosition
            local guiSize = ToggleButton.AbsoluteSize
            if touchPos.X >= guiPos.X and touchPos.X <= guiPos.X + guiSize.X and
               touchPos.Y >= guiPos.Y and touchPos.Y <= guiPos.Y + guiSize.Y then
                toggleOptimizations()
                updateButtonText()
            end
        end
    end)
end

-- Initialize GUI
createGUI()
print("FPS Booster with Mobile GUI loaded. Tap the button to toggle optimizations.")
