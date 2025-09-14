local Players = game:GetService("Players")
local player = Players.LocalPlayer
local DISTANCE = 10 -- Distancia en studs para teletransportarse (ajusta si quieres)
local WALL_DURATION = 3 -- Segundos antes de que la pared desaparezca

-- Esperar a que el personaje cargue
local function onCharacterAdded(character)
    wait(1) -- Pequeña espera para asegurar que todo esté listo
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 5) -- Timeout de 5 segundos
    
    if not humanoidRootPart then
        print("Error: No se encontró HumanoidRootPart")
        return
    end

    -- Crear GUI
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TPForwardGui"
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
        if character and character:FindFirstChild("HumanoidRootPart") and character.Humanoid.Health > 0 then
            local currentCFrame = humanoidRootPart.CFrame
            local forwardVector = currentCFrame.LookVector * DISTANCE
            local newPosition = currentCFrame.Position + forwardVector
            local newCFrame = CFrame.new(newPosition, newPosition + currentCFrame.LookVector) -- Mantiene la orientación

            -- Crear pared detrás de la posición inicial
            local wall = Instance.new("Part")
            wall.Size = Vector3.new(10, 10, 1) -- Pared ancha y alta, pero delgada
            wall.Position = currentCFrame.Position - (currentCFrame.LookVector * 2) -- 2 studs detrás
            wall.Orientation = Vector3.new(0, currentCFrame.Yaw, 0) -- Orientada en la dirección del jugador
            wall.Anchored = true -- No se mueve
            wall.Transparency = 1 -- Invisible para no ser obvio
            wall.CanCollide = true -- Colisionable para bloquear
            wall.Parent = game.Workspace

            -- Teletransportar
            humanoidRootPart.CFrame = newCFrame
            wait(0.2) -- Espera para estabilizar y evitar que el juego te devuelva

            print("¡Teletransportado " .. DISTANCE .. " studs hacia adelante! Pared creada en: ", wall.Position)

            -- Eliminar la pared después de WALL_DURATION segundos
            spawn(function()
                wait(WALL_DURATION)
                if wall then
                    wall:Destroy()
                end
            end)
        else
            print("Error: Personaje no encontrado o muerto. Respawnea e intenta de nuevo.")
        end
    end)
    
    -- Limpiar GUI si el personaje muere
    character.AncestryChanged:Connect(function()
        if not character.Parent then
            screenGui:Destroy()
        end
    end)
end

-- Conectar al evento de carga del personaje
if player.Character then
    onCharacterAdded(player.Character)
end
player.CharacterAdded:Connect(onCharacterAdded)
