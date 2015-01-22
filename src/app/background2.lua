function background2_c()

local background=cc.LayerColor:create(cc.c4b(41,170,212,255))
local sp=cc.Sprite:create("back1.png")
--sp:setScaleX(screen_x/sp:getContentSize().width)
--sp:setScaleY(screen_y/sp:getContentSize().height)
sp:setPosition(screen_x/2,screen_y/2)
--background:addChild(sp)
--local mask=cc.NVGDrawNode:create()
--mask:drawSolidRect(cc.p(0,0),cc.p(screen_x,screen_y),cc.c4f(41/255,170/255,212/255,1))
--background:addChild(mask)
--mask:setPosition(0,0)


local life_time=15
local generate_rate=20
local size=150
-- function circle_update()

--     local x=math.random(0-screen_x/10,screen_x+screen_x/10)
--     local y=math.random(screen_y*3/2,screen_y*2)
--     local circle=cc.DrawNode:create()
--     local angle=math.random(0,90)
--     --circle:drawSolidCircle(cc.p(0,0),screen_x/6,100,1000,cc.c4f(0,0,0,0.10))
--     circle:drawSolidRect(cc.p(0,0),cc.p(size,size),cc.c4f(0,0,0,0.10))
--     circle:setPosition(x,y)
--     circle:setRotation(angle)
--     circle:setOpacityModifyRGB(true)
--     local ac=cc.ScaleTo:create(life_time,0.3)
--     local move=cc.MoveTo:create(life_time,cc.p(x,-screen_y/2))
--     ac=cc.Spawn:create(ac,move)
--     local remove=function(ob)ob:removeFromParent()end
--     circle:runAction(cc.Sequence:create(ac,cc.CallFunc:create(remove,{circle})))
--     background:addChild(circle)
-- end
--background:getScheduler():scheduleScriptFunc(circle_update, 1/generate_rate, false)
background_test=100
print("bgg")
return background
end