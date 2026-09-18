-- Cartridge's FancyCam!
local CAM_DIST = 140*FRACUNIT
local CAM_HEIGHT = 15*FRACUNIT
local CAM_LAG = FRACUNIT/6

rawset(_G, "CR_GRINDRAIL", 3888)

addHook("ThinkFrame", function()
    for p in players.iterate() do
        if p.mo and p.mo.valid
        and p.playerstate == PST_LIVE
        and not (p.mo.flags2 & MF2_TWOD)
        and not (p.powers[pw_carry] == CR_GRINDRAIL)
        and not p.bot and not p.exiting then
            if not camera then return end
            p.mo.prevz = $ or p.mo.z
            local cam = p.awayviewmobj or cam

            cam.angle = R_PointToAngle2(cam.x, cam.y, p.mo.x, p.mo.y)

            -- This is the ideal distance of the camera's x, y and z
            local tx = p.mo.x - FixedMul(cos(cam.angle), CAM_DIST)
            local ty = p.mo.y - FixedMul(sin(cam.angle), CAM_DIST)
            local tz = p.mo.z + p.mo.height/2 + CAM_HEIGHT

            -- Grab the camera's x, y and z and do this with it
            local x = cam.x + FixedMul(tx - cam.x, CAM_LAG)
            local y = cam.y + FixedMul(ty - cam.y, CAM_LAG)
            local z = cam.z + FixedMul(tz - cam.z, CAM_LAG)
            
            -- Finally, move the camera to the new position
            P_TeleportCameraMove(cam, x, y, z)

            if p.mo.z < p.mo.prevz
			and P_IsObjectOnGround(p.mo) then
                cam.momz = cam.momz + ((p.mo.z - p.mo.prevz) + CAM_HEIGHT*2)
                cam.aiming = cam.aiming - (p.mo.z - p.mo.prevz)
            elseif p.mo.z > p.mo.prevz
			and P_IsObjectOnGround(p.mo) then
                cam.momz = cam.momz - ((p.mo.z - p.mo.prevz) + CAM_HEIGHT/2)
                cam.aiming = cam.aiming + (p.mo.z - p.mo.prevz)
            end
        end
        p.mo.prevz = p.mo.z
    end
end)