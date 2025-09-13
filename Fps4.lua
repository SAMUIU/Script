-- Script para optimizar FPS en Roblox
-- Desactiva texturas, baja resolución, reduce efectos de partículas y desbloquea FPS máximos
-- Compatible con ejecutores como Delta o Krnl

local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- Función para desactivar texturas
local function disableTextures()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") or v:IsA("UnionOperation") or v:IsA("MeshPart") then
            if v.Material ~= Enum.Material.ForceField then
                v.Material = Enum.Material.SmoothPlastic
            end
            if v:IsA("Texture") or v:IsA("Decal") then
                v:Destroy()
            end
        end
    end
end

-- Función para reducir efectos de partículas
local function reduceParticles()
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
            v.Enabled = false
            v:Destroy() -- Elimina los efectos de partículas
        end
        if v:IsA("Explosion") then
            v.Visible = false
        end
        if v:IsA("Trail") then
            v.Enabled = false
        end
    end
end

-- Función para bajar la resolución
local function lowerResolution()
    local player = Players.LocalPlayer
    if player then
        local playerGui = player:WaitForChild("PlayerGui")
        for _, gui in pairs(playerGui:GetChildren()) do
            if gui:IsA("ScreenGui") then
                gui.IgnoreGuiInset = true
            end
        end
        -- Ajustar calidad gráfica al mínimo
        settings().Rendering.QualityLevel = 1
    end
end

-- Función para desbloquear FPS
local function unlockFPS()
    setfpscap(0) -- Desbloquea el límite de FPS (requiere soporte del ejecutor)
end

-- Función para optimizar la iluminación
local function optimizeLighting()
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 100000
    Lighting.FogStart = 100000
    Lighting.Brightness = 1
    Lighting.ClockTime = 12
    Lighting.GeographicLatitude = 0
    sethiddenproperty(Lighting, "Technology", Enum.Technology.Compatibility)
end

-- Ejecutar todas las optimizaciones
local function optimizeGame()
    pcall(function()
        disableTextures()
        reduceParticles()
        lowerResolution()
        unlockFPS()
        optimizeLighting()
        print("Optimización de FPS completada: texturas desactivadas, partículas reducidas, resolución bajada, FPS desbloqueados.")
    end)
end

-- Ejecutar el script automáticamente
optimizeGame()

-- Monitorear nuevos objetos para desactivar texturas y partículas dinámicamente
Workspace.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("Texture") or descendant:IsA("Decal") then
        descendant:Destroy()
    elseif descendant:IsA("BasePart") or descendant:IsA("UnionOperation") or descendant:IsA("MeshPart") then
        if descendant.Material ~= Enum.Material.ForceField then
            descendant.Material = Enum.Material.SmoothPlastic
        end
    elseif descendant:IsA("ParticleEmitter") or descendant:IsA("Smoke") or descendant:IsA("Fire") or descendant:IsA("Sparkles") then
        descendant.Enabled = false
        descendant:Destroy()
    elseif descendant:IsA("Trail") then
        descendant.Enabled = false
    elseif descendant:IsA("Explosion") then
        descendant.Visible = false
    end
end)
