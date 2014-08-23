package {
	import flash.geom.Vector3D;
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
			
			SwordPlayerProjectile.cons(_player_projectiles).init(_player);
			
			
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
			
			if (FlxG.mouse.justPressed()) {
				var dv:Vector3D = new Vector3D(FlxG.mouse.x - _player.get_center().x, FlxG.mouse.y - _player.get_center().y);
				dv.normalize();
				dv.scaleBy(7);
				ArrowPlayerProjectile.cons(_player_projectiles).init(_player.get_center().x, _player.get_center().y, dv.x, dv.y);
			}
			
		}
		
	}

}