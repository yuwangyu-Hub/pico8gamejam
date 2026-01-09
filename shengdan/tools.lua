
--主角方向-翻转
function flip_P(_dire)
    local dire=_dire
    if dire==1 then
        return true
    elseif dire==5 then
        return false
    end
end
function flip_qie(_dire)
    local dire=_dire
    if dire==1 then
        return false
    elseif dire==5 then
        return true
    end
end
--添加子弹
function addbullet(_sb)
    b={x=_sb.x+3,y=_sb.y,spd=2,spr=16}--这里的x和y应该是只针对spr的绘制位置

    add(bullets,b)
end
--礼物绘制
function giftsdraw()
    for g in all(gifts) do
        local balloon={x=g.x-5,y=g.y-g.long,w=10,h=14}
        --礼物本体
        spr(g.spr,g.x,g.y)
        if g.mode=="fall" then --掉落
            local expspr={80,82,84,86,88,90}
            g.expspr_t+=1
            local frame=flr(g.expspr_t/2)+1
            pal(10,g.c)
            --气球爆炸动画
            if frame<#expspr then
                spr(expspr[frame],g.x-5,g.y-g.long,2,2)
               
            end
            pal()
        else
            --线
            line(g.x+2,g.y,g.x+2,g.y-g.long+10,7)
            --气球
            pal(10,g.c)
            spr(80,g.x-5,g.y-g.long,2,2)
            pal()
        end
    end
end
function giftsmove(_g)
    if _g.mode=="down" then
        _g.y+=_g.spd
        if _g.y>=60 then
            _g.mode="up"
        end
    elseif _g.mode=="up" then
        _g.y-=_g.spd
        if _g.y<=20 then
            _g.mode="down"
        end
    elseif _g.mode=="fall" then
        _g.y+=3
    end
   
end

--范围设置
function inbounds(_s)
    if _s.x<0 then
        _s.x=0
    elseif _s.x>120 then
        _s.x=120
    end
end
--击落检测
function shootdown(b,g)--bullet, gift
    if g.mode=="fall" then
        return false
    end
    local qiqiu={
        x=g.x-1,
        y=g.y+3-g.long,
        w=6,
        h=6}
    local b={
        x=b.x+1,
        y=b.y,
        w=1,
        h=5}
    rect(qiqiu.x,qiqiu.y,qiqiu.x+qiqiu.w,qiqiu.y+qiqiu.h,8)
    --检测碰撞
    if not (qiqiu.x> b.x + b.w or
        qiqiu.x + qiqiu.w < b.x or
        qiqiu.y > b.y + b.h or
        qiqiu.y + qiqiu.h < b.y) then
        return true
    else
        return false  
    end
end

function collide(ax,ay,aw,ah,bx,by,bw,bh)
    if ax+aw>bx and ax<bx+bw then
        return true
    else
        return false
    end
end