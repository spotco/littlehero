package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import org.flixel.FlxGame;
	import flash.ui.*;
	import flash.events.MouseEvent;
	
	[SWF(frameRate = "60", width = "1000", height = "500", backgroundColor="#000000")]
	/*
	 */
	
	public class Main extends FlxGame {
		
		public static var BOSS_1_HEALTH:Boolean = false;
		
		public function Main():void {
			//super(1000, 500, ShopState);
			super(1000, 500, BottomGame);
			//super(1000, 500, TopState);
			//super(1000, 500, GameEndState);
			
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, function(e:Event):void {
				Util.set_right_mouse_down(true);
			});
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, function(e:Event):void {
				Util.set_right_mouse_down(false);
			});
		}
		
	}
	
}