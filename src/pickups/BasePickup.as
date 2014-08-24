package pickups {
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	public class BasePickup extends FlxSprite{
		public function _update(g:BottomGame):void { }
		public function _should_remove():Boolean { return false; }
		public function _do_remove(g:BottomGame):void { }
		
	}

}