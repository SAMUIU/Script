local Players = game:GetService("Players")
local player = Players.LocalPlayer
local DISTANCE = 10 -- Distancia en studs para teletransportarse
local WALL_DURATION = 3 -- Segundos antes de que la pared desaparezca

-- Función para depuración
local function debugPrint(message)
    print("[DEBUG] " .. tostring(message))
end

-- Verificar si el ejecutor soporta el script
if not game:IsLoaded() then
    debugPrint("Esperando a que el juego cargue...")
    game.Loaded:Wait()
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

    -- Crear GUI
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TPForwardGui"
    screenGui.ResetOnSpawn = false -- Evita que la GUI se elimine al respawnear
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    local button = Instance.new("TextButton")
    button.Name = "TPButton"
    button.Size = UDim2.new(0, 150, 0, 50)
    button.Position = UDim2.new(0, 10, 0, 10)
    button.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    button.Text = "TP Adelante"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.SourceSansBold
    button.Parent = screenGui
    
    -- Función del botón
    button.MouseButton1Click:Connect(function()
        if character and character.Parent and humanoidRootPart and humanoid.Health > 0 then
            debugPrint("Iniciando teletransporte...")
            local currentCFrame = humanoidRootPart.CFrame
            local forwardVector = currentCFrame.LookVector * DISTANCE
            local newPosition = currentCFrame.Position + forwardVector
            local newCFrame = CFrame.new(newPosition, newPosition + currentCFrame.LookVector)

            -- Crear pared detrás
            local wall = Instance.new("Part")
            wall.Size = Vector3.new(10, 10, 1)
            wall.Position = currentCFrame.Position - (currentCFrame.LookVector * 2)
            wall.Orientation = Vector3.new(0, currentCFrame.Yaw, 0)
            wall.Anchored = true
            wall.Transparency = 1 -- Invisible
            wall.CanCollide = true
            wall.Parent = game.Workspace
            debugPrint("Pared creada en: " .. tostring(wall.Position))

            -- Teletransportar
            pcall(function()
                humanoidRootPart.CFrame = newCFrame
                debugPrint("Teletransportado a: " .. tostring(newPosition))
            end)

            -- Eliminar pared después de WALL_DURATION
            spawn(function()
                wait(WALL_DURATION)
                if wall and wall.Parent then
                    wall:Destroy()
                    debugPrint("Pared eliminada")
                end
            end)
        else
            debugPrint("Error: Personaje no válido o muerto")
        end
    end)
    
    -- Limpiar GUI si el personaje muere
    character.AncestryChanged:Connect(function()
        if not character.Parent then
            screenGui:Destroy()
            debugPrint("GUI destruida al morir")
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
