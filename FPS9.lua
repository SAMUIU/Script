-- Script para optimizar FPS en Roblox (optimizado para juegos como Blox Fruits)
-- Desactiva texturas, reduce partículas, baja resolución, desbloquea FPS máximos, añade cielo gris
-- Corrige la cámara con joystick virtual en móvil y permite usar botones de interfaz (Shift Lock, habilidades) en la parte derecha
-- Compatible con ejecutores como Delta o Krnl

local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")

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
            v:Destroy()
        end
        if v:IsA("Explosion") then
            v.Visible = false
        end
        if v:IsA("Trail") then
            v.Enabled = false
        end
    end
end

-- Función para bajar la resolución sin mover la interfaz
local function lowerResolution()
    local player = Players.LocalPlayer
    if player then
        local playerGui = player:WaitForChild("PlayerGui")
        settings().Rendering.QualityLevel = 1
    end
end

-- Función para desbloquear FPS
local function unlockFPS()
    pcall(function()
        setfpscap(0) -- Desbloquea el límite de FPS
    end)
end

-- Función para optimizar la iluminación y añadir cielo gris
local function optimizeLighting()
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 100000
    Lighting.FogStart = 100000
    Lighting.Brightness = 1
    Lighting.ClockTime = 12
    Lighting.GeographicLatitude = 0
    pcall(function()
        sethiddenproperty(Lighting, "Technology", Enum.Technology.Compatibility)
    end)
    -- Añadir cielo gris
    local sky = Instance.new("Sky")
    sky.Parent = Lighting
    sky.CelestialBodiesShown = false
    sky.SkyboxBk = "rbxassetid://0"
    sky.SkyboxDn = "rbxassetid://0"
    sky.SkyboxFt = "rbxassetid://0"
    sky.SkyboxLf = "rbxassetid://0"
    sky.SkyboxRt = "rbxassetid://0"
    sky.SkyboxUp = "rbxassetid://0"
    sky.StarCount = 0
end

-- Función para estabilizar la cámara y manejar inputs de joystick
local function stabilizeCamera()
    local player = Players.LocalPlayer
    if player then
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        local camera = Workspace.CurrentCamera

        -- Forzar cámara estándar
        if camera then
            camera.CameraType = Enum.CameraType.Custom
            camera.FieldOfView = 70
            camera.CameraSubject = humanoid
        end

        -- Asegurar que el humanoid funcione correctamente
        if humanoid then
            humanoid.AutoRotate = true
            humanoid.PlatformStand = false
        end

        -- Detectar si hay un gamepad conectado
        local isGamepadConnected = UserInputService.GamepadEnabled and #UserInputService:GetConnectedGamepads() > 0

        pcall(function()
            if isGamepadConnected then
                -- Permitir control de cámara con gamepad (Thumbstick2)
                ContextActionService:UnbindAction("BlockCameraJoystick")
            else
                -- Bloquear control de cámara por joystick virtual en móvil (solo 25% superior derecho)
                UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
                    if gameProcessedEvent then return end
                    if input.UserInputType == Enum.UserInputType.Touch then
                        if input.Position then
                            local screenPos = Vector2.new(input.Position.X, input.Position.Y)
                            local viewportSize = camera.ViewportSize
                            -- Bloquear toques solo en el 25% superior derecho (joystick de cámara)
                            if screenPos.X > viewportSize.X * 0.5 and screenPos.Y < viewportSize.Y * 0.25 then
                                input.UserInputState = Enum.UserInputState.Cancel
                            end
                        end
                    end
                end)
            end

            -- Mantener comportamiento estándar
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            UserInputService.TouchEnabled = true
        end)
    end
end

-- Ejecutar todas las optimizaciones
local function optimizeGame()
    pcall(function()
        disableTextures()
        reduceParticles()
        lowerResolution()
        unlockFPS()
        optimizeLighting()
        stabilizeCamera()
        print("Optimización de FPS completada: texturas desactivadas, partículas reducidas, resolución bajada, FPS desbloqueados, cielo gris añadido, cámara estabilizada, botones de interfaz (incluyendo habilidades) habilitados.")
    end)
end

-- Ejecutar el script automáticamente
optimizeGame()

-- Monitorear nuevos objetos para desactivar texturas y partículas
Workspace.DescendantAdded:Connect(function(descendant)
    pcall(function()
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
end)

-- Monitorear cambios en el personaje y la cámara
Players.LocalPlayer.CharacterAdded:Connect(function()
    pcall(function()
        stabilizeCamera()
    end)
end)

RunService.RenderStepped:Connect(function()
    pcall(function()
        stabilizeCamera()
    end)
end)

-- Detectar conexión/desconexión de gamepad
UserInputService.GamepadConnected:Connect(function()
    pcall(function()
        stabilizeCamera()
    end)
end)

UserInputService.GamepadDisconnected:Connect(function()
    pcall(function()
        stabilizeCamera()
    end)
end)
