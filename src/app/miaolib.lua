require "config"
require "plist"
tens={1,10,100,1000,10000,100000,1000000,10000000}
xishu=180/math.pi
function table.isIn(table,element)
    for i,j in pairs(table) do
        if j==element then
            return true
        end
    end
    return false
end
function table.isContainTable(table,element)
    for i,j in pairs(table) do
        local isIn=true
        for k,l in pairs(element) do
            print(l)
            if j[k]~=element[k] then
                print(k)
                print("error")
                isIn=false
                break
            end
        end
        if isIn then
            return true
        end
    end
    return false
end
function gesture_idy(a,b)
    local deltax=b.x-a.x
    local deltay=b.y-a.y
    --0:up 1:down 2:left 3:right
    local retval;
    if x==0 then
        x=0.1;
    end
    local k=deltay/deltax
    local distance=math.sqrt(math.ldexp(deltax,2)+math.ldexp(deltay,2))

    local angle=math.atan2(deltay,deltax)*57.3

    if distance<10 then
        retval=nil
    else 
        if(angle<-135 or angle>135) then
            retval=2
        elseif angle>45 and angle<=135 then 
            retval=0
        elseif angle<=45 and angle >=-45 then
            retval=3
        else retval=1
        end
    end
    return retval
end

-- 安全地设置锚点，用于锚点改变后node对象即便设置了scale缩放，其位置也不发生变化
function setSafeAnchor(node, anchorX, anchorY)

    local diffX = (anchorX-node:getAnchorPoint().x) * node:getContentSize().width  * (node:getScaleX() )
    local diffY = (anchorY-node:getAnchorPoint().y) * node:getContentSize().height * (node:getScaleY() )


    node:setAnchorPoint(anchorX, anchorY)
    node:setPositionX(node:getPositionX() +diffX)
    node:setPositionY(node:getPositionY() + diffY)
end


function cycle_create()
    local cycle={}
    local rear=1
    local head=1
    function cycle:put(data)
        table.insert(cycle,#cycle+1,data)      
    end
    function cycle:get()
        local retval=cycle[1]
        table.remove(cycle,1)
        return retval            
    end
    return cycle
end

function performWithDelay(callback, delay)
    local handle
    handle = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(function()
        CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(handle)
        handle = nil
        callback();
    end , delay , false)
end

function math.toInt(num)
    local zheng,xiao=math.modf(num)

    if math.abs(xiao)>0.5 then
        if num>0 then
            return zheng+1
        else
            return zheng-1
        end
    else
        return zheng
    end

end


function toBool(data)
    if (not data) or data<1 then
        return false
    else
        return true
    end
end

function getBit(num,pos)    
    return num/tens[pos]%10
end

function getBitBool(num,pos)
    return toBool(getBit(num,pos))
end

function table.copy(data)
    local retval={};
    for i,j in pairs(data) do
        retval[i]=j
    end
    return retval
end
function table.cmp(data1,data2)
    
    for i,j in pairs(data1) do
        if data2[i]~=j then
            return false
        end
    end
    return true
end
function r2xy(r,p,x0,y0)
    
    local x,y;
    p=p/xishu
    if p<180 then
        x=math.cos(p)*r
        y=math.sin(p)*r
    else
        
        x=-math.cos(p)*r
        y=math.sin(p)*r
    end
    if x0 and y0 then
        x=x+x0
        y=y+y0
    end
    return x,y    
end

