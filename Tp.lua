local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Coordenadas de la base (ajústalas según la ubicación de la base en Steal a Brainrot)
local BASE_POSITION = CFrame.new(Vector3.new(0, 5, 0)) -- ¡Cambia estas coordenadas a las de la base real!

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
    screenGui.Name = "TPBaseGui"
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    local button = Instance.new("TextButton")
    button.Name = "TPButton"
    button.Size = UDim2.new(0, 150, 0, 50)
    button.Position = UDim2.new(0, 10, 0, 10)
    button.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    button.Text = "TP a Base"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.SourceSansBold
    button.Parent = screenGui
    
    -- Función del botón
    button.MouseButton1Click:Connect(function()
        if character and character:FindFirstChild("HumanoidRootPart") and character.Humanoid.Health > 0 then
            -- Desactivar temporalmente la detección de colisiones para evitar problemas
            local wasAnchored = humanoidRootPart.Anchored
            humanoidRootPart.Anchored = true
            humanoidRootPart.CFrame = BASE_POSITION
            wait(0.1) -- Pequeña espera para estabilizar
            humanoidRootPart.Anchored = wasAnchored
            print("¡Teletransportado a la base!")
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
