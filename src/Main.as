package 
{
	import flash.display.*;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import org.flixel.*;
	import flash.ui.*;
	import flash.events.*;
	
	[SWF(frameRate = "60", width = "1000", height = "500", backgroundColor="#000000")]
	[Frame(factoryClass = "Preloader")]
	/*
	 */
	
	public class Main extends FlxGame{
		
		public static var BOSS_1_HEALTH:Boolean = false;
		public static var self:Main;
		public static var _topcover:Sprite = new Sprite(), _bottomcover:Sprite = new Sprite();
		
		
		public function Main():void {
			super(1000,500,TopState);
			self = this;
			
			this.useSoundHotKeys = false;
			
			this.addEventListener(Event.ADDED_TO_STAGE, function() {
				stage.addEventListener(KeyboardEvent.KEY_UP, function(e:KeyboardEvent) {
					if (e.keyCode == 112) {
						Main.fullscreen_mode();
					} else if (e.keyCode == 77) {
						Util.mute_toggle();
					}
				});
				stage.addChild(_topcover);
				stage.addChild(_bottomcover);
			})
		}
		
        private static function toggle_fullscreen(ForceDisplayState:String=null):void {
            if (ForceDisplayState) {
                FlxG.stage.displayState = ForceDisplayState;
            } else {
                if (FlxG.stage.displayState == StageDisplayState.NORMAL) {
                    FlxG.stage.displayState = StageDisplayState.FULL_SCREEN;
                } else {
                    FlxG.stage.displayState = StageDisplayState.NORMAL;
                }
            }
            window_resized();
        }
        private static function window_resized(e:Event = null):void {
            FlxG.width = FlxG.stage.stageWidth / FlxCamera.defaultZoom;
            FlxG.height = FlxG.stage.stageHeight / FlxCamera.defaultZoom;

            FlxG.resetCameras(new FlxCamera(0, 0, FlxG.width, FlxG.height));
			var tar_scale:Number = FlxG.stage.stageWidth / 1000; 
			var size_y:Number = 500 * tar_scale;
			Main.self.scaleX = tar_scale;
			Main.self.scaleY = tar_scale;
			Main.self.y = (FlxG.stage.stageHeight - size_y) / 2;
			
			_topcover.graphics.clear();
			_bottomcover.graphics.clear();
			
			_topcover.graphics.beginFill(0x000000);
			_topcover.graphics.drawRect(0, 0, FlxG.stage.stageWidth, Main.self.y);
			_topcover.graphics.endFill();
			
			_bottomcover.graphics.beginFill(0x000000);
			_bottomcover.graphics.drawRect(0, Main.self.y + 500 * tar_scale, FlxG.stage.stageWidth, FlxG.stage.stageHeight - (Main.self.y + 500 * tar_scale));
			_bottomcover.graphics.endFill();
        }
		
		public static function fullscreen_mode():void {
			toggle_fullscreen(StageDisplayState.FULL_SCREEN_INTERACTIVE);
            FlxG.stage.addEventListener(Event.RESIZE, window_resized);
		}

		
		
	}
	
}