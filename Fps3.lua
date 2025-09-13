```lua
-- Script de optimización para Roblox usando ejecutores como Delta o Krnl
-- Este script establece varios FFlags para deshabilitar texturas, bajar la calidad/resolución, desbloquear el límite de FPS y cambiar el cielo a gris.
-- Nota: Asegúrate de que tu ejecutor soporte la función setfflag. Ejecuta esto en el juego.

-- Deshabilitar texturas (hace que las texturas sean de baja calidad o invisibles)
setfflag("FIntDebugTextureManagerSkipMips", "100")  -- Salta mipmaps para eliminar/borrar texturas
setfflag("DFIntTextureQualityOverride", "1")       -- Baja la calidad de texturas
setfflag("DFFlagTextureQualityOverrideEnabled", "True")
setfflag("DFIntTextureCompositorActiveJobs", "0")  -- Desactiva composición de texturas

-- Bajar resolución y calidad general (reduce detalles para mejor rendimiento)
setfflag("DFIntDebugFRMQualityLevelOverride", "1") -- Nivel de calidad bajo
setfflag("FFlagDisablePostFx", "True")             -- Desactiva efectos post-procesamiento
setfflag("FIntRenderShadowIntensity", "0")         -- Desactiva sombras
setfflag("DFIntCSGLevelOfDetailSwitchingDistance", "0")
setfflag("DFIntCSGLevelOfDetailSwitchingDistanceL12", "0")
setfflag("DFIntCSGLevelOfDetailSwitchingDistanceL23", "0")
setfflag("DFIntCSGLevelOfDetailSwitchingDistanceL34", "0")
setfflag("FIntFRMMinGrassDistance", "0")           -- Reduce detalles como hierba

-- Desbloquear límite de FPS (establece un objetivo alto para uncap)
setfflag("DFIntTaskSchedulerTargetFps", "9999")    -- FPS objetivo alto (ajusta a tu monitor si es necesario)
setfflag("FFlagTaskSchedulerLimitTargetFpsTo2402", "False")
setfflag("FFlagGameBasicSettingsFramerateCap5", "False")

-- Cambiar textura del cielo a gris
setfflag("FFlagDebugSkyGray", "True")              -- Cielo gris sin nubes

-- Optimizaciones adicionales
setfflag("DFFlagDebugPauseVoxelizer", "True")
setfflag("DFFlagDebugRenderForceTechnologyVoxel", "True")
setfflag("FFlagGlobalWindRendering", "False")

-- Optimizaciones en Lua estándar (no FFlags)
game:GetService("Lighting").GlobalShadows = false
game:GetService("Lighting").FogEnd = 999999
workspace.StreamingEnabled = true  -- Habilita streaming para mejor perf en mundos grandes

print("Script de optimización cargado exitosamente!")
```
