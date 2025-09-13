# Roblox FPS Booster with Mobile GUI and Gray Sky
A Lua script for Roblox that optimizes game performance by disabling textures, lowering graphics quality, simulating lower resolution, and adding a gray skybox to reduce visual load. Includes a mobile-friendly GUI to toggle optimizations. Compatible with exploit executors like Delta or Krnl.

## Features
- Disables textures on parts and terrain.
- Lowers graphics quality and detail level to simulate lower resolution.
- Replaces the sky with a plain gray skybox.
- Mobile-friendly GUI with a toggle button to enable/disable optimizations.
- Continuous monitoring to maintain optimizations on new objects.

## Requirements
- A Roblox exploit executor (e.g., Delta, Krnl, Synapse).
- Roblox game environment that allows script execution.

## Installation
1. Copy the script below.
2. Open your executor (e.g., Delta or Krnl).
3. Paste the script into the executor's script window.
4. Click "Execute" or the equivalent button in your executor.
5. A GUI button will appear in the top-right corner (optimized for mobile). Tap it to toggle FPS optimizations.
6. Check the executor's console for debug messages to confirm execution.

## Script
```lua
-- Roblox FPS Booster with Mobile GUI and Gray Sky
-- Description: Optimizes game performance by lowering graphics quality, disabling textures, and adding a gray skybox. Includes a mobile-friendly GUI.
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

-- Function to add a gray skybox
local function setGraySky()
    pcall(function()
        -- Remove existing skybox
        for _, sky in pairs(Lighting:GetChildren()) do
            if sky:IsA("Sky") then
                sky:Destroy()
            end
        end

        -- Create a new gray skybox
        local sky = Instance.new("Sky")
        sky.Parent = Lighting
        sky.CelestialBodiesShown = false -- No sun/moon
        sky.SkyboxBk = "rbxasset://textures/sky/sky512_bk.tex" -- Plain texture
        sky.SkyboxDn = "rbxasset://textures/sky/sky512_dn.tex"
        sky.SkyboxFt = "rbxasset://textures/sky/sky512_ft.tex"
        sky.SkyboxLf = "rbxasset://textures/sky/sky512_lf.tex"
        sky.SkyboxRt = "rbxasset://textures/sky/sky512_rt.tex"
        sky.SkyboxUp = "rbxasset://textures/sky/sky512_up.tex"
        sky.StarCount = 0 -- No stars
        -- Set gray color by adjusting lighting
        Lighting.Ambient = Color3.fromRGB(128, 128, 128) -- Gray ambient light
        print("Gray skybox applied.")
    end)
end

-- Function to apply FPS optimizations
local function applyOptimizations()
    pcall(function()
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
            print("Terrain optimized.")
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

        -- Set lowest graphics quality to simulate lower resolution
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        print("FPS optimizations applied: textures disabled, graphics quality lowered.")
    end)
end

-- Function to disable FPS optimizations (restore defaults, where possible)
local function disableOptimizations()
    pcall(function()
        Lighting.GlobalShadows = true
        Lighting.FogEnd = 500
        Lighting.Ambient = Color3.fromRGB(0, 0, 0) -- Reset ambient
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        print("FPS optimizations disabled.")
    end)
end

-- Function to toggle optimizations
local function toggleOptimizations()
    optimizationsEnabled = not optimizationsEnabled
    if optimizationsEnabled then
        applyOptimizations()
        setGraySky()
        -- Monitor new objects
        connection = game:GetService("Workspace").DescendantAdded:Connect(function(descendant)
            pcall(function()
                if descendant:IsA("BasePart") then
                    descendant.Material = Enum.Material.SmoothPlastic
                    descendant.Reflectance = 0
                elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
                    descendant:Destroy()
                end
            end)
        end)
    else
        if connection then
            connection:Disconnect()
        end
        disableOptimizations()
        -- Reset sky to default (optional, as game-specific sky may not restore)
        pcall(function()
            for _, sky in pairs(Lighting:GetChildren()) do
                if sky:IsA("Sky") then
                    sky:Destroy()
                end
            end
            Lighting.Ambient = Color3.fromRGB(0, 0, 0)
        end)
    end
end

-- Create mobile-friendly GUI
local function createGUI()
    pcall(function()
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Parent = Player:WaitForChild("PlayerGui")
        ScreenGui.ResetOnSpawn = false
        ScreenGui.IgnoreGuiInset = true

        local ToggleButton = Instance.new("TextButton")
        ToggleButton.Size = UDim2.new(0, 120, 0, 120) -- Larger for mobile
        ToggleButton.Position = UDim2.new(0.85, -130, 0.1, 10) -- Top-right
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
        UserInputService.TouchTap:Connect(function(touchPositions, processed)
            if not processed then
                local touchPos = touchPositions[1]
                local guiPos = ToggleButton.AbsolutePosition
                local guiSize = ToggleButton.AbsoluteSize
                if touchPos.X >= guiPos.X and touchPos.X <= guiPos.X + guiSize.X and
                   touchPos.Y >= guiPos.Y and touchPos.Y <= guiPos.Y + guiSize.Y then
                    toggleOptimizations()
                    updateButtonText()
                end
            end
        end)

        print("Mobile GUI created successfully.")
    end)
end

-- Initialize script
pcall(function()
    createGUI()
    print("FPS Booster with Mobile GUI and Gray Sky loaded. Tap the button to toggle optimizations.")
end)
