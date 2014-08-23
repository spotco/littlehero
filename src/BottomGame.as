package {
	import org.flixel.*;
	import player_projectiles.*;
	import enemy.*;
	public class BottomGame extends FlxState{
		
		public var _player:Player = new Player();
		public var _player_projectiles:FlxGroup = new FlxGroup();
		public var _enemies:FlxGroup = new FlxGroup();
		
		public override function create():void {
			var bg:FlxSprite = new FlxSprite(0, 0, Resource.BOTTOM_BG);
			this.add(bg);
			
			this.add(_player);
			this.add(_enemies);
			this.add(_player_projectiles);
			
			var fg:FlxSprite = new FlxSprite(0, 0, Resource.BOTTOM_FG);
			this.add(fg);
			
			TinySpiderEnemy.cons(_enemies).init(200, 200);
			TinySpiderEnemy.cons(_enemies).init(800, 200);
			TinySpiderEnemy.cons(_enemies).init(400, 400);
			TinySpiderEnemy.cons(_enemies).init(600, 300);
		}
		
		public override function update():void {
			
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
					if (enem._should_remove()) {
						enem._do_remove();
					}
				}
			}
			
			/*
			FlxG.overlap(_player_projectiles, _enemies, function(pproj:BasePlayerProjectile, enem:BaseEnemy):void {
				if (enem._invuln_ct <= 0) {
					enem.hit(enem.x - _player.get_center().x, enem.y - _player.get_center().y, 50);
				}
			});
			*/
			
		}
		
	}

}