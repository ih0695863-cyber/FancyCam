-- Cartridge's FancyCam!
local CAM_DIST = 140*FRACUNIT
local CAM_HEIGHT = 15*FRACUNIT
local CAM_LAG = FRACUNIT/6

rawset(_G, "CR_GRINDRAIL", 3888)

addHook("ThinkFrame", function()
    for p in players.iterate do
        if not p.mo or not p.mo.valid then return false end
        if twodlevel or p.bot or (p.powers[pw_carry] == CR_GRINDRAIL) then return false end
        if p.playerstate == PST_LIVE then
           local cam = p.awayviewmobj
            if not (cam and cam.valid and userdataType(cam) == "CAMERA_T") then
                cam = camera
            end

            if cam then
                local prevz = p.mo.prevz or p.mo.z

                cam.angle = R_PointToAngle2(cam.x, cam.y, p.mo.x, p.mo.y)

                local tx = p.mo.x - FixedMul(cos(cam.angle), CAM_DIST)
                local ty = p.mo.y - FixedMul(sin(cam.angle), CAM_DIST)
                local tz = p.mo.z + p.mo.height/2 + CAM_HEIGHT

                local x = cam.x + FixedMul(tx - cam.x, CAM_LAG)
                local y = cam.y + FixedMul(ty - cam.y, CAM_LAG)
                local z = cam.z + FixedMul(tz - cam.z, CAM_LAG)

                P_TeleportCameraMove(cam, x, y, z)

                if p.mo.z < prevz and P_IsObjectOnGround(p.mo) then
                    cam.momz = cam.momz + ((p.mo.z - prevz) + CAM_HEIGHT*2)
                    cam.aiming = cam.aiming - (p.mo.z - prevz)
                elseif p.mo.z > prevz and P_IsObjectOnGround(p.mo) then
                    cam.momz = cam.momz - ((p.mo.z - prevz) + CAM_HEIGHT/2)
                    cam.aiming = cam.aiming + (p.mo.z - prevz)
                end
            end
        end

        if p.mo and p.mo.valid then
            p.mo.prevz = p.mo.z
        end
    end
end)