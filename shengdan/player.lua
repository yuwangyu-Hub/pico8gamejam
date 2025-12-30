function playerstate()
    local switchstate={
        idle=function()
            debug = "idle"
            
            p.spdx=0
            if p.dire!=0 then
                p.state=p.allstate.run
            end

            if p.is_shoot then
                p.state=p.allstate.shoot
            end
            if p.is_trans then
                
                p.state=p.allstate.trans
            end
        end,
        run=function()
            debug = "run"
            if p.dire==0 then
                p.state=p.allstate.idle
            else
                p.spdx=dirx[p.dire]*p.run_spd
            end
            if p.is_shoot then
                p.state=p.allstate.shoot
            end
        end,
        shoot=function()
            debug = "shoot"
            p.shoot_t+=1
            p.spdx=0
            if not p.isaddbullet then
                addbullet(p)
                p.isaddbullet=true
            end

            if p.shoot_t>=20 then
                p.is_shoot=false
                p.isaddbullet=false
                p.shoot_t=0
                p.state=p.allstate.idle
            end
        end,
        trans=function()
            debug = "trans"
            p.is_trans=false
            p.can_trans=true
            --检测范围内的礼物，然后转换为搬运礼物组
            if p.dire==1 then
                p.spdx= -p.trans_spd
            elseif p.dire==5 then
               p.spdx= p.trans_spd
            else
                p.spdx=0
            end
            --修复精灵翻转
            if p.dire!=0 then
                p.last_dire=p.dire
            end

            if p.isgitfsdown then
                p.state=p.allstate.idle
                p.isgitfsdown=false
                giftpackage.count+=#gifts_trans
                gifts_trans={}
            end
            
        end,
    }
    switchstate[p.state]()
end
--检测玩家范围内地面上的礼物
function check_trans_gifts_ground(_p)
    for g in all(gifts_ground) do
        if abs((_p.x+3)-(g.x+2))<=10 then --检测到范围内有礼物
            add(gifts_trans,g)
            del(gifts_ground,g)
            return true
        end
    end
    -- 遍历完所有礼物都没有找到匹配项时才返回false
    return false
end
--靠近礼物袋
function check_close_giftpackage(_p)
    if abs((_p.x+5)-(giftpackage.x+7))<=8 then --检测到范围内有礼物
        return true
    end
end
--字符串转换为图形函数
function rle1(s,x0,y,tr)
	local x,mw=x0,x0+ord(s,2)-96
	for i=5,#s,2do
	 	local col,len=ord(s,i)-96,ord(s,i+1)-96
	 	if(col!=tr) line(x,y,x+len-1,y,col)
	 	x+=len if(x>mw) x=x0 y+=1
	end
end

--闪烁工具，返回闪烁的颜色动画
function blink() 
	local blink_anim={5,5,5,5,5,5,5,5,6,6,7,7,6,6,5,5}
	return blink_anim[blinkt%#blink_anim] --blinkt:闪烁计时器
end
