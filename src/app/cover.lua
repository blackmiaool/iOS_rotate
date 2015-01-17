require("miaolib")
local cover=cc.Layer:create()
local middle=cc.NVGDrawNode:create()
local line_lenth=10
local line_space=5
local move_time=1


local ttfConfig = {}
ttfConfig.fontFilePath="fonts/Abel-Regular.ttf" --这里的路径要设置对，否则create出来就是nil
ttfConfig.fontSize=screen_x/10  

local arrow2=cc.Sprite:create("arrow_left.png")
--arrow2:setScale(0)
arrow2:setOpacity(0)
--cover:addChild(arrow2,5)
     
local touch2start=cc.Label:createWithTTF(ttfConfig,"", cc.VERTICAL_TEXT_ALIGNMENT_CENTER,900)

touch2start:setString("TOUCH TO START")
touch2start:setScale(0.9)
touch2start:setTextColor(cc.c4b(255,255,255,255))
touch2start:setPosition(screen_x/2,screen_y*3/5)
touch2start:setColor(cc.c3b(255,251,74))
touch2start:setPositionZ(1)
cover:addChild(touch2start,1)
local touch_tip=cc.Label:createWithTTF(ttfConfig,"", cc.VERTICAL_TEXT_ALIGNMENT_CENTER,screen_x*3/4)
touch_tip:setString("Touch Left or Right to Rotate the Ball")
touch_tip:setScale(0.5)

touch_tip:setTextColor(cc.c4b(255,255,255,255))
touch_tip:setPosition(screen_x/2,screen_y/2)
touch_tip:setPositionZ(1)
cover:addChild(touch_tip,2)

function cover:remove()
    local move=cc.MoveBy:create(move_time,cc.p(screen_x,0))
    move=cc.EaseBackInOut:create(move)
    touch2start:runAction(move)
    local move=cc.MoveBy:create(move_time,cc.p(-screen_x,0))
    move=cc.EaseBackInOut:create(move)
     touch_tip:runAction(move)
    
    -- cover:runAction(cc.Sequence:create(
    --     cc.DelayTime:create(1),cc.CallFunc:create(function()cover:removeFromParent();end,{cover})))
    
end
return cover