-- Script de vuelo para Roblox (compatible con ejecutores como Delta o Krnl)
-- Este script permite volar usando las teclas W, A, S, D para moverse, Space para subir y Ctrl para bajar.
-- Presiona 'E' para activar/desactivar el vuelo.
-- Usa bajo tu propio riesgo, ya que los exploits pueden violar los términos de servicio de Roblox.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local flying = false
local speed = 50  -- Velocidad de vuelo (ajusta si quieres más rápido)
local bodyGyro = nil
local bodyVelocity = nil

-- Función para activar el vuelo
local function startFlying()
    if flying then return end
    flying = true
    
    -- Crear BodyGyro para rotación
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
    bodyGyro.P = 3000
    bodyGyro.Parent = rootPart
    
    -- Crear BodyVelocity para movimiento
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart
    
    -- Desactivar colisiones con el suelo si es necesario
    humanoid.PlatformStand = true
    
    print("Vuelo activado. Usa W/A/S/D para moverte, Space para subir, Ctrl para bajar.")
end

-- Función para desactivar el vuelo
local function stopFlying()
    if not flying then return end
    flying = false
    
    if bodyGyro then bodyGyro:Destroy() end
    if bodyVelocity then bodyVelocity:Destroy() end
    
    humanoid.PlatformStand = false
    
    print("Vuelo desactivado.")
end

-- Manejar teclas para activar/desactivar
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.E then
        if flying then
            stopFlying()
        else
            startFlying()
        end
    end
end)

-- Manejar movimiento durante el vuelo
local keys = { W = false, A = false, S = false, D = false, Space = false, LeftControl = false }

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then keys.W = true end
    if input.KeyCode == Enum.KeyCode.A then keys.A = true end
    if input.KeyCode == Enum.KeyCode.S then keys.S = true end
    if input.KeyCode == Enum.KeyCode.D then keys.D = true end
    if input.KeyCode == Enum.KeyCode.Space then keys.Space = true end
    if input.KeyCode == Enum.KeyCode.LeftControl then keys.LeftControl = true end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then keys.W = false end
    if input.KeyCode == Enum.KeyCode.A then keys.A = false end
    if input.KeyCode == Enum.KeyCode.S then keys.S = false end
    if input.KeyCode == Enum.KeyCode.D then keys.D = false end
    if input.KeyCode == Enum.KeyCode.Space then keys.Space = false end
    if input.KeyCode == Enum.KeyCode.LeftControl then keys.LeftControl = false end
end)

-- Actualizar movimiento en cada frame
RunService.RenderStepped:Connect(function()
    if not flying then return end
    
    local camera = workspace.CurrentCamera
    local moveDirection = Vector3.new(0, 0, 0)
    
    if keys.W then moveDirection = moveDirection + camera.CFrame.LookVector end
    if keys.S then moveDirection = moveDirection - camera.CFrame.LookVector end
    if keys.A then moveDirection = moveDirection - camera.CFrame.RightVector end
    if keys.D then moveDirection = moveDirection + camera.CFrame.RightVector end
    
    if keys.Space then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
    if keys.LeftControl then moveDirection = moveDirection - Vector3.new(0, 1, 0) end
    
    if moveDirection.Magnitude > 0 then
        moveDirection = moveDirection.Unit * speed
    end
    
    bodyVelocity.Velocity = moveDirection
    bodyGyro.CFrame = camera.CFrame
end)

-- Monitorear respawn del personaje
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    if flying then
        startFlying()
    end
end)

print("Script de vuelo cargado. Presiona 'E' para activar/desactivar.")
