package {
	import org.flixel.*;
	import player_projectiles.*;
	public class BottomGame extends FlxState{
		
		public var _player:Player = new Player();;
		public var _player_projectiles:FlxGroup = new FlxGroup();
		public var _enemies:FlxGroup = new FlxGroup();
		
		public override function create():void {
			var bg:FlxSprite = new FlxSprite(0, 0, Resource.BOTTOM_BG);
			this.add(bg);
			
			this.add(_player);
			
			var fg:FlxSprite = new FlxSprite(0, 0, Resource.BOTTOM_FG);
			this.add(fg);
		}
		
		public override function update():void {
			
			_player._update(this);
			
			if (FlxG.mouse.justPressed()) {
				this.add(SwordPlayerProjectile.cons(_player_projectiles).init(_player));
			}
			
			for each (var pproj:BasePlayerProjectile in _player_projectiles.members) {
				if (pproj.alive) {
					pproj._update();
					if (pproj._should_remove()) {
						pproj._do_remove();
					}
				}
			}
			
			
			
		}
		
	}

}