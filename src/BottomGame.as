package {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import player_projectiles.*;
	import enemy.*;
	import particles.*;
	import pickups.*;
	
	public class BottomGame extends FlxState{
		
		public var _player:Player = new Player();
		public var _player_projectiles:FlxGroup = new FlxGroup();
		public var _enemies:FlxGroup = new FlxGroup();
		public var _particles:FlxGroup = new FlxGroup();
		public var _healthbars:FlxGroup = new FlxGroup();
		public var _pickups:FlxGroup = new FlxGroup();
		public var _hitboxes:FlxGroup = new FlxGroup();
		
		public var _bottom_game_ui:BottomGameUI = new BottomGameUI();
		
		public override function create():void {
			this.add(new FlxSprite(0, 0, Resource.BOTTOM_BG));
			this.add(_pickups);
			this.add(_player);
			this.add(_enemies);
			this.add(_player_projectiles);
			this.add(_particles);
			this.add(new FlxSprite(0, 0, Resource.BOTTOM_FG));
			this.add(_bottom_game_ui);
			this.add(_healthbars);
			
			//this.add(_hitboxes);
			
			_player._sword = SwordPlayerProjectile.cons(_player_projectiles).init(_player,this);
			CrossBowPlayerProjectile.cons(_player_projectiles).init(_player);
			
			TinySpiderEnemy.cons(_enemies).init(200, 200, this);
			TinySpiderEnemy.cons(_enemies).init(800, 200, this);
			TinySpiderEnemy.cons(_enemies).init(400, 400, this);
			TinySpiderEnemy.cons(_enemies).init(600, 300, this);
			
			TinySpiderEnemy.cons(_enemies).init(600, 300, this);
			TinySpiderEnemy.cons(_enemies).init(600, 300, this);
			TinySpiderEnemy.cons(_enemies).init(600, 300, this);
			TinySpiderEnemy.cons(_enemies).init(600, 300, this);
			
			JellyEnemy.cons(_enemies).init(200, 200, this);
			BulletEnemy.cons(_enemies).init(700, 300,0,0,99999, this);
			
			_player._arrowretic = ArrowReticuleUIParticle.cons(_particles).init(_player, true);
			ArrowReticuleUIParticle.cons(_particles).init(_player, false);
			SweatParticle.cons(_particles);
		}
		
		public static var _freeze_frame:Number = 0;
		
		public override function update():void {
			super.update();
			if (_freeze_frame > 0) {
				_freeze_frame--;
				return;
			}

			_player._update(this);
			_bottom_game_ui._update(this);
			
			
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