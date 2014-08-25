package  {
	import flash.geom.Vector3D;
	import org.flixel.*;
	public class TopState extends FlxState{
		
		var _bully_left:FlxSprite = new FlxSprite(0, 0, Resource.TOP_BULLY_LEFT);
		var _bully_center:FlxSprite = new FlxSprite(0, 0, Resource.TOP_BULLY_CENTER);
		var _bully_right:FlxSprite = new FlxSprite(0, 0, Resource.TOP_BULLY_RIGHT);
		
		var _bully_left_offsety:Number = 0;
		var _bully_center_offsety:Number = 0;
		var _bully_right_offsety:Number = 0;
		var _teacher_offsety:Number = 0;
		
		var _player:FlxSprite = new FlxSprite(0, 0, Resource.TOP_PLAYER);
		var _teacher:FlxSprite = new FlxSprite(0, 0, Resource.TOP_TEACHER);
		
		public override function create():void {
			this.add(new FlxSprite(0, 0, Resource.TOP_BG));
			this.add(_player);
			this.add(_teacher);
			this.add(_bully_left);
			this.add(_bully_center);
			this.add(_bully_right);
			
			_player.x = Util.WID * 0.6;
			_player.y = Util.HEI * 0.4;
			
			_teacher.x = Util.WID * 0.25;
			
			_bully_center.x = Util.WID / 2 - _bully_center.width/2;
			_bully_right.x = Util.WID - _bully_right.width;
			this.set_bully_y();
			
			_fade_cover.makeGraphic(1000, 500, 0xFF000000);
			this.add(_fade_cover);
		}
		
		private function set_bully_y():void {
			_bully_left.y = Util.HEI - _bully_left.height + 30 + _bully_left_offsety;
			_bully_center.y = Util.HEI - _bully_center.height + 30 + _bully_center_offsety;
			_bully_right.y = Util.HEI - _bully_right.height + 30 + _bully_right_offsety;
			_teacher.y = Util.HEI * 0.22 + _teacher_offsety;
		}
		
		var _fade_cover:FlxSprite = new FlxSprite();
		var _fadeout:Boolean = false;
		var _fadein:Boolean = true;
		
		public override function update():void {
			if (_fadein) {
				_fade_cover.alpha -= 0.05;
				if (_fade_cover.alpha <= 0) {
					_fade_cover.alpha = 0;
					_fadein = false;
				}
				return;
				
			} else if (_fadeout) {
				_fade_cover.alpha += 0.05;
				if (_fade_cover.alpha >= 1) {
					_fade_cover.alpha = 1;
					_fadeout = false;
					FlxG.switchState(new ShopState());
				}
				return;
			}
			if (FlxG.mouse.justPressed()) {
				_fadeout = true;
			}
			
			if (Util.float_random(0, 50) < 1) {
				_bully_right_offsety = -10;
			}
			if (Util.float_random(0, 50) < 1) {
				_bully_center_offsety = -10;
			}
			if (Util.float_random(0, 50) < 1) {
				_bully_left_offsety = -10;
			}
			if (Util.float_random(0, 50) < 1) {
				_teacher_offsety = -10;
			}
			_bully_left_offsety *= 0.9;
			_bully_center_offsety *= 0.9;
			_bully_right_offsety *= 0.9;
			_teacher_offsety *= 0.9
			this.set_bully_y();
		}
		
	}

}