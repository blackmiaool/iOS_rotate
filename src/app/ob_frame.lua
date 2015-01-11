function bad(dest)
    local x,y=dest.x,dest.y
    print("x,y="..x..y)
    local good=cc.Node:create()
    local top=bad_line_create(0,dest.x,color)
    top:setPosition(x/2,y)
    good:addChild(top)

    local bottom=bad_line_create(0,x,color)
    bottom:setPosition(x/2,0)
    good:addChild(bottom)

    local left=bad_line_create(90,y,color)
    left:setPosition(0,y/2)
    good:addChild(left)

    local right=bad_line_create(90,y,color)
    right:setPosition(x,y/2)
    good:addChild(right)

    return good
end
function bad_line_create(angle,length,color)
    --local line=cc.NVGDrawNode:create()
    local line=cc.Sprite:create("bad.png")
    line.kind="ob_frame"
    local x1,y1=0,0
    local x2,y2=length*math.cos(angle/xishu),length*math.sin(angle/xishu)

    line:setScale(0.2,length/line:getContentSize().height)

    --line:drawLine(cc.p(x1,y1),cc.p(x2,y2),color)

    line:setPhysicsBody(cc.PhysicsBody:createEdgeBox(cc.size(x2-x1,y2-y1),cc.PhysicsMaterial(100,0,100),1))

    line:getPhysicsBody():setRotationOffset((90-angle))
    line:setRotation((90-angle))
    line:getPhysicsBody():setContactTestBitmask(0x1)
    local ob=line
    function line:remove()
        local v=100
        local density=3
        local org=line:getParent():convertToWorldSpace(cc.p(line:getPosition()))
        local x_origin,y_origin=org.x,org.y
        local parent=ob:getParent()
        for i=1,length/density do
            local frag=cc.Sprite:create("frag.png")
            local scale=density/frag:getContentSize().width
            local x,y;         
            x=x_origin+(length/density/2-i-1)*density*math.cos(angle/xishu)
            y=y_origin+(length/density/2-i-1)*density*math.sin(angle/xishu)

            frag:setPosition(x,y)
            frag:setScale(scale)
            local ph1_deltax=math.random(-50,50)*screen_scale
            local ph1_deltay=math.random(-50,50)*screen_scale
            local ph1_time=math.random(2,4)/10
            local ph1_scale=math.random(2,4)/10

            local ph1_ac_moveBy=cc.MoveBy:create(ph1_time,cc.p(ph1_deltax,ph1_deltay))
            local ph1_ac_scale=cc.ScaleBy:create(ph1_time,ph1_scale,ph1_scale)
            local moveBy=cc.Spawn:create(ph1_ac_moveBy,ph1_ac_scale)
            moveBy=cc.EaseSineOut:create(moveBy)

            local move=cc.MoveTo:create(0.5,cc.p(main_scene.mvp:getPosition()))
            move=cc.EaseSineOut:create(move)
            local ac=cc.Sequence:create(
                moveBy,move,cc.CallFunc:create(function()frag:removeFromParent()end,{0}))
            frag:runAction(ac)

            main_scene:addChild(frag)

        end
        line:removeFromParent()
        print("line")
    end
    return line
end


function bad_rect_create(dest) 
    local rect=cc.NVGDrawNode:create()
    rect:drawRect(cc.rect(0,0,dest.x,dest.y),cc.c4f(1,1,1,1))
    rect:setLineWidth(5*screen_scale)
    rect.kind="ob_frame"
    rect:setPhysicsBody(cc.PhysicsBody:createEdgeBox(
        cc.size(dest.x,dest.y),cc.PhysicsMaterial(100,0,100),1,cc.p(dest.x/2,dest.y/2)))
    rect:getPhysicsBody():setContactTestBitmask(0x1)
    rect:setFillColor(cc.c4f(1,1,1,0))
    return rect
end



















