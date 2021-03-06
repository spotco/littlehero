package pickups {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import enemy.*;
	import org.flixel.plugin.photonstorm.FlxCollision;
	import particles.*;
	public class SmallFollowPickup extends BasePickup {
		
		public static function cons(g:FlxGroup):SmallFollowPickup {
			var rtv:SmallFollowPickup = g.getFirstAvailable(SmallFollowPickup) as SmallFollowPickup;
			if (rtv == null) {
				rtv = new SmallFollowPickup();
				g.add(rtv);
			}
			return rtv;
		}
		
		public function SmallFollowPickup() {
			super();
		}
		
		public var _ct:Number = 0;
		public var _vel:FlxPoint = new FlxPoint();
		var _flash_ct:int = 0;
		var _magneted:Boolean = false;
		var _type:Number = 0;
		var _fadeout_speed:Number = 0;
		
		public function init(x:Number, y:Number, scf:Number = 1, type:Number = 0):SmallFollowPickup {
			_type = type;
			if (_type == 0) {
				this.loadGraphic(Resource.GOLD);
				_fadeout_speed = 0.001;
			} else {
				this.loadGraphic(Resource.HEART);
				_fadeout_speed = 0.003;
			}
			this.reset(x, y);
			
			_ct = 0;
			_vel.x = Util.float_random(-13 * scf,13* scf);
			_vel.y = Util.float_random(-13 *scf,13* scf);
			_magneted = false;
			_picked_up = false;
			return this;
		}
		
		public static var _HEALTH_SPAWN:Number = 20;
		public static var _HEALTH_SPAWN_2:Number = 40;
		
		var _picked_up:Boolean = false;
		public override function _update(g:BottomGame):void {
			
			var dist:Number = Util.pt_dist(this.x, this.y, g._player.get_center().x, g._player.get_center().y);
			if (dist < 20) {
				if (!_picked_up) {
					_picked_up =  true;
					if (_type == 0) {
						GameStats._gold++;
						FlxG.play(Resource.SFX_COLLECT_1);
					} else {
						GameStats._health = Math.min(GameStats._health + 0.5, GameStats._max_health);
						FlxG.play(Resource.SFX_POWERUP);
					}
				}
			} else if (dist < 60) {
				_magneted = true;
			}
			
			this.x += _vel.x;
			this.y += _vel.y;
			if (this.x < 0) {
				this.x = 0;
				_vel.x = -_vel.x;
			}
			if (this.x > Util.WID) {
				this.x = Util.WID;
				_vel.x = -_vel.x;
			}
			if (this.y < 0) {
				this.y = 0;
				_vel.y = -_vel.y;
			}
			if (this.y > Util.HEI) {
				this.y = Util.HEI;
				_vel.y = -_vel.y;
			}
			
			if (_magneted) {
				var player:FlxPoint = g._player.get_center();
				var v:Vector3D = Util.normalized(player.x - this.x, player.y - this.y);
				v.scaleBy(5.5);
				_vel.x = v.x;
				_vel.y = v.y;
			} else {
				_vel.x *= 0.95;
				_vel.y *= 0.95;
				
			}
			
			_ct += _fadeout_speed;
			_flash_ct++;
			if (_ct > 0.7) {
				if (_flash_ct % 10 == 0) {
					this.alpha = this.alpha == 1 ? 0.6 : 1;
				}
				
			} else {
				this.alpha = 1;
			}
			if (_ct >= 1) {
				_picked_up = true;
			}
		}
		
		public override function _should_remove():Boolean { return _picked_up; }
		public override function _do_remove(g:BottomGame):void {
			this.kill();
			
		}
		
	}

}