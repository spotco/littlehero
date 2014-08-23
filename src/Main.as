package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import org.flixel.FlxGame;
	
	[SWF(frameRate = "60", width = "1000", height = "500")]
	
	public class Main extends FlxGame {
		
		public function Main():void {
			super(1000, 500, BottomGame);
		}
		
	}
	
}