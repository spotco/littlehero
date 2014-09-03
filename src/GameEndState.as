package  {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import particles.*;
	public class GameEndState extends FlxState {
		
		public static var _ending:Boolean = false;
		
		var _particles:FlxGroup = new FlxGroup();
		var _bg:FlxSprite = new FlxSprite(0, 0, Resource.TOP_BG);
		var _bully_left:FlxSprite = new FlxSprite(0, 0, Resource.TOP_BULLY_LEFT_EMPTY);
		var _bully_center:FlxSprite = new FlxSprite(0, 0, Resource.TOP_BULLY_CENTER_EMPTY);
		var _bully_right:FlxSprite = new FlxSprite(0, 0, Resource.TOP_BULLY_RIGHT_EMPTY);
		var _player:FlxSprite = new FlxSprite(0, 0, Resource.TOP_PLAYER);
		var _teacher:FlxSprite = new FlxSprite(0, 0, Resource.TOP_TEACHER);
		
		var _click_to_continue:FlxText;
		
		public override function create():void {
			Util.play_bgm(Resource.BGM_MAIN);
			this.add(_bg);
			this.add(_teacher);
			this.add(_player);
			this.add(_bully_left);
			this.add(_bully_center);
			this.add(_bully_right);
			_fade_cover.makeGraphic(1000, 500, 0xFF000000);
			this.add(_fade_cover);
			this.add(_particles);
		
			_player.x = Util.WID * 0.6;
			_player.y = Util.HEI * 0.4;
			_teacher.x = Util.WID * 0.25;
			_teacher.y = Util.HEI * 0.22;
			_bully_center.x = Util.WID / 2 - _bully_center.width/2;
			_bully_right.x = Util.WID - _bully_right.width;
			_bully_left.y = Util.HEI - _bully_left.height + 30;
			_bully_center.y = Util.HEI - _bully_center.height + 30;
			_bully_right.y = Util.HEI - _bully_right.height + 30;
			_teacher.y = Util.HEI * 0.22;
			
			this.add(Util.cons_text(Util.WID/2+95, Util.HEI/2-155, "The End.", 0xFFFFFF, 15));
			
			_click_to_continue = Util.cons_text(5, 5, "Click to Continue", 0xFFFFFF, 24);
			this.add(_click_to_continue);
			_click_to_continue.alpha = 0;
		}
		var _mode:Number = 0;
		var _fade_cover:FlxSprite = new FlxSprite();
		var _fadeout:Boolean = false;
		var _fadein:Boolean = true;
		public override function update():void {
			for each (var part:BaseParticle in _particles.members) {
				if (part.alive) {
					part._update(null);
					if (part._should_remove()) {
						part._do_remove();
					}
				}
			}
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
					GameStats._story = 0;
					FlxG.switchState(new TopState());
				}
				return;
			}
			
			if (_mode == 0) { 
				_ct--;
				if (_ct <= 0) {
					_teacher.loadGraphic(Resource.TOP_PRINCESS_SILOUHETTE);
					var i:int = 0;
					for (i = 0; i < 20; i++)  RotateFadeParticle.cons(_particles).init(_teacher.x + _teacher.frameWidth / 2 + Util.float_random( -60, 60), _teacher.y + _teacher.frameHeight / 2 + Util.float_random( -120, 120)).p_set_ctspeed(0.05).p_set_scale(Util.float_random(3, 6)).p_set_delay(Util.float_random(0, 25));
					_mode = 1;
					_ct = 50;
					FlxG.play(Resource.SFX_EXPLOSION);
					FlxG.play(Resource.SFX_EXPLOSION);
					FlxG.play(Resource.SFX_EXPLOSION);
				}
				
			} else if (_mode == 1) {
				_ct--;
				if (_ct <= 0) {
					_mode = 2;
					_ct=200;
				}
			
			} else if (_mode == 2) {
				_ct--;
				if (_ct <= 0) {
					_mode = 3;
					_ct = 100;
				}
				_ct2++;
				if (_ct2 % 25 == 0) {
					_anim_toggle = !_anim_toggle;
					if (_anim_toggle) {
						_player.loadGraphic(Resource.TOP_PLAYER);
					} else {
						_player.loadGraphic(Resource.TOP_PLAYER_AWAKE);
					}
				}
			} else if (_mode == 3) {
				_ct--;
				_teacher.x += 2;
				if (_ct <= 0) {
					_fadeout = true;
					_ending = true;
				}
			}
		}
		
		var _ct:Number = 150;
		var _ct2:Number = 0;
		var _anim_toggle:Boolean = false;
		
	}

}