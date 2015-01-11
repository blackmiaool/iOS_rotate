function laser_create(angle)
    local laser=cc.Node:create()
    
    
    local core=cc.NVGDrawNode:create()
    core:drawSolidCircle(cc.p(0,0),screen_x/100,cc.c4f(1,1,1,1))
    
    
--    local light_core=cc.NVGDrawNode:create()
--    light:drawLine(cc.p(0,0),cc.p(r2xy(1000,angle)),cc.c4f(1,0,0,1))
    
    local light_core=cc.Sprite:create("laser.png")
    light_core:setScale(0.2,1)
    light_core:setAnchorPoint(0.5,0)
    
    laser.core=core

    laser:addChild(light_core)
    laser:addChild(core)
    function getAngle(angle)
    end
    return laser
end