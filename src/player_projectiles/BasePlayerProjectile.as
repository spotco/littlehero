package player_projectiles {
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;

	public class BasePlayerProjectile extends FlxSprite {
		
		public function _update(g:BottomGame):void { }
		public function _should_remove():Boolean { return true; }
		public function _do_remove():void { }
		
	}

}