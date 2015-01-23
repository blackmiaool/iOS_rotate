
require("miaoconfig")

function circle_body(center,r)
    local body= cc.PhysicsBody:createCircle(r,ob_m,center):getFirstShape()
    return body
end
local empty_width=5*ss

--[[--
create ob circle
@param dir little: 1 up 2 down
]]


--[[--
create ob
@param empty 0:empty 1 2 3
]]
local frag_size=20*ss

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
    main_scene.ob_layer:addChild(frag)
    return frag
end

function frag_rect_create(rect,bias,angle)
    function frag(xp,yp)
        --print(xp,yp)
        local frag=frag_create()
        local x=rect.x+xp*frag_size
        local y=rect.y+yp*frag_size

        frag:setPosition(x-main_scene.ob_layer:getPositionX()
            ,y-main_scene.ob_layer:getPositionY())
    end
    local bx=bias.x*math.cos(angle)*ss
    local by=bias.y*math.sin(angle)*ss
    local function changle(x0,y0)
        x0=x0-rect.width/frag_size/2;
        y0=y0-rect.height/frag_size/2;

        x0=x0+bias.x/frag_size
        y0=y0+bias.y/frag_size
        local x1,y1;
        local ra=angle/xishu
        local cos=math.cos(-ra)
        local sin=math.sin(-ra)
        x1=x0*cos-y0*sin
        y1=x0*sin+y0*cos
   
        return x1,y1
--        return x0,y0
    end
    for i=1,rect.width/frag_size do
        for j in pairs({1,rect.height/frag_size}) do
            frag(changle(i,j))
        end
    end
    for i in pairs({1,rect.width/frag_size}) do
        for j =1,rect.height/frag_size do
            frag(changle(i,j))
        end
    end
end

local function frag_circle_create(center,r)
    local num=2*math.pi*r/frag_size
    for i=1,num do
        local angle=360/num*i/xishu
        local frag=frag_create()
        local x=center.x+r*math.cos(angle)
        local y=center.y+r*math.sin(angle)
        frag:setPosition(x,y)
    end
end

function down_circle_with_line_set_create(dir,height,speed)
    local node=cc.Node:create()
    local length=sx/4
    local order=dir-1
    local gap=200*ss
    local single=down_circle_with_line_create(length,80,height/speed)
    single:setPosition(0,(1-order)*gap)
    local double={}
    for i=1,2 do
        local xishu=(i-1.5)*2
        double[i]=down_circle_with_line_create(length,80,height/speed+gap/speed,speed)
        double[i]:setPosition(sx/4*xishu,order*gap)
        node:addChild(double[i])

    end
    node:addChild(single)
    --   node:addChild(remover())
    return node
end

local my_white=cc.c4f(1,1,1,1)

function element_rect_create(empty,width,height,color,ac,mask,bias,line_width)

    local node=cc.Node:create()
  if not bias then
                bias=cc.p(0,0)
            end
    node.color=color
    node.empty=empty
    function node:remove()
        local parent=self:getParent()
        local done=parent.done
        if not done then
            parent.done=true
            local children=parent:getChildren()
            for i,j in pairs(children) do
                j:remove()
            end
        else
            print(node.color.r)
            local org=parent:convertToWorldSpace(cc.p(node:getPosition()))
            
            if node.color==shadow_color then
                node:removeFromParent()
                return;
            end
            
            frag_rect_create(cc.rect(org.x,org.y,width,height),bias,node:getRotation())
            node:removeFromParent()
        end
              
    end
    function node:handle(ob,shield)
        if node.empty then
            return true
        else
            return false
        end
    end
    function shape(color)
        local node=cc.DrawNode:create()
        if empty then
            -- node:drawRect(cc.p(-width/2,-height/2),
            --     cc.p(width/2,height/2),
            --     color,100)
            --node:setLineWidth(100)
            local delta=empty_width/2

            node:drawPolygon({
                cc.p(bias.x-width/2+delta,bias.y-height/2+delta),
                cc.p(bias.x+width/2-delta,bias.y-height/2+delta),
                cc.p(bias.x+width/2-delta,bias.y+height/2-delta),
                cc.p(bias.x-width/2+delta,bias.y+height/2-delta)},
                4,cc.c4f(0,0,0,0),empty_width,color);
     
        else
            node:drawSolidRect(
                cc.p(bias.x-width/2,bias.y-height/2),
                cc.p(bias.x+width/2,bias.y+height/2),
                color)
        end
        return node
    end


    local shape_this=shape(color)
    if color==shadow_color then
        node:addChild(shape_this)         
        return node
    else            
        node:addChild(shape_this) 
    end
    node:setAnchorPoint(0.5,0.5)
    node:setPhysicsBody(cc.PhysicsBody:createBox(cc.size(width,height),ob_m,bias))
    node:getPhysicsBody():setContactTestBitmask(mask)
    node:getPhysicsBody():setCategoryBitmask(mask)
    node:getPhysicsBody():setGravityEnable(false)
    node:getPhysicsBody():setCollisionBitmask(mask)
    node.kind="ob_frame"
    if ac then
        node:runAction(ac)
    end
    return node;
end
function down_circle_with_box_create_pre(threshold)
    local core=math.random(0,100)>threshold
    local line=math.random(0,100)>threshold
    local dir={-1,1}
    local node=down_circle_with_box_create(
        core,
        line,
        140/(sy/main_scene.ob_layer.speed/2),math.random(0,360),
        dir[math.random(1,2)]
        )
    node:setPosition(sx/4+sx/4*math.random(0,2),sy*1.1-main_scene.ob_layer:getPositionY())
    return node

end
function  down_circle_with_box_create(core,line,speed,angle,dir)
    local node=cc.Node:create()
    
    local rect_a=sx/10
    local rect_a_half=rect_a/2


--    local rect=rect_shape(rect_a/2,cc.c4f(1,1,1,1))
    local rect=element_rect_create(false,rect_a,rect_a,my_white,nil,0x01)
    local rect_shadow=element_rect_create(false,rect_a,rect_a,shadow_color)
    local line_len=70
    local line=element_rect_create(line,rect_a*4,rect_a/3,my_white,nil,0x02,cc.p(line_len,0))
    local line_shadow=element_rect_create(line,rect_a*4,rect_a/3,shadow_color,nil,0x02,cc.p(line_len,0))

    rect_shadow:setPosition(shadow_delta/2,-shadow_delta)
    --node:addChild(rect_shadow)
    node.rect=rect;
        node:addChild(rect_shadow)
    node:addChild(line_shadow)
    node:addChild(rect)
    line:setPosition(0,0)
    line_shadow:setPosition(shadow_delta/2,-shadow_delta)
    node:addChild(line)
    local time_x=90/speed
    local rotate_ac=cc.RotateBy:create(time_x,speed*dir*time_x)
    --rotate_ac=cc.RepeatForever:create(rotate_ac)

    local scale=cc.ScaleTo:create(time_x,1)
    --scale=cc.RepeatForever:create(scale)
    --scale=cc.Spawn:create(scale,rotate_ac)
    local ac=cc.Sequence:create(
        cc.Spawn:create(
            rotate_ac,
            scale
            ),
        cc.Repeat:create(rotate_ac,10)
        )
    for i,j in pairs{line,line_shadow} do
        j:setRotation(angle)
        j:setScale(0.1,1)
        j:runAction(ac:clone())
    end
--    line:runAction(rotate_ac)
--    line_shadow:runAction(rotate_ac:clone())

    return node;
end 

function three_line_set_create(dir,height,speed)
    local node=cc.Node:create()
    local length=sx/4
    local gap=sx/2*ss
    local line={}
    local r=20*ss
    function three_line_create(length,threshold,delay,dir,speed)
        local node=cc.Node:create()
        node:setAnchorPoint(0.5,0.5)
        node.kind="ob_frame"
        node.name="three_line"
        node.length=length
        print(speed)
        local move_time=1*100/speed
        local r=20*ss
        local line_width=14*ss
        node.ball=math.random(1,100)>threshold
        function node:handle(ob,shield)
            print(ob.x,shield.x)
            local delta=ob.x-shield.x
            if delta<-sx/3 then
                if node.ball and dir=="left" then
                    return true        
                end
            elseif delta>sx/3 then
                if node.ball and dir=="right" then
                    return true        
                end

            end
            return false
        end
        function node:remove()
            local org=self:getParent():convertToWorldSpace(cc.p(node:getPosition()))
            self:removeFromParent()
            --print("remove")
            if dir=="left" then
                frag_rect_create(cc.rect(org.x,org.y,sx/2,r*2))
            else
                frag_rect_create(cc.rect(org.x-sx/2,org.y,sx/2,r*2))
            end
            return true
        end
        function node:shape(color)
            local scale_time=1
            local node1=cc.Node:create()
            local line;

            if node.ball then
                if color==shadow_color then
                    line=cc.Sprite:create("line_circle_frame_shadow.png")
                else
                    line=cc.Sprite:create("line_circle_frame.png")
                end
            else
                if color==shadow_color then
                    line=cc.Sprite:create("line_circle_shadow.png")
                else
                    line=cc.Sprite:create("line_circle.png")
                end
            end

            if dir=="left" then
                line:setPosition(-sx/2/ss,0)
                local ac=cc.MoveTo:create(move_time,cc.p(0,0))
                ac=cc.Sequence:create(cc.DelayTime:create(delay),ac)
                line:runAction(ac)
            else
                line:setPosition(-sx/2/ss,0)
                local ac=cc.MoveTo:create(move_time,cc.p(0,0))
                ac=cc.Sequence:create(cc.DelayTime:create(delay),ac)
                line:runAction(ac)
            end

            node1:addChild(line)
            node1:setScale(ss)
            return node1
        end   
        local shadow=node:shape(shadow_color)
        if dir=="left" then
            shadow:setPosition(shadow_delta/2,-shadow_delta)
        else
            shadow:setPosition(-shadow_delta/2,-shadow_delta)
        end

        node:addChild(shadow)
        node:addChild(node:shape(cc.c4f(1,1,1,1)),1)
        --print(length*6,r)
        node:setPhysicsBody(cc.PhysicsBody:createBox(cc.size(sx+2*r,r*2),ob_m))



        node:getPhysicsBody():setContactTestBitmask(0x1)
        node:getPhysicsBody():setGravityEnable(false)
        return node
    end
    for i=1,3 do
        line[i]=three_line_create(length,50,(i-1)*gap/speed+height/speed,dir,speed)
        local length=cc.Sprite:create("line_circle.png"):getContentSize().width*ss
        if dir=="left" then
            line[i]:setPosition(-sx/2,(i-1)*gap)
        else

            line[i]:setScale(-1,1)
            line[i]:setPosition(sx*1/2,(i-1)*gap)
        end
        --line[i]:setPosition(r-length/2,(i-1)*gap)

        --print(sx*3/4+r-length/2)
        node:addChild(line[i])
    end
    return node

end






function down_circle_with_line_create(length,threshold,delay,speed)
    local node=cc.Node:create()
    node:setAnchorPoint(0.5,0.5)
    node.kind="ob_frame"
    node.name="circle_with_line"
    node.length=length
    local r=20*ss
    local color=cc.c4f(1,1,1,1)
    local line_width=14*ss
    node.left1=math.random(1,100)>threshold
    node.right1=math.random(1,100)>threshold
    node.middle1=math.random(1,100)>threshold
    function node:handle(ob,shield)
        --print(node.left1,node.middle1,node.right1)
        local dis_x=shield.x-ob.x
        --print(shield.x,ob.x)
        if math.abs(dis_x)<self.length/5*1 then
            --print("middle")
            if node.middle1 then
                return true
            else
                return false
            end
        elseif dis_x<=-self.length/5*1 then
            --print("left")
            if node.left1 then
                return true
            else
                return false
            end
        elseif dis_x>=self.length/5*1 then
            --print("right")
            if self.right1 then
                return true
            else
                return false
            end
        else
            print("error")
        end
    end






    function node:remove()

        local org=self:getParent():convertToWorldSpace(cc.p(node:getPosition()))
        self:removeFromParent()
        --print("remove")
        frag_rect_create(cc.rect(org.x-length/2,org.y-line_width/2,length,line_width))
        frag_circle_create(cc.p(org.x-length/2,org.y),r)
        frag_circle_create(cc.p(org.x+length/2,org.y),r)
    end

    function node:shape(color)
        local scale_time=1
        local node1=cc.Node:create()
        local line=cc.NVGDrawNode:create()
        local shorten=line_width*1.3
        local empty_width=line_width/3
        if node.middle1 then
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


        if node.left1 then
            --            circle[1]=cc.NVGDrawNode:create()    
            --            circle[1]:drawCircle(cc.p(-1*length/2,0),r-empty_width/4,color);
            --            circle[1]:setLineWidth(empty_width);
            if(color~=shadow_color) then
                circle[1]=cc.Sprite:create("circle_frame.png")

            else
                circle[1]=cc.Sprite:create("circle_frame_shadow.png")

            end

            circle[1]:setPosition(cc.p(0,0))

        end
        if node.right1 then
            if(color~=shadow_color) then
                circle[2]=cc.Sprite:create("circle_frame.png")

            else
                circle[2]=cc.Sprite:create("circle_frame_shadow.png")

            end

            circle[2]:setPosition(cc.p(0,0))
            --            circle[2]=cc.NVGDrawNode:create()
            --            circle[2]:drawCircle(cc.p(length/2,0),r-empty_width/4,color)
            --            circle[2]:setLineWidth(empty_width)
        end

        if not circle[1] then
            if(color~=shadow_color) then
                circle[1]=cc.Sprite:create("circle.png")

            else
                circle[1]=cc.Sprite:create("circle_shadow.png")

            end

            circle[1]:setPosition(cc.p(0,0))
        end

        if not circle[2] then
            if(color~=shadow_color) then
                circle[2]=cc.Sprite:create("circle.png")

            else
                circle[2]=cc.Sprite:create("circle_shadow.png")

            end

            circle[2]:setPosition(cc.p(0,0))
        end
        for i=1,2 do
            local xishu=(i-1.5)*2
            --circle[i]:setScale(0)
            local ac=cc.MoveTo:create(scale_time,cc.p(xishu*length/2,0))
            ac=cc.EaseBackOut:create(ac)
            ac=cc.Sequence:create(cc.DelayTime:create(delay),ac)
            circle[i]:setScale(ss)
            circle[i]:runAction(ac)

        end

        node1:addChild(circle[1],2)
        node1:addChild(circle[2],2)

        return node1
    end
    local shadow=node:shape(shadow_color)
    shadow:setPosition(shadow_delta/2,-shadow_delta)
    node:addChild(shadow)
    node:addChild(node:shape(color))



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
