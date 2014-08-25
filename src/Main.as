package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import org.flixel.FlxGame;
	import flash.ui.*;
	import flash.events.MouseEvent;
	
	[SWF(frameRate = "60", width = "1000", height = "500", backgroundColor="#000000")]
	/*
	 TODO:
		 knockback and into wall
		 sweat when not enough energy
		 enemy hit player with knockback
		 health
		 screenshake and pause
		 
		 spider enemy
		 enemy 3
		 
		 top/bottom alternate
		 top dialogues
		 top shop
	 */
	
	public class Main extends FlxGame {
		
		public function Main():void {
			super(1000, 500, ShopState);
			//super(1000, 500, BottomGame);
			//super(1000, 500, TopState);
			
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, function(e:Event):void {
				Util.set_right_mouse_down(true);
			});
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, function(e:Event):void {
				Util.set_right_mouse_down(false);
			});
		}
		
	}
	
}