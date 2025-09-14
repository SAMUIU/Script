local Players = game:GetService("Players")
local player = Players.LocalPlayer
local TELEPORT_INTERVAL = 1 -- Segundos entre teletransportes (ajusta si quieres)
local isTeleporting = false -- Estado del teletransporte repetitivo
local spawnCFrame = nil -- Almacena la posición del spawn

-- Función para depuración
local function debugPrint(message)
    print("[DEBUG] " .. tostring(message))
end

-- Verificar si el juego está cargado
if not game:IsLoaded() then
    debugPrint("Esperando a que el juego cargue...")
    game.Loaded:Wait()
end

-- Función para teletransportar al spawn
local function teleportToSpawn(character, humanoidRootPart)
    if spawnCFrame and character and humanoidRootPart and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0 then
        pcall(function()
            humanoidRootPart.CFrame = spawnCFrame
            debugPrint("Teletransportado al spawn en: " .. tostring(spawnCFrame.Position))
        end)
    else
        debugPrint("Error: No se puede teletransportar (personaje no válido o muerto)")
    end
end

-- Esperar a que el personaje cargue
local function onCharacterAdded(character)
    debugPrint("Personaje cargado, configurando script...")
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5)
    local humanoid = character:WaitForChild("Humanoid", 5)
    
    if not humanoidRootPart or not humanoid then
        debugPrint("Error: No se encontró HumanoidRootPart o Humanoid")
        return
    end

    -- Guardar la posición del spawn
    spawnCFrame = humanoidRootPart.CFrame
    debugPrint("Posición del spawn guardada: " .. tostring(spawnCFrame.Position))

    -- Crear GUI
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TPSpawnGui"
    screenGui.ResetOnSpawn = false -- Evita que la GUI se elimine al respawnear
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    local button = Instance.new("TextButton")
    button.Name = "TPToggleButton"
    button.Size = UDim2.new(0, 150, 0, 50)
    button.Position = UDim2.new(0, 10, 0, 10)
    button.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    button.Text = "Activar TP al Spawn"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.SourceSansBold
    button.Parent = screenGui

    -- Función para manejar el teletransporte repetitivo
    local function startTeleporting()
        while isTeleporting and character and character.Parent and humanoidRootPart and humanoid.Health > 0 do
            teleportToSpawn(character, humanoidRootPart)
            wait(TELEPORT_INTERVAL)
        end
    end

    -- Función del botón
    button.MouseButton1Click:Connect(function()
        isTeleporting = not isTeleporting -- Alternar estado
        button.Text = isTeleporting and "Desactivar TP al Spawn" or "Activar TP al Spawn"
        button.BackgroundColor3 = isTeleporting and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 162, 255)
        debugPrint(isTeleporting and "Teletransporte repetitivo activado" or "Teletransporte repetitivo desactivado")
        
        if isTeleporting then
            spawn(startTeleporting) -- Iniciar teletransporte en un hilo separado
        end
    end)
    
    -- Limpiar GUI si el personaje muere
    character.AncestryChanged:Connect(function()
        if not character.Parent then
            screenGui:Destroy()
            isTeleporting = false -- Detener teletransporte
            debugPrint("GUI destruida y teletransporte detenido al morir")
        end
    end)
end

-- Conectar al evento de carga del personaje
if player.Character then
    debugPrint("Personaje inicial detectado, ejecutando onCharacterAdded")
    onCharacterAdded(player.Character)
end
player.CharacterAdded:Connect(onCharacterAdded)

debugPrint("Script cargado correctamente")
