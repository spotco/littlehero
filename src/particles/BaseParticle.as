package particles {
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	
	public class BaseParticle extends FlxSprite {
		public function _update(g:BottomGame):void { }
		public function _should_remove():Boolean { return false; }
		public function _do_remove():void { }
	}

}