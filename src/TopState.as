package  {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import particles.*;
	public class TopState extends FlxState{
		
		
		var _particles:FlxGroup = new FlxGroup();
		var _bully_left:FlxSprite = new FlxSprite(0, 0, Resource.TOP_BULLY_LEFT);
		var _bully_center:FlxSprite = new FlxSprite(0, 0, Resource.TOP_BULLY_CENTER);
		var _bully_right:FlxSprite = new FlxSprite(0, 0, Resource.TOP_BULLY_RIGHT);
		
		var _cage:FlxSprite = new FlxSprite(Util.WID * 0.25 - 40, -400, Resource.TOP_CAGE);
		
		var _bully_left_offsety:Number = 0;
		var _bully_center_offsety:Number = 0;
		var _bully_right_offsety:Number = 0;
		var _teacher_offsety:Number = 0;
		var _bg:FlxSprite = new FlxSprite(0, 0, Resource.TOP_BG);
		
		var _player:FlxSprite = new FlxSprite(0, 0, Resource.TOP_PLAYER);
		var _teacher:FlxSprite = new FlxSprite(0, 0, Resource.TOP_TEACHER);
		
		var _maintext:ScrollText;
		
		var _click_to_continue:FlxText
		
		public override function create():void {
			this.add(_bg);
			this.add(_player);
			this.add(_teacher);
			this.add(_bully_left);
			this.add(_bully_center);
			this.add(_bully_right);
			this.add(_cage);
			
			_click_to_continue = Util.cons_text(5, 5, "Click to Continue", 0xFFFFFF, 24);
			this.add(_click_to_continue);
			
			var maintext:FlxText = Util.cons_text(Util.WID * 0.5, Util.HEI * 0.15, "", 0xFFFFFF, 24, 400);
			this.add(maintext);
			_maintext = new ScrollText(maintext, "Save Me! Defeat the three evil bosses!", 5);
			
			_player.x = Util.WID * 0.6;
			_player.y = Util.HEI * 0.4;
			
			_teacher.x = Util.WID * 0.25;
			_teacher.y = Util.HEI * 0.22;
			
			_bully_center.x = Util.WID / 2 - _bully_center.width/2;
			_bully_right.x = Util.WID - _bully_right.width;
			this.set_bully_y();
			this.add(_particles);
			_fade_cover.makeGraphic(1000, 500, 0xFF000000);
			this.add(_fade_cover);
		}
		
		private function set_bully_y():void {
			_bully_left.y = Util.HEI - _bully_left.height + 30 + _bully_left_offsety;
			_bully_center.y = Util.HEI - _bully_center.height + 30 + _bully_center_offsety;
			_bully_right.y = Util.HEI - _bully_right.height + 30 + _bully_right_offsety;
			_teacher.y = Util.HEI * 0.22 + _teacher_offsety;
		}
		
		var _state:Number = 0;
		
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
			for each (var part:BaseParticle in _particles.members) {
				if (part.alive) {
					part._update(null);
					if (part._should_remove()) {
						part._do_remove();
					}
				}
			}
			
			if (!_fadein && _state == 0) {
				if (FlxG.mouse.justPressed()) {
					_state = 1;
					_ct = 0;
				}
			}
			
			if (_state == 0) { 
				this._click_to_continue.alpha = 1;
				_bully_left_offsety *= 0.95;
				_bully_center_offsety *= 0.95;
				_bully_right_offsety *= 0.95;
				_teacher_offsety *= 0.95;
				this.set_bully_y();
				
			} else if (_state == 1) {
				this._click_to_continue.alpha = 0;
				if (_bully_center.alpha > 0) _bully_center.alpha -= 0.01;
				if (_bully_left.alpha > 0) _bully_left.alpha -= 0.01;
				if (_bully_right.alpha > 0) _bully_right.alpha -= 0.01;
				if (_bg.alpha > 0) _bg.alpha -= 0.01;
				_ct++;
				if (_ct >= 100) {
					_state = 2;
					var i:int = 0;
					for (i = 0; i < 20; i++)  RotateFadeParticle.cons(_particles).init(_player.x + _player.frameWidth / 2 + Util.float_random( -60, 60), _player.y + _player.frameHeight / 2 + Util.float_random( -120, 190)).p_set_ctspeed(0.05).p_set_scale(Util.float_random(3, 6)).p_set_delay(Util.float_random(0, 25));
					for (i = 0; i < 20; i++)  RotateFadeParticle.cons(_particles).init(_teacher.x + _teacher.frameWidth / 2 + Util.float_random( -60, 60), _teacher.y + _teacher.frameHeight / 2 + Util.float_random( -120, 120)).p_set_ctspeed(0.05).p_set_scale(Util.float_random(3, 6)).p_set_delay(Util.float_random(0, 25));
					_player.loadGraphic(Resource.TOP_KNIGHT);
					_teacher.loadGraphic(Resource.TOP_PRINCESS);
				}
			
			} else if (_state == 2) {
				_cage.x = Util.WID * 0.25 - 20;
				_cage.y = _teacher.y - 70;
				_maintext._update();
				if (_maintext.finished()) {
					_state = 3;
					_ct = 100;
				}
			} else if (_state == 3) {
				_ct--;
				this._click_to_continue.alpha = 1;
				if (FlxG.mouse.justPressed()) {
					
					_fadeout = true;
				}
				
			}
		}
		
		var _ct:Number = 0;
		
	}

}