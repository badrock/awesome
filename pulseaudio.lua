local io = io
local math = math
local tonumber = tonumber
local tostring = tostring
local string = string

local naughty = require("naughty")
module("pulseaudio")

function volumeUp()
    local step = 655*5
    local f = io.popen("pacmd dump |grep 'set-sink-volume alsa_output.pci-0000_00_1f.3.analog-stereo'")
    local v = f:read()
    local volume = tonumber(string.sub(v, string.find(v, '0x') - 1))
    local newVolume = volume + step
    if newVolume > 80000 then
        newVolume = 80000
    -- if newVolume > 65536 then
    --     newVolume = 65536
    end
    io.popen("pacmd set-sink-volume 0 "..newVolume)
    io.popen("pacmd set-sink-volume 1 "..newVolume)
    f:close()
end

function volumeDown()
    local step = 655*5
    local f = io.popen("pacmd dump |grep 'set-sink-volume alsa_output.pci-0000_00_1f.3.analog-stereo'")
    local v = f:read()
    local volume = tonumber(string.sub(v, string.find(v, '0x') - 1))
    local newVolume = volume - step
    if newVolume < 0 then
        newVolume = 0
    end
    io.popen("pacmd set-sink-volume 0 "..newVolume)
    io.popen("pacmd set-sink-volume 1 "..newVolume)
    f:close()
end

function volumeMute()
    local g = io.popen("pacmd dump |grep  'set-sink-mute alsa_output.pci-0000_00_1f.3.analog-stereo'")
    local mute = g:read()
    if string.find(mute, "no") then
        io.popen("pacmd set-sink-mute 1 yes")
    else
        io.popen("pacmd set-sink-mute 1 no")
    end
    g:close()
end

function volumeInfo()
    volmin = 0
    volmax = 65536
    local f = io.popen("pacmd dump |grep 'set-sink-volume alsa_output.pci-0000_00_1f.3.analog-stereo'")
    local g = io.popen("pacmd dump |grep 'set-sink-mute alsa_output.pci-0000_00_1f.3.analog-stereo'")
    local v = f:read()
    local mute = g:read()
    if mute ~= nil and string.find(mute, "no") then
        volume = math.floor(tonumber(string.sub(v, string.find(v, '0x'),-1)) * 100 / volmax).." %"
    else
        volume = "✕"
    end
    f:close()
    g:close()
    return " 𝅘𝅥𝅮 "..volume.." "
end

