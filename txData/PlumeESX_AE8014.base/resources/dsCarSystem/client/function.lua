--------------------------------------------
--------------------------------------------
--  Script    : dsCarSystem               --
--  Developer : WinMew ดูดมาจาก dyztiny    --
--  และ winmew ก็ขาย สุดท้ายก็หลุด            --
--  Discord  : https://discord.gg/rD6UD4m --
--------------------------------------------
--------------------------------------------

function isVehicleClassHasBelt(class)
    if (not class or class == nil) then return false end

    local hasBelt = Config.BeltClass[class]
    if (not hasBelt or hasBelt == nil) then return false end

    return hasBelt
end 