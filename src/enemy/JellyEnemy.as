package enemy {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import particles.*;
	import org.flixel.plugin.photonstorm.FlxCollision;
	import pickups.*;
	
	public class JellyEnemy extends BaseEnemy {
		
		public static function cons(g:FlxGroup):JellyEnemy {
			var rtv:JellyEnemy = g.getFirstAvailable(JellyEnemy) as JellyEnemy;
			if (rtv == null) {
				rtv = new JellyEnemy();
				g.add(rtv);
			}
			return rtv;
		}
		
		public function JellyEnemy() {
			super();
			this.loadGraphic(Resource.BLOB_SS, true, false, 100, 100);
			this.addAnimation("walk", [0, 1, 2, 3, 4, 5, 6], 10);
			this.addAnimation("stand", [0], 0);
			_hitbox.loadGraphic(Resource.BLOB_HITBOX);
			
		}
		public override function track_healthbar():void {
			if (_healthbar)_healthbar.trackParent(30, 0);
		}
		
		var _xdir:Number = 1;
		var _tar:FlxPoint = new FlxPoint();
		var _delay:Number = 0;
		var _red_ct:Number = 0;
		public function init(x:Number,y:Number, g:BottomGame):JellyEnemy {
			this.reset(x, y);
			this.set_tar();
			this.play("walk");
			g._hitboxes.add(_hitbox);
			this._max_health = 36;
			this._health = 36;
			return this;
		}
		
		public override function _update(g:BottomGame):void {
			super._update(g);
			_hitbox.x = this.x + 25;
			_hitbox.y = this.y + 25;
			if (this._invuln_ct > 0) {
				this.set_tar();
				this.invuln_update();
				this.color = 0xCC99FF;
				return;
			} else if (this._stun_ct > 0) {
				this.set_tar();
				this.stun_update();
				this.color = 0xCC99FF;
				return;
			}
			_red_ct--;
			if (_red_ct <= 0) this.color = 0xFFFFFF;
			if (this.hit_player(g)) {
				var v:Vector3D = Util.normalized(g._player.get_center().x - this.get_center().x, g._player.get_center().y - this.get_center().y);
				v.normalize();
				v.scaleBy(15);
				g._player.hit(v.x, v.y, 1);
				FlxG.shake(0.01, 0.15);
			}
			
			if (_delay > 0) {
				_delay--;
				
				if (_delay <= 0) {
					this.set_tar();
					
					if (Util.pt_dist(this.get_center().x, this.get_center().y, g._player._x, g._player._y) > 40) {
						var i:Number = 0.0;
						while (i < 3.14 * 2) {
							var dv:Vector3D = Util.normalized(Math.cos(i), Math.sin(i));
							dv.scaleBy(2);
							BulletEnemy.cons(g._enemies).init(this.get_center().x, this.get_center().y, dv.x, dv.y,600,g);
							i += 0.785;
						}
						this.color = 0xFF0000;
						_red_ct = 10;
					}
				}
				
			} else if (Util.pt_dist(this.get_center().x, this.get_center().y, _tar.x, _tar.y) < 2) {
				_delay = Util.float_random(10, 40);
				this.play("stand");
				
			} else {
				var p:FlxPoint = Util.drp_pos(Util.flxpt(this.get_center().x,this.get_center().y), _tar, 60);
				this.set_center(p.x, p.y);
				this.play("walk");
				
			}
		}
		
		private function set_tar():Boolean {
			var brk:Number = 0;
			while (brk < 10) {
				brk++;
				var v:Vector3D = Util.normalized(Util.float_random(60, 120) * Util.sig_n(Util.float_random(-1,1)), Util.float_random( -100, 100));
				v.scaleBy(50);
				_tar.x = this.get_center().x + v.x;
				_tar.y = this.get_center().y + v.y;
				if (_tar.x > 0 && _tar.x < Util.WID && _tar.y > 0 && _tar.y < Util.HEI) {
					return true;
				}
			}
			return false;
		}
		
		public override function _should_kill():Boolean { 
			return _health <= 0
		}
		public override function _do_kill(g:BottomGame):void {
			RotateFadeParticle.cons(g._particles).init(this.x + Util.float_random( -20, 20), this.y + Util.float_random( -20, 20)).p_set_ctspeed(0.05).p_set_scale(Util.float_random(1.5, 3));
			RotateFadeParticle.cons(g._particles).init(this.x + Util.float_random( -20, 20), this.y + Util.float_random( -20, 20)).p_set_ctspeed(0.05).p_set_scale(Util.float_random(1.5, 3)).p_set_delay(Util.float_random(5,10));
			RotateFadeParticle.cons(g._particles).init(this.x + Util.float_random(-20,20), this.y+ Util.float_random(-20,20)).p_set_ctspeed(0.05).p_set_scale(Util.float_random(1.5, 3)).p_set_delay(Util.float_random(5,10));
			for (var i:int = 0; i < 8; i++) {
				if (Util.float_random(0, SmallFollowPickup._HEALTH_SPAWN) < 1) {
					SmallFollowPickup.cons(g._pickups).init(this.x,this.y,1,1);
				} else {
					SmallFollowPickup.cons(g._pickups).init(this.x,this.y,1,0);
				}
			}
			this.kill();
			this._kill(g);
			
		}
		
		public override function get_center():FlxPoint {
			_get_center.x = this.x + 35;
			_get_center.y = this.y + 35;
			return _get_center;
		}
		
		public override function get_knockback_mult():Number {
			return 1;
		}
		
	}

}