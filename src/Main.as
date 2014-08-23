package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import org.flixel.FlxGame;
	import flash.ui.*;
	import flash.events.MouseEvent;
	
	[SWF(frameRate = "60", width = "1000", height = "500")]
	
	public class Main extends FlxGame {
		
		public function Main():void {
			super(1000, 500, BottomGame);
			
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, function(e:Event) {
				Util.set_right_mouse_down(true);
			});
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, function(e:Event) {
				Util.set_right_mouse_down(false);
			});
		}
		
	}
	
}