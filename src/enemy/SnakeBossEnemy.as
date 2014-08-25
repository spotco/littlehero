package enemy {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import particles.*;
	import org.flixel.plugin.photonstorm.FlxCollision;
	import pickups.*;
	
	public class SnakeBossEnemy extends BaseEnemy{
		
		public static function cons(g:FlxGroup):SnakeBossEnemy {
			var rtv:SnakeBossEnemy = g.getFirstAvailable(SnakeBossEnemy) as SnakeBossEnemy;
			if (rtv == null) {
				rtv = new SnakeBossEnemy();
				g.add(rtv);
			}
			return rtv;
		}
		
		public function SnakeBossEnemy() {
			super();
			this.loadGraphic(Resource.SNAKE_BOSS_SS, true, false, 1342, 156);
			this.addAnimation("walk_left", [9, 8, 7, 6, 5], 10);
			this.addAnimation("walk_right", [4,3,2,1,0], 10);
			this.addAnimation("walk_left_slow", [9, 8, 7, 6, 5], 2);
			this.addAnimation("walk_right_slow", [4,3,2,1,0], 2);
			this.setOriginToCorner();
			_hitbox.loadGraphic(Resource.SNAKE_BOSS_HITBOX);
			
		}
		
		var _side:Number = 0; //0-right_to_left, 1-left_to_right
		var _arrows_to_stun:Number = 0;
		var _pass_stunned:Boolean = false;
		
		public function init(x:Number,y:Number, g:BottomGame):SnakeBossEnemy {
			this.reset(x, y);
			if (Util.float_random(0, 2) < 1) {
				this.start_left_to_right();
			} else {
				this.start_right_to_left();
			}
			g._bottom_game_ui.track_boss(this);
			g._hitboxes.add(_hitbox);
			this._max_health = 50;
			this._health = this._max_health;
			return this;
		}
		
		private function start_right_to_left():void {
			_side = 0;
			this.play("walk_left");
			this.x = 1100;
			this.y = (Util.float_random(0,2)<1)?Util.float_random(100,200):Util.float_random(300,400);
			_arrows_to_stun = 5;
			_pass_stunned = false;
		}
		
		private function start_left_to_right():void {
			_side = 1;
			this.play("walk_right");
			this.x = -100 - this.frameWidth;
			this.y = (Util.float_random(0,2)<1)?Util.float_random(100,200):Util.float_random(300,400);
			_arrows_to_stun = 5;
			_pass_stunned = false;
		}
		
		private function walk_anim():void {
			if (_side == 0) {
				this.play("walk_left");
			} else {
				this.play("walk_right");
			}
		}
		
		private function stand_anim():void {
			if (_side == 0) {
				this.play("walk_left_slow");
			} else {
				this.play("walk_right_slow");
			}
		}
		
		public override function _update(g:BottomGame):void {
			super._update(g);
			_hitbox.x = this.x;
			_hitbox.y = this.y + 25;
			
			if (this._invuln_ct > 0) {
				this.alpha = Math.floor(_invuln_ct / 5) % 2 == 0?1:0.5;
				this._invuln_ct--;
				this.color = 0xCC99FF;
				stand_anim();
				return;
			} else if (this._stun_ct > 0) {
				_stun_ct--;
				this.color = 0xCC99FF;
				stand_anim();
				
				if (_side == 0) {
					this.x -= 2;
					if (this.x < -200 - this.frameWidth) {
						this.start_left_to_right();
					}
				} else {
					this.x += 2;
					if (this.x > 1200) {
						this.start_right_to_left();
					}
				}
				
				return;
			} else {
				walk_anim();
				this.color = 0xFFFFFF;
			}
			
			
			
			if (this.hit_player(g)) {
				var v:Vector3D = Util.normalized(0, g._player.get_center().y - this.get_center().y);
				v.normalize();
				v.scaleBy(15);
				g._player.hit(v.x, v.y, 1);
				FlxG.shake(0.01, 0.15);
			}
			
			if (_side == 0) {
				this.x -= 8;
				if (this.x < -200 - this.frameWidth) {
					this.start_left_to_right();
				}
			} else {
				this.x += 8;
				if (this.x > 1200) {
					this.start_right_to_left();
				}
			}
			
			_fire_ct++;
			if (_fire_ct % 100 == 0) {
				var i:Number = 0.0;
				var pos:FlxPoint = Util.flxpt(this.x, this.y);
				if (_side == 0) {
					pos.x += 132;
					pos.y += 80;
				} else {
					pos.x += 1245;
					pos.y += 80;
				}
				while (i < 3.14 * 2) {
					var dv:Vector3D = Util.normalized(Math.cos(i), Math.sin(i));
					dv.scaleBy(2);
					BulletEnemy.cons(g._enemies).init(pos.x,pos.y, dv.x, dv.y,600,g);
					i += Util.float_random(0.8,1.2);
				}
			}
			
			if (Util.float_random(0, 200) < 1 && Util.alive_ct(g)<4) {
				var random_spot:FlxPoint = GameWaves.random_spot_not_near_player(g);
				TinySpiderEnemy.cons(g._enemies).init(random_spot.x, random_spot.y, g);
			}
		}
		var _fire_ct:Number = 0;
		
		public override function _hit(g:BottomGame, bow:Boolean = false):void {
			_arrows_to_stun--;
			if (_arrows_to_stun <= 0 && !_pass_stunned) {
				_pass_stunned = true;
				_stun_ct = 80;
			}
		}
		public override function _knockback(dx:Number, dy:Number, invuln_ct:Number, knockback:Number = 14, stun_ct:Number = 0):void {
			if (_stun_ct > 0) {
				_invuln_ct = invuln_ct;
			}
		}
		
		public override function _should_kill():Boolean { 
			return _health <= 0;
		}
		public override function _do_kill(g:BottomGame):void {
			for (var ii:Number = 0; ii < this.frameWidth; ii+=Util.float_random(5,20)) {
				RotateFadeParticle.cons(g._particles).init(
					this.x + Util.float_random( -20, 20) + ii, 
					this.y + Util.float_random( 0, 156)
				).p_set_ctspeed(0.05).p_set_scale(Util.float_random(1, 4)).p_set_delay(Util.float_random(0,40));
			}
			
			for (var j:int = 0; j < 150; j++) {
				SmallFollowPickup.cons(g._pickups).init(Util.float_random(0,Util.WID),this.y+40+Util.float_random(-100,100),3);
			}
			for each (var enem:BaseEnemy in g._enemies.members) {
				if (enem.alive) enem._health = 0;
			}
			FlxG.shake(0.1, 3);
			BottomGame._freeze_frame = 10;
			this.kill();
			this._kill(g);
			
		}
		
		public override function get_center():FlxPoint {
			_get_center.x = this.x;
			_get_center.y = this.y + 40;
			return _get_center;
		}
		
		public override function get_knockback_mult():Number {
			return 0;
		}
		
		public override function _arrow_damage_mult():Number { return (_stun_ct > 0)?0.2:0.025; }
		public override function _sword_damage_mult():Number { return (_stun_ct > 0)?0.7:0; }
		
	}

}