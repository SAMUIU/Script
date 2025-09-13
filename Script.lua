### Instrucciones para GitHub:
1. **Crear un archivo en GitHub**:
   - Ve a tu repositorio en GitHub.
   - Crea un nuevo archivo, por ejemplo, `README.md` para la documentación completa o `teleport_script.lua` si solo quieres el código Lua.
   - Copia y pega el contenido de arriba (para `.md`) o solo el bloque de código Lua (desde `local UserInputService` hasta el final) si usas un archivo `.lua`.
   - Guarda el archivo con un mensaje de commit claro, como "Added Roblox teleport script".

2. **Solo el código Lua** (si prefieres un archivo `.lua` puro):
   ```lua
   -- Roblox Teleport Script
   -- Description: Teleports the player to specified coordinates when pressing 'E' and shows a confirmation message.
   -- Author: [Your Name or Handle]
   -- Compatibility: Works with most Roblox games, but some anti-cheat systems may block it.
   -- Last Updated: September 12, 2025

   local UserInputService = game:GetService("UserInputService")
   local Players = game:GetService("Players")
   local Player = Players.LocalPlayer

   -- Function to teleport the player
   local function teleportPlayer()
       if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
           local humanoidRootPart = Player.Character.HumanoidRootPart
           -- Teleport to coordinates (X, Y, Z). Modify as needed.
           humanoidRootPart.CFrame = CFrame.new(0, 50, 0)
           
           -- Create a ScreenGui for the on-screen message
           local ScreenGui = Instance.new("ScreenGui")
           local TextLabel = Instance.new("TextLabel")
           
           ScreenGui.Parent = Player:WaitForChild("PlayerGui")
           TextLabel.Parent = ScreenGui
           TextLabel.Size = UDim2.new(0, 200, 0, 50)
           TextLabel.Position = UDim2.new(0.5, -100, 0.5, -25)
           TextLabel.Text = "Teleported!"
           TextLabel.TextSize = 20
           TextLabel.BackgroundTransparency = 0.5
           TextLabel.BackgroundColor3 = Color3.new(0, 0, 0)
           TextLabel.TextColor3 = Color3.new(1, 1, 1)
           
           -- Remove the message after 2 seconds
           wait(2)
           ScreenGui:Destroy()
       end
   end

   -- Detect 'E' key press
   UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
       if not gameProcessedEvent and input.KeyCode == Enum.KeyCode.E then
           teleportPlayer()
       end
   end)

   print("Teleport script loaded. Press 'E' to teleport.")
