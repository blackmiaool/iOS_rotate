require("miaolib")

local core_r=screen_x/640*160 
local shield_r=screen_x/640*160
local shield_w=200
local shield_rw=150
local function core_create()
    
    --local core=cc.DrawNode:create()
    local core=cc.NVGDrawNode:create()
    core:drawCircle(cc.p(0,0),core_r,cc.c4f(1,1,1,0.7) )
    --core:drawCircle(cc.p(0,0),100,1,3,false,cc.c4f(0,1,1,1))
--    core:setPhysicsBody(cc.PhysicsBody:createCircle(core_r,
--        cc.PhysicsMaterial(1000,1,100)))
--    core:getPhysicsBody():setGravityEnable(false)
--    --core:getTexture():setAntiAliasTexParameters()
--    core:getPhysicsBody():setContactTestBitmask(0x1)
    return core
end





local function shield_create()
    local shield_node=cc.Node:create()
    shield_node:setAnchorPoint(cc.p(0.5,0.5))

    local shield=cc.Sprite:create("shield.png")
    
    local shield_scale=screen_x/10/shield:getContentSize().width
    local r=shield_scale*shield:getContentSize().width

    
    shield_node.shield=shield
    shield.r=r
    shield:setScale(shield_scale)

    shield_node:addChild(shield)
    shield:setPosition(0,0)
    shield:runAction(cc.RepeatForever:create(cc.RotateBy:create(1,shield_w)))
    function shield:out()
        shield:setPhysicsBody(cc.PhysicsBody:createCircle(r/2,cc.PhysicsMaterial(1000,1,10000)))
        shield:getPhysicsBody():setGravityEnable(false)
        shield:getTexture():setAntiAliasTexParameters()
        shield:getPhysicsBody():setContactTestBitmask(0x1)            
        shield:getPhysicsBody():setAngularVelocity(-shield_w/xishu)
        shield:stopAllActions()
        local out=cc.MoveBy:create(0.5,cc.p(0,shield_r))
        out=cc.EaseSineOut:create(out)
        --shield:setPositionZ(10)
        shield:runAction(out)
    end
    local velocity=shield_rw
    
    
    
    function shield_node:left()
        local rotate_left=cc.RotateBy:create(1,-velocity)
        rotate_left=cc.RepeatForever:create(rotate_left)
        self:stopAllActions()
        self:runAction(rotate_left)
    end
    function shield_node:right()
        local rotate_right=cc.RotateBy:create(1,velocity)
        rotate_right=cc.RepeatForever:create(rotate_right)
        shield_node:stopAllActions()
        shield_node:runAction(rotate_right)
    end
    function shield_node:stop()
        shield_node:stopAllActions()
    end
    function shield_node:setPos(angle,distance)
        --shield:setPosition(distance,0)
        shield_node:setRotation(-angle)
    end

    return shield_node
end
local mvp=cc.Node:create()
local shield_node=shield_create()
mvp:addChild(shield_node,1)
mvp.shield_node=shield_node
mvp.shield=shield_node.shield




local core=core_create()
mvp:addChild(core)
mvp.core=core


function points_setScale(points,scale)
    for i=1,#points do
        points[i].x=points[i].x*scale
        points[i].y=points[i].y*scale
    end
end
--local points={
--    cc.p(-40.5000,74.0000),
--    cc.p(-44.5000,59.0000),
--    cc.p(-78.0000,63.5000), 
--    cc.p(-44.0000,88), 
-- 
--}
--local points2={
--    cc.p(-78.0000,63.5000),
--    cc.p(-44.5000,59.0000),  
--    cc.p(-79.0000,0.5000)  , 
--    cc.p(-100.0000,0.5000),
--    cc.p(-93,31)
--}
local test2=cc.Node:create()
local bd=cc.PhysicsBody:create()
--test:setPhysicsBody(cc.PhysicsBody:createPolygon(points,cc.PhysicsMaterial(1000,1,10000)))



--local ttt=cc.PhysicsBody:createPolygon(points2,cc.PhysicsMaterial(1000,1,100))
--test:getPhysicsBody():addShape(ttt:getShapes())
--mvp:addChild(test2)


local test=getPlistDict("test.plist")
function string2nums(str)

end
function array_handle(array)
    local point_table={}
    for i,j in pairs(array) do
        --print(string2nums(j))
        local miao=loadstring("return"..j)
        miao=miao()

        table.insert(point_table,#point_table+1,cc.p(miao[1],miao[2]))
    end
    return point_table
end
for i,j in pairs(test["bodies"]["ob_yellow"]["fixtures"][1]["polygons"]) do

    bd:addShape(cc.PhysicsBody:createPolygon(array_handle(j),cc.PhysicsMaterial(100000,1,1)):getShape(0))
    --print(i,j)
end
test2:setPhysicsBody(bd)
test2:getPhysicsBody():setGravityEnable(false)
test2:setPosition(0,300)
return mvp

