tmr.alarm(0, 1000, 1, function()
    if wifi.sta.getip() == nil then
        print("Connecting to AP...")
    else
        print('IP: ',wifi.sta.getip())
        tmr.stop(0)
    end
end)
sstate = false
srv=net.createServer(net.TCP)
srv:listen(80, function(conn)
    conn:on("receive", function(conn,payload)
--  print(payload, sstate)
    pstate=payload:match("sock([01])")
    if pstate~=nil then
        if pstate=="0" then
            sstate = false
        else
            sstate = true
        end
    end
    if file.open("tmpl.html", "r")~=nil then
        t = file.read()
        if sstate==false then
            t = t:gsub("Action", "Socket 1 is OFF")
            t = t:gsub("value=\"0\"", "value=\"0\" selected")
            t = t:gsub("turn off", "stay off")
        else
            t = t:gsub("Action", "Socket 1 is ON")
            t = t:gsub("value=\"1\"", "value=\"1\" selected")
            t = t:gsub("turn on", "stay on")
        end
--        print(t, sstate)
        conn:send(t)
        file.close()
    else
        conn:send("template not found!")
    end
    end)
    conn:on("sent", function(conn) conn:close() end)
end)
