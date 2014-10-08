package  {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import particles.*;
	import flash.display.*;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.ui.*;
	import flash.events.MouseEvent;
	
	public class TopState extends FlxState{
		
		
		var _particles:FlxGroup = new FlxGroup();
		var _bully_left:FlxSprite = new FlxSprite(0, 0, Resource.TOP_BULLY_LEFT);
		var _bully_center:FlxSprite = new FlxSprite(0, 0, Resource.TOP_BULLY_CENTER);
		var _bully_right:FlxSprite = new FlxSprite(0, 0, Resource.TOP_BULLY_RIGHT);
		
		var _bully_left_offsety:Number = 0;
		var _bully_center_offsety:Number = 0;
		var _bully_right_offsety:Number = 0;
		var _teacher_offsety:Number = 0;
		var _bg:FlxSprite = new FlxSprite(0, 0, Resource.TOP_BG);
		
		var _player:FlxSprite = new FlxSprite(0, 0, Resource.TOP_PLAYER);
		var _teacher:FlxSprite = new FlxSprite(0, 0, Resource.TOP_TEACHER);
		var _maintext:ScrollText;
		var _misctext:FlxGroup = new FlxGroup();
		
		var _click_to_continue:FlxText;
		
		var _zzz:FlxSprite = new FlxSprite();
		
		public override function create():void {			
			this.add(_bg);
			this.add(_player);
			this.add(_zzz);
			this.add(_teacher);
			this.add(_bully_left);
			this.add(_bully_center);
			this.add(_bully_right);
			this.add(_misctext);
			
			_zzz.set_position(Util.WID*0.6 + 100,Util.HEI*0.4 - 30);
			_zzz.loadGraphic(Resource.TOP_ZZZ, true, false, 61, 82);
			_zzz.addAnimation("play", [0, 1, 2],5);
			_zzz.play("play");
			
			Mouse.hide();
			FlxG.mouse.show(Resource.MOUSE_SWORD);
			
			_misctext.add(Util.cons_text(0, 0, "(M)-Mute, (F1)-Fullscreen", 0xFFFFFF, 12));
			//_misctext.add(Util.cons_text(0, 18, "M to mute/unmute", 0xFFFFFF, 12));
			_click_to_continue = Util.cons_text(Util.WID * 0.4875, 218-15, "Click Anywhere to Continue", 0xFFFFFF, 16);
			_misctext.add(_click_to_continue);
			
			Util.play_bgm(Resource.BGM_MAIN);
			
			if (GameStats._story >= 1) {
				_bully_right.loadGraphic(Resource.TOP_BULLY_RIGHT_EMPTY);	
			}
			if (GameStats._story >= 2) {
				_bully_left.loadGraphic(Resource.TOP_BULLY_LEFT_EMPTY);
			}	
			if (GameStats._story >= 3) {
				_bully_center.loadGraphic(Resource.TOP_BULLY_CENTER_EMPTY);
			}
			
			
			var maintext:FlxText = Util.cons_text(Util.WID * 0.5, Util.HEI * 0.15, "", 0xFFFFFF, 24, 400);
			this.add(maintext);
			var text:String = "";
			if (GameStats._story >= 3) {
				FlxG.switchState(new GameEndState());
			} else if (GameStats._story >= 2) {
				text = "Save Me! One final boss left!";
			} else if (GameStats._story >= 1) {
				text = "Save Me! Only two bosses left!";
			} else {
				text = "Save Me! Defeat the three evil bosses!";
			}
			_maintext = new ScrollText(maintext, text, 5);
			
			_player.x = Util.WID * 0.6;
			_player.y = Util.HEI * 0.4;
			
			set_bully_y();
			
			_bully_center.x = Util.WID / 2 - _bully_center.width/2;
			_bully_right.x = Util.WID - _bully_right.width;
			this.set_bully_y();
			this.add(_particles);
			_fade_cover.makeGraphic(1000, 500, 0xFF000000);
			this.add(_fade_cover);
			
			ChatManager._inst = new ChatManager();
			ChatManager._inst.show_back(true);
			ChatManager._inst.pick_message_set(
				GameStats._story == 0?ChatManager.m_top_0:
				GameStats._story == 1?ChatManager.m_top_1:
				ChatManager.m_top_2
			);
			this.add(ChatManager._inst);
		}
		
		private function set_bully_y():void {
			_bully_left.y = Util.HEI - _bully_left.height + 30 + _bully_left_offsety;
			_bully_center.y = Util.HEI - _bully_center.height + 30 + _bully_center_offsety;
			_bully_right.y = Util.HEI - _bully_right.height + 30 + _bully_right_offsety;
			_teacher.x = Util.WID * 0.25;
			_teacher.y = Util.HEI * 0.2 + _teacher_offsety;
		}
		
		var _state:Number = 0;
		
		var _fade_cover:FlxSprite = new FlxSprite();
		var _fadeout:Boolean = false;
		var _fadein:Boolean = true;
		
		var _ending_ct:Number = 0;
		var _chat_anim_ct:Number = 0;
		
		var _click_to_continue_ct:Number = 0;
		
		public override function update():void {
			super.update();
			Mouse.hide();
			ChatManager._inst._update();
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
			_click_to_continue_ct++;
			if (_click_to_continue_ct % 50 == 0) {
				_click_to_continue.visible = !_click_to_continue.visible;
			}
			
			if (GameEndState._ending) {
				_ending_ct++;
				_zzz.visible = false;
				if (_ending_ct == 30) {
					_player.loadGraphic(Resource.TOP_PLAYER_AWAKE);
				} else if (_ending_ct == 120) {
					_player.loadGraphic(Resource.TOP_PLAYER);
					GameEndState._ending = false;
				}
			} else {
				_zzz.visible = true;
			}
			
			for each (var part:BaseParticle in _particles.members) {
				if (part.alive) {
					part._update(null);
					if (part._should_remove()) {
						part._do_remove();
					}
				}
			}
			
			if (!_fadein && _state == 0) {}
			
			if (_state == 0) { 
				_bully_left_offsety *= 0.95;
				_bully_center_offsety *= 0.95;
				_bully_right_offsety *= 0.95;
				_teacher_offsety *= 0.95;
				this.set_bully_y();
				_chat_anim_ct++;
				if (_chat_anim_ct%20 == 0 && !ChatManager._inst._text_scroll.finished()) {
					if (ChatManager._inst._cur_sprite == ChatManager._inst._teacher_sprite) {
						_teacher_offsety = -8;
					}
					if (ChatManager._inst._cur_sprite == ChatManager._inst._snakeboss_sprite) {
						_bully_right_offsety = -8;
					}
					if (ChatManager._inst._cur_sprite == ChatManager._inst._spider_sprite) {
						_bully_left_offsety = -8;
					}
					if (ChatManager._inst._cur_sprite == ChatManager._inst._fireboss_sprite) {
						_bully_center_offsety = -8;
					}
				}
				if (FlxG.mouse.justPressed()) {
					_state = 1;
					_ct = 0;
					this.remove(ChatManager._inst);
					this.remove(_misctext);
				}
				
			} else if (_state == 1) {
				if (_bully_center.alpha > 0) _bully_center.alpha -= 0.01;
				if (_bully_left.alpha > 0) _bully_left.alpha -= 0.01;
				if (_bully_right.alpha > 0) _bully_right.alpha -= 0.01;
				if (_bg.alpha > 0) _bg.alpha -= 0.01;
				if (_zzz.alpha > 0) _zzz.alpha -= 0.01;
				_ct++;
				if (_ct >= 100) {
					_state = 2;
					var i:int = 0;
					for (i = 0; i < 20; i++)  RotateFadeParticle.cons(_particles).init(_player.x + _player.frameWidth / 2 + Util.float_random( -60, 60), _player.y + _player.frameHeight / 2 + Util.float_random( -120, 190)).p_set_ctspeed(0.05).p_set_scale(Util.float_random(3, 6)).p_set_delay(Util.float_random(0, 25));
					for (i = 0; i < 20; i++)  RotateFadeParticle.cons(_particles).init(_teacher.x + _teacher.frameWidth / 2 + Util.float_random( -60, 60), _teacher.y + _teacher.frameHeight / 2 + Util.float_random( -120, 120)).p_set_ctspeed(0.05).p_set_scale(Util.float_random(3, 6)).p_set_delay(Util.float_random(0, 25));
					FlxG.play(Resource.SFX_EXPLOSION);
					FlxG.play(Resource.SFX_EXPLOSION);
					FlxG.play(Resource.SFX_EXPLOSION);
					_player.loadGraphic(Resource.TOP_KNIGHT);
					_teacher.loadGraphic(Resource.TOP_PRINCESS_CAGE);
					_teacher.x -= 50;
					_teacher.y -= 30;
				}
			
			} else if (_state == 2) {
				_maintext._update();
				if (_maintext.finished()) {
					_state = 3;
					_ct = 100;
				}
			} else if (_state == 3) {
				_ct--;
				if (_ct <= 0) {
					
					_fadeout = true;
				}
				
			}
		}
		
		var _ct:Number = 0;
		
	}

}