pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
--game manager
function _init()
	p={x=60,y=120,speed=2}
	bullets={}
	enemies={}
	explosions={}
	create_stars()
	score=0
	state=0
end

function _update60()
	if (state==0) update_game()
	if (state==1) update_gameover()
end

function _draw()
	if (state==0) draw_game()
	if (state==1) draw_gameover()
end

function update_game()
	update_player()
	update_bullets()
	update_stars()
	if #enemies==0 then
		spawn_enemies(2+flr(rnd(5)))
	end
	update_enemies()
	update_explosions()
end

function draw_game()
 cls()
 --stars
	for s in all(stars) do
		pset(s.x,s.y,s.col)
	end
 --vaisseau
	spr(1,p.x,p.y)
	--enemies
	for e in all(enemies) do
		spr(3,e.x,e.y)		
	end
	--bullets
	for b in all(bullets) do
		spr(2,b.x,b.y)
	end
	--explosions
	draw_explosions()
	--score
	print("score:"..score,2,2,7)
end

-->8
--bullets
function shoot()
	new_bullet={
		x=p.x,
		y=p.y,
		speed=4
	}
	add(bullets,new_bullet)
	sfx(0)
end

function update_bullets()
	for b in all(bullets) do
		b.y-=b.speed
		if b.y<-1 then
			del(bullets,b)
		end
	end
end

-->8
--stars

function create_stars()
	stars={}
	for s=1,20 do
		new_star={
			x=rnd(128),
			y=rnd(128),
			col=rnd({12,13,5,2,10,14,15}),
			speed=rnd({4,3,2,1})
		}
		add(stars,new_star)
	end
end

function update_stars()
	for s in all(stars) do
		s.y+=s.speed
		if s.y > 120 then
			s.y=0
			s.x=rnd(128)
		end
	end
end
-->8
--enemies

function spawn_enemies(amount)
 gap=(128-8*amount)/(amount+1)
	for i=1,amount do
		new_enemy={
			x=gap*i+8*(i-1),
			y=-20,
			life=4,
			speed=0.3
		}
		add(enemies,new_enemy)
	end
end

function update_enemies()
	for e in all(enemies) do
		e.y+=e.speed
		if e.y>128 then
			del(enemies,e)
		end
		--collision
		for b in all(bullets) do
			if collision(e,b) then
				create_explosions(b.x+4,b.y+2)
				del(bullets,b)
				e.life-=1
				if e.life==0 then
					del(enemies,e)
					score+=100
				end
			end
		end
	end
end
-->8
--collision
function collision(a,b)
	if a.x>b.x+8
	or a.y>b.y+8
	or a.x+8<b.x
	or a.y+8<b.y then
		return false
	else
		return true
	end
end
-->8
--explosions
function create_explosions(_x,_y)
	add(explosions,{x=_x,y=_y,timer=0})
	sfx(1)
end

function update_explosions()
	for e in all(explosions) do
		e.timer+=1
		if e.timer==13 then
			del(explosions	,e)
		end
	end
end

function draw_explosions()
	for e in all(explosions) do
		circ(e.x,e.y,e.timer/3,8+e.timer%3)
	end
end
-->8
--player

function update_player()
	if btn(➡️)then p.x+=p.speed end
	if btn(⬅️)then p.x-=p.speed end
	if btn(⬇️)then p.y+=p.speed end
	if btn(⬆️)then p.y-=p.speed end
	if btnp(❎)then shoot() end
	if p.y>124 then p.y-=p.speed end
	if p.y<0 then p.y+=p.speed end
	if p.x>124 then p.x-=p.speed end
	if p.x<-4 then p.x+=p.speed end

	for e in all(enemies) do
		if collision(e,p) then
			state=1
		end
	end
end
-->8
function update_gameover()
	if (btn(🅾️)) _init()
end

function draw_gameover()
	cls()
	rectfill(31,53,105,79,12)
	rectfill(28,50,102,76,1)
	print("score:"..score,38,56,10)
	print("c/🅾️ to continue",34,66,9)
end
-->8
--title
if (1==1) then
	print("hello world!")
end
__gfx__
00000000000000000070070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000060060000c00c000bb00bb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000060060000c00c0000b33b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700006dc7d600010010003bbbb30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700006dccd6000000000038bb830000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700d66dd66d00100100003bb300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000d666666d0000000002033020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000050dd0500000000000e00e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100002a0502b05029050280402504020030150300e03009030060300602008020080200402000020000002670028700297002a7002b7002b7002b7002b7002a6002b7002b7002c70000000000000000000000
000100001b6001d6101f6101f6101b610126200e62000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
