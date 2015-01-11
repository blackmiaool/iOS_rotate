require("miaolib")

function loop_create(width,a)
    
end
function loop_in(x,y,other)
    local R,r=other[1]/2,other[2]
    local sum=x*x+y*y
    if sum<R*R and sum>r*r then
        return true
    end
    return false 
end

function circle_in(x,y,other)
    local r=other[1]/2
    if x*x+y*y<r*r then
        return true
    end
    return false 
end

function ob_circle_init(ob,a,num,color,judge_func,...)
    ob.kind="ob"   
    local width=...
    local other={...}
    local frag_num=num
    --print(ob:getPhysicsBody():getMass())
    ob:getPhysicsBody():setGravityEnable(false)
    ob:getPhysicsBody():setContactTestBitmask(0x3)
    
    local ac=cc.CallFunc:create(
        function(ob_this)
            local x,y=ob_this:getPosition();
            if y<-1000 then 
                ob_this:removeFromParent() 
            end 
        end,{ob})
    ac=cc.Sequence:create(cc.DelayTime:create(1),ac)
    ac=cc.RepeatForever:create(ac)
    ob:runAction(ac)
    function ob:remove()
        local v=100
        local org=ob:getParent():convertToWorldSpace(cc.p(ob:getPosition()))
        local x_origin,y_origin=org.x,org.y
        local parent=ob:getParent()
        for i=1,frag_num do
            local frag=cc.Sprite:create("frag.png")
            local scale=a/frag:getContentSize().width
            local x,y;
            
            repeat
                x=math.random(-width/2,width/2)
                y=math.random(-width/2,width/2)
            until judge_func(x,y,other)
            x=x+x_origin
            y=y+y_origin
            frag:setPosition(x,y)

--            frag:setPhysicsBody(cc.PhysicsBody:createBox({width=a,height=a},cc.PhysicsMaterial(-10,1,0)))
--
--            frag:getPhysicsBody():setVelocity(cc.p(math.random(-v,v),math.random(-v,v)))
--            frag:getPhysicsBody():setGravityEnable(false)
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
        ob:removeFromParent()
    end
    return ob
end

function ob_circle_create(width,a,color)

    --gl.hint(gl.LINE_SMOOTH_HINT, gl.NICEST);
--    local ob=cc.DrawNode:create()
--    ob:drawSolidCircle(cc.p(0,0),width/2,100,1000,color)
    local ob=cc.NVGDrawNode:create()
    
    
    ob:drawSolidCircle(cc.p(0,0),width/2,color)
    --ob:drawRect(cc.rect(100,30,10,10),color)
    --ob:drawSolidCircle(cc.p(100,0),width/2,color)
    
    ob:setAnchorPoint(cc.p(0.5,0.5))
    ob:setPhysicsBody(cc.PhysicsBody:createCircle(width/2,cc.PhysicsMaterial(10000,1,0)))
    local num=a
    local a=math.sqrt(width*width/4*math.pi/a)
    ob_circle_init(ob,a,num,color,circle_in,width)
    return ob
end
function ob_loop_create(R,width,a,color) 
    r=R-width 
    local ob=cc.NVGDrawNode:create()
    ob:drawCircle(cc.p(0,0),R,color)
    ob:setLineWidth(3)
--    local ob=cc.NVGDrawNode:create()
--    ob:drawSolidCircle(cc.p(0,0),R,color)
--    --local ob=cc.DrawNode:create()
    
--    --ob:drawSolidCircle(cc.p(0,0),R,100,1000,color)
--    ob:setAnchorPoint(cc.p(0.5,0.5))
--    local mk=cc.NVGDrawNode:create()
--    mk:drawSolidCircle(cc.p(0,0),r,cc.c4f(0,0,0,1))
--    --mk:drawSolidCircle(cc.p(0,0),r,100,1000,cc.c4f(0,0,0,1))
--    local mask=cc.ClippingNode:create(mk)
--    mask:setInverted(false)
--    --mask:setAlphaThreshold(0)
--    mask:setInverted(true)
--    mask:addChild(ob)
--    ob=mask
    ob:setAnchorPoint(cc.p(0.5,0.5))
    ob:setPhysicsBody(cc.PhysicsBody:createCircle(R,cc.PhysicsMaterial(10000,1,0)))
    local num=a
    local a=math.sqrt((R*R-r*r)*math.pi/a)
    ob_circle_init(ob,a,num,color,loop_in,R*2,r)
    return ob
end
function ob_loop_with_circles(R,width,a,num,w,loop_color,core_color_table)
    local ob=cc.Node:create()
    local loop=ob_loop_create(R,width,a,loop_color)
    ob:addChild(loop)
    local balls=cc.Node:create()
    for i=1,num do
        local circle=ob_circle_create(R/3,a,core_color_table[i])
        circle:setPosition(r2xy(R/2,360/num*i,0,0))
        balls:addChild(circle)
    end
    ob:addChild(balls)
    local rotate=cc.RotateBy:create(1,w)
    rotate=cc.Sequence:create(rotate,cc.CallFunc:create(
    function()
    local x,y=ob:getPosition()
        if y<-screen_y/2 then
            ob:removeFromParent()
            balls:removeFromParent()
            
        end 
    end
    ,{0}
    ))
    rotate=cc.RepeatForever:create(rotate)
    balls:runAction(rotate)
    return ob
end

