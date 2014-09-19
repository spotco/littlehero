package {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import player_projectiles.*;
	import enemy.*;
	import particles.*;
	import pickups.*;
	import flash.ui.*;
	
	public class BottomGame extends FlxState{
		
		public var _player:Player = new Player();
		public var _player_projectiles:FlxGroup = new FlxGroup();
		public var _enemies:FlxGroup = new FlxGroup();
		public var _particles:FlxGroup = new FlxGroup();
		public var _healthbars:FlxGroup = new FlxGroup();
		public var _pickups:FlxGroup = new FlxGroup();
		public var _hitboxes:FlxGroup = new FlxGroup();
		
		public var _bottom_game_ui:BottomGameUI = new BottomGameUI();
		
		var _bg:FlxSprite;
		var _fg:FlxSprite;
		
		public override function create():void {
			GameWaves.reset(GameStats._story);
			if (GameStats._story == 0) {
				_bg = new FlxSprite(0, 0, Resource.BOTTOM_BG1);
				_fg  = new FlxSprite(0, 0, Resource.BOTTOM_FG1);
			} else if (GameStats._story == 1) {
				_bg = new FlxSprite(0, 0, Resource.BOTTOM_BG2);
				_fg  = new FlxSprite(0, 0, Resource.BOTTOM_FG2);
			} else {
				_bg = new FlxSprite(0, 0, Resource.BOTTOM_BG3);
				_fg  = new FlxSprite(0, 0, Resource.BOTTOM_FG3);
			}
			
			this.add(_bg);
			this.add(_pickups);
			this.add(_player);
			this.add(_enemies);
			this.add(_player_projectiles);
			this.add(_particles);
			this.add(_fg );
			this.add(_bottom_game_ui);
			this.add(_healthbars);
			
			//this.add(_hitboxes);
			
			_player._sword = SwordPlayerProjectile.cons(_player_projectiles).init(_player,this);
			CrossBowPlayerProjectile.cons(_player_projectiles).init(_player);
			_player._arrowretic = ArrowReticuleUIParticle.cons(_particles).init(_player, true);
			ArrowReticuleUIParticle.cons(_particles).init(_player, false);
			SweatParticle.cons(_particles);
			
			_fade_cover = new FlxSprite();
			_fade_cover.makeGraphic(1000, 500, 0xFF000000);
			this.add(_fade_cover);
			
			GameStats._health = GameStats._max_health;
		}
		
		var _fadeout_can_move:Boolean = false;
		public function boss_defeated():void {
			_fadeout_to = new TopState();
			_fadeout = true;
			_fadeout_can_move = true;
		}
		
		public static var _freeze_frame:Number = 0;
		
		var _fade_cover:FlxSprite = new FlxSprite();
		var _fadeout:Boolean = false;
		var _fadein:Boolean = true;
		var _fadeout_to:FlxState;
		var _spin_out_ct:Number = 0;
		var _ct:Number = 0;
		
		function fadeout(f:FlxSprite) { if (f.alpha > 0) f.alpha -= 0.02; }
		
		public override function update():void {
			super.update();
			Mouse.hide();
			_bottom_game_ui._update(this);
			if (_spin_out_ct > 0) {
				_spin_out_ct--;
				if (_spin_out_ct <= 0) {
					FlxG.switchState(new ShopState());
				}
				fadeout(_fg);
				fadeout(_bg);
				_player._body.angle += 12.5;
				for each (var u:FlxSprite in _player_projectiles.members) fadeout(u);
				for each (var u:FlxSprite in _particles.members) fadeout(u);
				for each (var u:FlxSprite in _enemies.members) fadeout(u);
				for each (var u:FlxSprite in _pickups.members) fadeout(u);
				return;
				
			} else if (_fadein) {
				_fade_cover.alpha -= 0.05;
				if (_fade_cover.alpha <= 0) {
					_fade_cover.alpha = 0;
					_fadein = false;
				}
				return;
				
			} else if (_fadeout) {
				if (_fadeout_can_move) {
					_fade_cover.alpha += 0.002;
				} else {
					_fade_cover.alpha += 0.05;
				}
				
				if (_fade_cover.alpha >= 1) {
					_fade_cover.alpha = 1;
					_fadeout = false;
					GameStats._story++;
					FlxG.switchState(_fadeout_to);
				}
				if (!_fadeout_can_move) {
					return;
				}
			}
			
			if (_freeze_frame > 0) {
				_freeze_frame--;
				return;
			}
			_ct++;
			if (_ct % 250 == 0) {
				if (GameStats._health < GameStats._max_health) {
					GameStats._health = Math.min(GameStats._max_health, GameStats._health + GameStats._health_regen);
				}
			}
			
			GameWaves._update(this);
			if (GameStats._health <= 0) {
				FlxG.play(Resource.SFX_GAMEOVER);
				_spin_out_ct = 50;
				return;
			}

			_player._update(this);
			
			
			for each (var pproj:BasePlayerProjectile in _player_projectiles.members) {
				if (pproj.alive) {
					pproj._update(this);
					if (pproj._should_remove()) {
						pproj._do_remove();
					}
				}
			}
			
			for each (var enem:BaseEnemy in _enemies.members) {
				if (enem.alive) {
					enem._update(this);
					if (enem._should_kill() && enem._invuln_ct <= 0) {
						enem._do_kill(this);
					}
				}
			}
			
			for each (var part:BaseParticle in _particles.members) {
				if (part.alive) {
					part._update(this);
					if (part._should_remove()) {
						part._do_remove();
					}
				}
			}
			
			for each (var pick:BasePickup in _pickups.members) {
				if (pick.alive) {
					pick._update(this);
					if (pick._should_remove()) {
						pick._do_remove(this);
					}
				}
			}
			
			if (GameStats._just_used_energy_ct > 0) {
				GameStats._just_used_energy_ct--;
				
			} else if (GameStats._energy < GameStats._max_energy) {
				var pct:Number = GameStats._energy / GameStats._max_energy;
				if (pct < 0.2) {
					GameStats._energy = Math.min(GameStats._energy + 0.025 * GameStats._max_energy, GameStats._max_energy);
				} else if (pct < 0.4) {
					GameStats._energy = Math.min(GameStats._energy + 0.02 * GameStats._max_energy, GameStats._max_energy);
				} else if (pct < 0.7) {
					GameStats._energy = Math.min(GameStats._energy + 0.01 * GameStats._max_energy, GameStats._max_energy);
				} else {
					GameStats._energy = Math.min(GameStats._energy + 0.005 * GameStats._max_energy, GameStats._max_energy);
				}
			}
			
		}
		
	}

}