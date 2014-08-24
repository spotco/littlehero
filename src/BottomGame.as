package {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import player_projectiles.*;
	import enemy.*;
	import particles.*;
	public class BottomGame extends FlxState{
		
		public var _player:Player = new Player();
		public var _player_projectiles:FlxGroup = new FlxGroup();
		public var _enemies:FlxGroup = new FlxGroup();
		public var _particles:FlxGroup = new FlxGroup();
		
		public var _bottom_game_ui:BottomGameUI = new BottomGameUI();
		
		public override function create():void {
			this.add(new FlxSprite(0, 0, Resource.BOTTOM_BG));
			this.add(_player);
			this.add(_enemies);
			this.add(_player_projectiles);
			this.add(_particles);
			this.add(new FlxSprite(0, 0, Resource.BOTTOM_FG));
			this.add(_bottom_game_ui);
			
			
			SwordPlayerProjectile.cons(_player_projectiles).init(_player);
			CrossBowPlayerProjectile.cons(_player_projectiles).init(_player);
			
			TinySpiderEnemy.cons(_enemies).init(200, 200);
			TinySpiderEnemy.cons(_enemies).init(800, 200);
			TinySpiderEnemy.cons(_enemies).init(400, 400);
			TinySpiderEnemy.cons(_enemies).init(600, 300);
			
			_player._arrowretic = ArrowReticuleUIParticle.cons(_particles).init(_player, true);
			ArrowReticuleUIParticle.cons(_particles).init(_player, false);
		}
		
		public override function update():void {
			
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
					if (enem._should_remove()) {
						enem._do_remove();
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
			
			if (GameStats._just_used_energy_ct > 0) {
				GameStats._just_used_energy_ct--;
				
			} else if (GameStats._energy < GameStats._max_energy) {
				GameStats._energy = Math.min(GameStats._energy + 0.2, GameStats._max_energy);
			}
			
		}
		
	}

}