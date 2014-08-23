package  {
	import flash.geom.Vector3D;
	import misc.FlxGroupSprite;
	import org.flixel.*;
	import player_projectiles.*;
	
	public class Player extends FlxGroup {
		
		public var _body:FlxSprite = new FlxSprite(0, 0, Resource.PLAYER);
		
		public var _x:Number, _y:Number;
		public var _vx:Number = 0, _vy:Number = 0;
		public var _angle:Number = 0.0;
		public function Player() {
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
		private function player_control():void {
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
				_control_vec.scaleBy(5);
				
				_vx = _control_vec.x;
				_vy = _control_vec.y;
			} else {
				_vx *= 0.5;
				_vy *= 0.5;
			}
			
			_x += _vx;
			_y += _vy;
			
			if (_x < 0) {
				_x = 0;
			} else if (_x > Util.WID) {
				_x = Util.WID;
			}
			if (_y < 0) {
				_y = 0;
			} else if (_y > Util.HEI) {
				_y = Util.HEI;
			}
		}
		
		private var _get_center:FlxPoint = new FlxPoint();
		public function get_center():FlxPoint {
			_get_center.x = this._x + 10;
			_get_center.y = this._y + 10;
			return _get_center;
		}
		
	}

}