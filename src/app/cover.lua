require("miaolib")
local cover=cc.Layer:create()
local middle=cc.DrawNode:create()
local line_lenth=10
local line_space=5
local move_time=1
for i=1,screen_y/(line_lenth+line_space)+1 do
    middle:drawLine(cc.p(screen_x/2,(i-1)*(line_lenth+line_space)),cc.p(screen_x/2,(i)*(line_lenth+line_space)-line_space),cc.c4f(1,1,1,0.4))
end
cover:addChild(middle)
local arrow=cc.Sprite:create("arrow_left.png")
arrow:setScale(0.5*screen_scale)
arrow:setPosition(350*screen_scale,800*screen_scale)
cover:addChild(arrow)
local arrow2=cc.Sprite:create("arrow_left.png")
arrow2:setScale(0.5*screen_scale)
arrow2:setFlippedX(true)
arrow2:setPosition(screen_x-350*screen_scale,800*screen_scale)
cover:addChild(arrow2)
local ttfConfig = {}
ttfConfig.fontFilePath="fonts/Abel-Regular.ttf" --这里的路径要设置对，否则create出来就是nil
ttfConfig.fontSize=screen_x/10       
local touch2start=cc.Label:createWithTTF(ttfConfig,"", cc.VERTICAL_TEXT_ALIGNMENT_CENTER,900)

touch2start:setString("TOUCH TO START")
touch2start:setScale(0.9)
touch2start:setTextColor(cc.c4b(255,255,255,255))
touch2start:setPosition(screen_x/2,screen_y*3/5)
touch2start:setColor(cc.c3b(255,251,74))
cover:addChild(touch2start)
local touch_tip=cc.Label:createWithTTF(ttfConfig,"", cc.VERTICAL_TEXT_ALIGNMENT_CENTER,screen_x*3/4)
touch_tip:setString("Touch Left or Right to Rotate the Ball")
touch_tip:setScale(0.5)

touch_tip:setTextColor(cc.c4b(255,255,255,255))
touch_tip:setPosition(screen_x/2,screen_y/2)
cover:addChild(touch_tip)

function cover:remove()
    local move=cc.MoveBy:create(move_time,cc.p(screen_x,0))
    move=cc.EaseBackInOut:create(move)
    touch2start:runAction(move)
    move:clone()
    arrow2:runAction(move:clone())
    local move=cc.MoveBy:create(move_time,cc.p(-screen_x,0))
    move=cc.EaseBackInOut:create(move)
    touch_tip:runAction(move)
    arrow:runAction(move:clone())
    
    cover:runAction(cc.Sequence:create(
        cc.DelayTime:create(1),cc.CallFunc:create(function()cover:removeFromParent();end,{cover})))
    
end
return cover