local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")

-- Función para desactivar texturas
local function disableTextures()
    for _, v in pairs(Workspace:GetDescendants()) do
        pcall(function()
            if v:IsA("BasePart") or v:IsA("UnionOperation") or v:IsA("MeshPart") then
                if v.Material ~= Enum.Material.ForceField then
                    v.Material = Enum.Material.SmoothPlastic
                end
            end
            if v:IsA("Texture") or v:IsA("Decal") then
                v:Destroy()
            end
        end)
    end
end

-- Función para reducir efectos de partículas
local function reduceParticles()
    for _, v in pairs(Workspace:GetDescendants()) do
        pcall(function()
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
        end)
    end
end

-- Función para bajar la resolución
local function lowerResolution()
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end)
end

-- Función para desbloquear FPS
local function unlockFPS()
    pcall(function()
        -- Alternativa para desbloquear FPS en ejecutores
        local success, err = pcall(function()
            settings().Rendering.FrameRateManager = Enum.FrameRateManager.Disabled
        end)
        if not success then
            warn("No se pudo desbloquear FPS: " .. tostring(err))
        end
    end)
end

-- Función para optimizar la iluminación y añadir cielo gris
local function optimizeLighting()
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 100000
        Lighting.FogStart = 100000
        Lighting.Brightness = 1
        Lighting.ClockTime = 12
        Lighting.GeographicLatitude = 0
        sethiddenproperty(Lighting, "Technology", Enum.Technology.Compatibility)
        
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
    end)
end

-- Función para estabilizar la cámara y manejar inputs
local function stabilizeCamera()
    local player = Players.LocalPlayer
    if not player then return end
    
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local camera = Workspace.CurrentCamera

    pcall(function()
        -- Configurar cámara estándar
        if camera then
            camera.CameraType = Enum.CameraType.Custom
            camera.FieldOfView = 70
            camera.CameraSubject = humanoid
        end

        -- Asegurar que el humanoid pueda moverse
        if humanoid then
            humanoid.AutoRotate = true
            humanoid.PlatformStand = false
            humanoid.Sit = false
            humanoid.WalkSpeed = math.max(humanoid.WalkSpeed, 16)
            humanoid.JumpPower = math.max(humanoid.JumpPower, 50)
        end

        -- Habilitar controles táctiles y de gamepad
        UserInputService.TouchEnabled = true
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default

        -- Permitir control de cámara con gamepad
        if UserInputService.GamepadEnabled and #UserInputService:GetConnectedGamepads() > 0 then
            ContextActionService:UnbindAction("BlockCameraJoystick")
        end
    end)
end

-- Función para restablecer el movimiento tras habilidades
local function resetMovementAfterSkill()
    local player = Players.LocalPlayer
    if not player or not player.Character then return end
    
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        pcall(function()
            humanoid.PlatformStand = false
            humanoid.Sit = false
            humanoid.WalkSpeed = math.max(humanoid.WalkSpeed, 16)
            humanoid.JumpPower = math.max(humanoid.JumpPower, 50)
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
        print("Optimización de FPS completada: texturas desactivadas, partículas reducidas, resolución bajada, FPS desbloqueados, cielo gris añadido, cámara estabilizada.")
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

-- Monitorear cambios en el personaje
Players.LocalPlayer.CharacterAdded:Connect(function()
    pcall(function()
        stabilizeCamera()
        resetMovementAfterSkill()
    end)
end)

-- Monitorear el estado del Humanoid para evitar personaje estático
RunService.Heartbeat:Connect(function()
    pcall(function()
        resetMovementAfterSkill()
    end)
end)

-- Restablecer movimiento tras habilidades (para controles táctiles)
UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent and input.UserInputType == Enum.UserInputType.Touch then
        task.spawn(function()
            task.wait(0.5) -- Reduje el tiempo de espera para mejor respuesta
            pcall(function()
                resetMovementAfterSkill()
            end)
        end)
    end
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
