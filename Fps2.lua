-- Roblox FPS Booster (Simplified)
-- Description: Optimizes game performance by disabling textures and lowering graphics quality to increase FPS.
-- Author: [Your Name or Handle]
-- Compatibility: Works with most Roblox games, but some anti-cheat systems may block it.
-- Last Updated: September 12, 2025

local Lighting = game:GetService("Lighting")
local Terrain = game:GetService("Workspace").Terrain

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

    print("FPS optimizations applied: textures disabled, graphics quality lowered.")
end

-- Run optimizations immediately
applyOptimizations()

-- Monitor new objects to keep optimizations
game:GetService("Workspace").DescendantAdded:Connect(function(descendant)
    if descendant:IsA("BasePart") then
        descendant.Material = Enum.Material.SmoothPlastic
        descendant.Reflectance = 0
    elseif descendant:IsA("Decal") or descendant:IsA("Texture") then
        descendant:Destroy()
    end
end)

print("Simplified FPS Booster loaded. Optimizations applied.")
