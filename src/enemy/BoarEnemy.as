package enemy {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import particles.*;
	import org.flixel.plugin.photonstorm.FlxCollision;
	import pickups.*;
	public class BoarEnemy extends BaseEnemy {
		
		public static function cons(g:FlxGroup):BoarEnemy {
			var rtv:BoarEnemy = g.getFirstAvailable(BoarEnemy) as BoarEnemy;
			if (rtv == null) {
				rtv = new BoarEnemy();
				g.add(rtv);
			}
			return rtv;
		}
		
		public function BoarEnemy() {
			super();
			this.loadGraphic(Resource.BOAR, true, false, 300, 342);
			this.addAnimation("stand", [2,3], 10);
			this.addAnimation("ready", [0,1], 10);
			this.addAnimation("charge", [4,5,6], 10);
			_hitbox.loadGraphic(Resource.BOAR_HITBOX);
			
		}
		public override function track_healthbar():void {
			if (_healthbar)_healthbar.trackParent(90, 90);
		}
		
		var _mode:Number = 0;
		var _ct:Number = 0;
		public function init(x:Number,y:Number, g:BottomGame):BoarEnemy {
			this.reset(x, y);
			this.set_center(x, y);
			
			this.play("stand");
			g._hitboxes.add(_hitbox);
			this._max_health = 64;
			this._health = 64;
			_mode = 0;
			_ct = Util.float_random(100,300);
			return this;
		}
		
		public override function _update(g:BottomGame):void {
			super._update(g);
			_hitbox.x = this.x + 95;
			_hitbox.y = this.y + 125;
			if (this._invuln_ct > 0) {
				this.invuln_update();
				this.color = 0xCC99FF;
				return;
			} else if (this._stun_ct > 0) {
				this.stun_update();
				this.color = 0xCC99FF;
				return;
			}
			this.color = 0xFFFFFF;
			if (this.hit_player(g)) {
				var v:Vector3D = Util.normalized(g._player.get_center().x - this.get_center().x, g._player.get_center().y - this.get_center().y);
				v.normalize();
				v.scaleBy(15);
				g._player.hit(v.x, v.y, 2);
				FlxG.shake(0.01, 0.15);
			}
			
			if (_mode == 0) { //track
				this.angle += Util.lerp_deg(this.angle, Util.pt_to_flxrotation(g._player.get_center().x - this.get_center().x, g._player.get_center().y - this.get_center().y) - 90, 0.2);
				_ct--;
				if (_ct < 30) {
					this.play("ready");
				} else {
					this.play("stand");
				}
				if (_ct <= 0) {
					_mode = 1;
					FlxG.shake(0.01, 0.1);
				}
			} else if (_mode == 1) { //charge
				_ct++;
				if (_ct % 10 == 0) {
					FlxG.shake(0.0075, 0.05);
				}
				this.play("charge");
				var dir:FlxPoint = Util.flxrotation_to_pt(this.angle + 90);
				_vx = dir.x * 8;
				_vy = dir.y * 8;
				this.x += _vx;
				this.y += _vy;
				if (this.hit_wall() && _ct > 50) {
					FlxG.shake(0.02, 0.15);
					if (this._hit_wall_bottom || this._hit_wall_top) {
						_vy *= -1;
					} 
					if (this._hit_wall_left || this._hit_wall_right) {
						_vx *= -1;
					}
					_mode = 2;
					_ct = 30;
				}
			} else if (_mode == 2) { //bounceback
				this.play("stand");
				this.x += _vx;
				this.y += _vy;
				_vx *= 0.92;
				_vy *= 0.92;
				_ct--;
				if (_ct <= 0) {
					_mode = 0;
					_ct = Util.float_random(100,300);
				}
			}
		}
		
		public override function _should_kill():Boolean { 
			return _health <= 0
		}
		public override function _do_kill(g:BottomGame):void {
			RotateFadeParticle.cons(g._particles).init(this.get_center().y + Util.float_random( -20, 20), this.get_center().x + Util.float_random( -20, 20)).p_set_ctspeed(0.05).p_set_scale(Util.float_random(1.5, 3));
			RotateFadeParticle.cons(g._particles).init(this.get_center().y + Util.float_random( -20, 20), this.get_center().x + Util.float_random( -20, 20)).p_set_ctspeed(0.05).p_set_scale(Util.float_random(1.5, 3));
			RotateFadeParticle.cons(g._particles).init(this.get_center().y + Util.float_random( -20, 20), this.get_center().x + Util.float_random( -20, 20)).p_set_ctspeed(0.05).p_set_scale(Util.float_random(1.5, 3));
			
			for (var i:int = 0; i < 20; i++) {
				SmallFollowPickup.cons(g._pickups).init(this.get_center().x,this.get_center().y);
			}
			this.kill();
			this._kill(g);
			
		}
		
		public override function get_center():FlxPoint {
			_get_center.x = this.x + 125;
			_get_center.y = this.y + 125;
			return _get_center;
		}
		
		public override function get_knockback_mult():Number {
			return 0.4;
		}
		
		public override function _arrow_stun_mult():Number {
			return 0.05;
		}
		
	}

}