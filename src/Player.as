package  {
	import flash.geom.Vector3D;
	import misc.FlxGroupSprite;
	import org.flixel.*;
	import particles.ArrowReticuleUIParticle;
	import player_projectiles.*;
	
	public class Player extends FlxGroup {
		
		public var _body:FlxSprite = new FlxSprite();
		
		public var _arrowretic:ArrowReticuleUIParticle;
		public var _sword:SwordPlayerProjectile;
		
		public var _x:Number, _y:Number;
		public var _vx:Number = 0, _vy:Number = 0;
		public var _angle:Number = 0.0;
		public function Player() {
			_body.loadGraphic(Resource.PLAYER_SS, true, false, 32, 49);
			_body.addAnimation("walk", [0, 1, 2, 3, 4, 5, 6], 15);
			_body.addAnimation("stand", [3], 10);
			_body.play("walk");
			this.add(_body);
			this._x = Util.WID / 2;
			this._y = Util.HEI / 2;
		}
		
		public function update_position():void {
			_body.x = this._x;
			_body.y = this._y;
		}
		
		var _player_facing:Vector3D = new Vector3D(1, 0, 0);
		var _tar_ang:Number = 0;
		public function rotate_to(tar_ang:Number):void {
			_tar_ang = tar_ang + 90;
		}
		
		private var _mov = new Vector3D();
		public function _update(g:BottomGame):void {
			
			if (_invuln_ct > 0) {
				_invuln_ct--;
				_vx *= 0.8;
				_vy *= 0.8;
				this.update_position();
				player_control(1, true);
				_body.alpha = Math.floor(_invuln_ct / 5) % 2 == 0?1:0.5;
				_body.color = 0xFF0000;
				return;
				
			} else if (_knockback_ct > 0) {
				_knockback_ct --;
				//player_control(1,true);
				_body.color = 0xFFFFFF;
				_body.alpha = 1;
				_x += _knockback.x;
				_y += _knockback.y;
				_knockback.x *= 0.93;
				_knockback.y *= 0.93;
				this.update_position();
				return;
				
			} else {
				_body.color = 0xFFFFFF;
				_body.alpha = 1;
			}
			
			var facing_x:Number = 0.0;
			var facing_y:Number = 0.0;
			this.get_center();
			if (FlxG.mouse.x != this._get_center.x && FlxG.mouse.y != this._get_center.y) {
				var spawn:FlxPoint = _get_center;
				var v:Vector3D = Util.normalized(FlxG.mouse.x - spawn.x, FlxG.mouse.y - spawn.y);
				facing_x = -v.x;
				facing_y = -v.y;
			}
			
			if (facing_x != 0 || facing_y != _y) {
				this.rotate_to(Util.pt_to_flxrotation(facing_x,facing_y));
			}

			_angle += Util.lerp_deg(_angle, _tar_ang, 0.2);
			_body.angle = _angle;
			
			player_control();
			
			update_position();
		}
		
		var _control_vec:Vector3D = new Vector3D;
		private function player_control(scf:Number = 5, add:Boolean = false):void {
			_control_vec.x = 0;
			_control_vec.y = 0;
			if (Util.is_key(Util.MOVE_LEFT)) {
				_control_vec.x = -1;
			}
			if (Util.is_key(Util.MOVE_RIGHT)) {
				_control_vec.x = 1;
			}
			if (Util.is_key(Util.MOVE_UP)) {
				_control_vec.y = -1;
			}
			if (Util.is_key(Util.MOVE_DOWN)) {
				_control_vec.y = 1;
			}
			if (_control_vec.length != 0) {
				_control_vec.normalize();
				_control_vec.scaleBy(scf);
				if (add) {
					_vx += _control_vec.x;
					_vy += _control_vec.y;
				} else {
					_vx = _control_vec.x;
					_vy = _control_vec.y;
				}
				_body.play("walk");
			} else {
				_vx *= 0.5;
				_vy *= 0.5;
				_body.play("stand");
			}
			
			_x += _vx;
			_y += _vy;
			
			if (_x < 0) {
				_x = 0;
			} else if (_x > Util.WID-50) {
				_x = Util.WID-50;
			}
			if (_y < 0) {
				_y = 0;
			} else if (_y > Util.HEI-50) {
				_y = Util.HEI-50;
			}
		}
		
		private var _get_center:FlxPoint = new FlxPoint();
		public function get_center():FlxPoint {
			_get_center.x = this._x + 17.5;
			_get_center.y = this._y + 17.5;
			return _get_center;
		}
		
		public var _invuln_ct:Number = 0;
		public function hit(dx:Number, dy:Number, damage:Number, invuln_knockback:Boolean = true):void {
			if (invuln_knockback) {
				_invuln_ct = 30;
			}
			GameStats._health -= damage * GameStats._armor_mult;
			_vx = dx;
			_vy = dy;
			FlxG.play(Resource.SFX_HIT);
		}
		
		public var _knockback_ct:Number = 0;
		public var _knockback:FlxPoint = new FlxPoint(0, 0);
		public function knockback(dx:Number, dy:Number, ct:Number):void {
			_knockback_ct = ct;
			_knockback.x = dx;
			_knockback.y = dy;
		}
	}

}