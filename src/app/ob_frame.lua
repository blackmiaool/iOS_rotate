local ob_m=cc.PhysicsMaterial(100,0,100)
--function bad(dest)
--    local x,y=dest.x,dest.y
--    print("x,y="..x..y)
--    local good=cc.Node:create()
--    local top=bad_line_create(0,dest.x,color)
--    top:setPosition(x/2,y)
--    good:addChild(top)
--
--    local bottom=bad_line_create(0,x,color)
--    bottom:setPosition(x/2,0)
--    good:addChild(bottom)
--
--    local left=bad_line_create(90,y,color)
--    left:setPosition(0,y/2)
--    good:addChild(left)
--
--    local right=bad_line_create(90,y,color)
--    right:setPosition(x,y/2)
--    good:addChild(right)
--
--    return good
--end
--function bad_line_create(angle,length,color)
--    --local line=cc.NVGDrawNode:create()
--    local line=cc.Sprite:create("bad.png")
--    line.kind="ob_frame"
--    local x1,y1=0,0
--    local x2,y2=length*math.cos(angle/xishu),length*math.sin(angle/xishu)
--
--    line:setScale(0.2,length/line:getContentSize().height)
--
--    --line:drawLine(cc.p(x1,y1),cc.p(x2,y2),color)
--
--    line:setPhysicsBody(cc.PhysicsBody:createEdgeBox(cc.size(x2-x1,y2-y1),cc.PhysicsMaterial(100,0,100),1))
--
--    line:getPhysicsBody():setRotationOffset((90-angle))
--    line:setRotation((90-angle))
--    line:getPhysicsBody():setContactTestBitmask(0x1)
--    local ob=line
--    function line:remove()
--        local v=100
--        local density=3
--        local org=line:getParent():convertToWorldSpace(cc.p(line:getPosition()))
--        local x_origin,y_origin=org.x,org.y
--        local parent=ob:getParent()
--        for i=1,length/density do
--            local frag=cc.Sprite:create("frag.png")
--            local scale=density/frag:getContentSize().width
--            local x,y;
--            x=x_origin+(length/density/2-i-1)*density*math.cos(angle/xishu)
--            y=y_origin+(length/density/2-i-1)*density*math.sin(angle/xishu)
--
--            frag:setPosition(x,y)
--            frag:setScale(scale)
--            local ph1_deltax=math.random(-50,50)*screen_scale
--            local ph1_deltay=math.random(-50,50)*screen_scale
--            local ph1_time=math.random(2,4)/10
--            local ph1_scale=math.random(2,4)/10
--
--            local ph1_ac_moveBy=cc.MoveBy:create(ph1_time,cc.p(ph1_deltax,ph1_deltay))
--            local ph1_ac_scale=cc.ScaleBy:create(ph1_time,ph1_scale,ph1_scale)
--            local moveBy=cc.Spawn:create(ph1_ac_moveBy,ph1_ac_scale)
--            moveBy=cc.EaseSineOut:create(moveBy)
--
--            local move=cc.MoveTo:create(0.5,cc.p(main_scene.mvp:getPosition()))
--            move=cc.EaseSineOut:create(move)
--            local ac=cc.Sequence:create(
--                moveBy,move,cc.CallFunc:create(function()frag:removeFromParent()end,{0}))
--            frag:runAction(ac)
--
--            main_scene:addChild(frag)
--
--        end
--        line:removeFromParent()
--        print("line")
--    end
--    return line
--end
--
--
--function bad_rect_create(dest)
--    local rect=cc.NVGDrawNode:create()
--    rect:drawRect(cc.rect(0,0,dest.x,dest.y),cc.c4f(1,1,1,1))
--    rect:setLineWidth(5*screen_scale)
--    rect.kind="ob_frame"
--    rect:setPhysicsBody(cc.PhysicsBody:createEdgeBox(
--        cc.size(dest.x,dest.y),cc.PhysicsMaterial(100,0,100),1,cc.p(dest.x/2,dest.y/2)))
--    rect:getPhysicsBody():setContactTestBitmask(0x1)
--    rect:setFillColor(cc.c4f(1,1,1,0))
--    return rect
--end
--
--
----dir 0:left 1:middle 2:center
--function bad_gap_set_create(color,dir)
--    local node=cc.Node:create()
--    local line_gap=100*ss
--    local line_delta=60*ss
--    for i=1,3 do
--        local gap=bad_gap_create(color)
--        gap:setPosition((dir-1)*line_delta*(i-2),line_gap*(i-2))
--        node:addChild(gap)
--    end
--    return node;
--end
--
--function bad_gap_create(color_set)
--    local color=color_set
--    local r=30*screen_scale
--    local line=cc.Node:create()
--    local gap=300*screen_scale
--    color=random_color()
--    local line_left=line_circle_create(90,r,color)
--    color=random_color()
--    local line_right=line_circle_create(0,r,color)
--    line_left:setPosition(-(r+gap/2),0)
--    line_right:setPosition((r+gap/2),0)
--    line:addChild(line_left)
--    line:addChild(line_right)
--    return line;
--end
--
--
--function bad_delta_create(color_set,dir)
--    local color=color_set
--    local r=30*screen_scale
--    local line=cc.Node:create()
--    local gap=300*screen_scale
--    local delta=0*screen_scale
--    color=random_color()
--    local line_left=down_line_circle_create(90,r,color)
--    color=random_color()
--    local line_right=down_line_circle_create(0,r,color)
--    line_left:setPosition(delta,(gap*(dir-0.5)*2))
--    line_right:setPosition(-delta,0)
--    line:addChild(line_left)
--    line:addChild(line_right)
--    return line;
--end

function circle_body(center,r)
    local body= cc.PhysicsBody:createCircle(r,ob_m,center):getFirstShape()
    return body
end


--[[--
create ob circle
@param dir little: 1 up 2 down
]]


--[[--
create ob
@param empty 0:empty 1 2 3
]]
local frag_size=10*ss

function frag_create()
    local frag=cc.Sprite:create("frag.png")
    local scale=frag_size/frag:getContentSize().width
    local x,y;
    frag:setScale(scale)

    local ph1_deltax=math.random(-50,50)*screen_scale
    local ph1_deltay=math.random(-50,50)*screen_scale
    local ph1_time=math.random(2,4)/10
    local ph1_scale=math.random(2,4)/10

    local ph1_ac_moveBy=cc.MoveBy:create(ph1_time,cc.p(ph1_deltax,ph1_deltay))
    local ph1_ac_scale=cc.ScaleBy:create(ph1_time,ph1_scale,ph1_scale)
    local moveBy=cc.Spawn:create(ph1_ac_moveBy,ph1_ac_scale)
    moveBy=cc.EaseSineOut:create(moveBy)

    local ac=cc.Sequence:create(
        moveBy,cc.CallFunc:create(function()frag:removeFromParent()end,{0}))
    frag:runAction(ac)
    main_scene:addChild(frag)
    return frag
end
function frag_rect_create(rect)
    function frag(xp,yp)
        local frag=frag_create()
        x=rect.x+xp*frag_size
        y=rect.y+yp*frag_size

        frag:setPosition(x,y)
    end
    for i=1,rect.width/frag_size do
        for j in pairs({1,rect.height/frag_size}) do
            frag(i,j)
        end
    end
    for i in pairs({1,rect.width/frag_size}) do
        for j =1,rect.height/frag_size do
            frag(i,j)
        end
    end
end
function frag_circle_create(center,r)
    local num=2*math.pi*r/frag_size
    for i=1,num do
        local angle=360/num*i/xishu
        local frag=frag_create()
        x=center.x+r*math.cos(angle)
        y=center.y+r*math.sin(angle)
        frag:setPosition(x,y)
    end
end

function down_circle_with_line_set_create(dir,height,speed)
    local node=cc.Node:create()
    local lenth=sx/4
    local order=dir-1
    local gap=200*ss
    local single=down_circle_with_line_create(lenth,cc.c4f(1,1,1,1),80,height/speed)
    single:setPosition(0,(1-order)*gap)
    local double={}
    for i=1,2 do
        local xishu=(i-1.5)*2
        double[i]=down_circle_with_line_create(lenth,cc.c4f(1,1,1,1),80,height/speed+gap/speed)
        double[i]:setPosition(sx/4*xishu,order*gap)
        node:addChild(double[i])

    end
    node:addChild(single)
    node:addChild(remover())
    return node
end

function down_circle_with_line_create(length,color,threshold,delay)
    local node=cc.Node:create()
    node:setAnchorPoint(0.5,0.5)
    node.kind="ob_frame"
    node.name="circle_with_line"
    node.length=length
    local r=20*ss
    local line_width=14*ss
    node.left=math.random(1,100)>threshold
    node.right=math.random(1,100)>threshold
    node.middle=math.random(1,100)>threshold
    function node:remove()

        org=self:getParent():convertToWorldSpace(cc.p(node:getPosition()))
        self:removeFromParent()
        print("remove")
        frag_rect_create(cc.rect(org.x-length/2,org.y-line_width/2,length,line_width))
        frag_circle_create(cc.p(org.x-length/2,org.y),r)
        frag_circle_create(cc.p(org.x+length/2,org.y),r)
    end

    function shape(color)
        local scale_time=1
        local node1=cc.Node:create()
        local line=cc.NVGDrawNode:create()
        local shorten=line_width*1.3
        local empty_width=line_width/3
        if node.middle then
            local up=cc.NVGDrawNode:create()
            up:drawLine(cc.p(-length/2+shorten,line_width/2),cc.p(length/2-shorten,line_width/2),color)
            up:setLineWidth(empty_width)

            local down=cc.NVGDrawNode:create()
            down:drawLine(cc.p(-length/2+shorten,-line_width/2),cc.p(length/2-shorten,-line_width/2),color)
            down:setLineWidth(empty_width)
            line:addChild(up)
            line:addChild(down)
        else
            line:drawLine(cc.p(-length/2+shorten,0),cc.p(length/2-shorten,0),color)
            line:setLineWidth(line_width)
        end
        line:setScale(0,1)
        local ac=cc.ScaleTo:create(scale_time,1,1)
        ac=cc.EaseSineOut:create(ac)
        ac=cc.Sequence:create(cc.DelayTime:create(delay),ac)
        line:runAction(ac)


        local mask_node=cc.Node:create()
        node1:addChild(line)
        local circle={}


        if node.left then
            circle[1]=cc.NVGDrawNode:create()
            circle[1]:drawCircle(cc.p(-1*length/2,0),r-empty_width/4,color);
            circle[1]:setLineWidth(empty_width);

        elseif node.right then
            circle[2]=cc.NVGDrawNode:create()
            circle[2]:drawCircle(cc.p(1*length/2,0),r-empty_width/4,color)
            circle[2]:setLineWidth(empty_width)
        end

        if not circle[1] then
            circle[1]=cc.NVGDrawNode:create()
            circle[1]:drawSolidCircle(cc.p(-1*length/2,0),r,color)
        end

        if not circle[2] then
            circle[2]=cc.NVGDrawNode:create()
            circle[2]:drawSolidCircle(cc.p(1*length/2,0),r,color)
        end
        for i=1,2 do
            circle[i]:setScale(0)
            local ac=cc.ScaleTo:create(scale_time,1,1)
            ac=cc.EaseBackOut:create(ac)
            ac=cc.Sequence:create(cc.DelayTime:create(delay),ac)
            circle[i]:runAction(ac)
        end

        node1:addChild(circle[1],2)
        node1:addChild(circle[2],2)

        return node1
    end
    local shadow=shape(shadow_color)
    shadow:setPosition(shadow_delta/2,-shadow_delta)
    node:addChild(shadow)
    node:addChild(shape(color))



    node:setPhysicsBody(cc.PhysicsBody:createBox(cc.size(length-2*r,line_width),ob_m))

    node:getPhysicsBody():addShape(circle_body(cc.p(-length/2,0),r+line_width/2))
    node:getPhysicsBody():addShape(circle_body(cc.p(length/2,0),r+line_width/2))
    node:getPhysicsBody():setContactTestBitmask(0x1)
    node:getPhysicsBody():setGravityEnable(false)

    return node
end

--[[--
create ob circle
@param dir little: 1:left down 2:right down 3:left up 4:right up
]]
function down_circle_set_create(dir)
    local node=cc.Node:create()
    local color=random_color()
    local little=down_circle_create(0,color)
    local large=down_circle_create(1,color)
    local little_x;
    local little_y;
    local large_x;
    local large_y;
    local gap=sx*3/7

    if dir%2>0 then
        little_x=-sx/4
        large_x=sx/8
    else
        little_x=sx/4
        large_x=-sx/8
    end

    if dir < 3 then
        little_y=0
        large_y=gap
    else
        little_y=gap
        large_y=0
    end
    little:setPosition(little_x,little_y)
    large:setPosition(large_x,large_y)


    node:addChild(little)
    node:addChild(large)
    node:addChild(remover())
    return node
end
--[[--
create ob circle
@param size int 0:little 1:middle 2:large
@param color cc.c4f
]]
function down_circle_create(size,color)
    local line_width=10
    local circle=cc.NVGDrawNode:create()
    local shadow=cc.NVGDrawNode:create()
    local r=(size*1+1)*ss*50
    circle:setAnchorPoint(0.5,0.5)
    circle.kind="ob_frame"
    circle:drawCircle(cc.p(0,0),r,color)
    circle:setLineWidth(line_width)
    --shadow:drawSolidCircle(cc.p(0,0),r,cc.c4f(0,0,0,0.5))
    shadow:drawCircle(cc.p(0,0),r,cc.c4f(0,0,0,0.5))
    shadow:setLineWidth(line_width)

    shadow:setPosition(shadow_delta/2,-shadow_delta)
    circle:setPhysicsBody(cc.PhysicsBody:createCircle(r+line_width/2,ob_m,cc.p(0,0)))
    circle:getPhysicsBody():setContactTestBitmask(0x1)
    circle:getPhysicsBody():setGravityEnable(false)
    circle:addChild(shadow,-1)
    return circle
end

function down_line_circle_create(angle,r,color)
    local line_circle=cc.Node:create()
    line_circle:setAnchorPoint(cc.p(0.5,0.5))
    line_circle.kind="ob_frame"

    local circle=cc.NVGDrawNode:create()
    circle:drawSolidCircle(cc.p(0,0),r,color)

    local line=cc.NVGDrawNode:create()
    if angle==0 then
        line:drawRect(cc.p(0,-r),cc.p(screen_x,r),color)

        line_circle:setPhysicsBody(cc.PhysicsBody:createCircle(r,ob_m,cc.p(0,0)))
        local rect_body=cc.PhysicsBody:createBox(cc.size(screen_x,2*r),ob_m,cc.p(screen_x/2,0)):getFirstShape()
        line_circle:getPhysicsBody():addShape(rect_body)
    else
        line:drawRect(cc.p(0,-r),cc.p(-screen_x,r),color)
        line_circle:setPhysicsBody(cc.PhysicsBody:createCircle(r,ob_m,cc.p(0,0)))
        local rect_body=cc.PhysicsBody:createBox(cc.size(screen_x,2*r),ob_m,cc.p(-screen_x/2,0)):getFirstShape()
        line_circle:getPhysicsBody():addShape(rect_body)
    end
    line_circle:getPhysicsBody():setGravityEnable(false)
    line:setFill(true)
    line:setFillColor(color)

    line_circle:addChild(circle)
    line_circle:addChild(line)

    line_circle:getPhysicsBody():setContactTestBitmask(0x1)
    --line_circle:setRotation(angle)
    return line_circle
end
