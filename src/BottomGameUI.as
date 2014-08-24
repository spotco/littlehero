package  
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class BottomGameUI extends FlxGroup{
		
		var _energy_bar:FlxSprite = new FlxSprite();
		
		public function BottomGameUI() {
			_energy_bar.loadGraphic(Resource.ENERGY_BAR_GREEN);
			_energy_bar.y = Util.HEI - _energy_bar.frameHeight;
			this.add(_energy_bar);
			energy_bar_pct(1);
		}
		
		public function _update(g:BottomGame):void {
			this.energy_bar_pct(GameStats._energy / GameStats._max_energy);
		}
		
		private static var ENERGY_BAR_GREEN:FlxSprite = new FlxSprite(0, 0, Resource.ENERGY_BAR_GREEN);
		private static var ENERGY_BAR_YELLOW:FlxSprite = new FlxSprite(0, 0, Resource.ENERGY_BAR_YELLOW);
		private static var ENERGY_BAR_RED:FlxSprite = new FlxSprite(0, 0, Resource.ENERGY_BAR_RED);
		
		private static var ENERGY_BAR_EMPTY:FlxSprite = new FlxSprite(0, 0, Resource.ENERGY_BAR_EMPTY);
		var _energy_bar_pct:Number = 1;
		private function energy_bar_pct(pct:Number):void {
			if (pct != _energy_bar_pct) {
				var tar:FlxSprite;
				if (pct < 0.2) {
					tar = ENERGY_BAR_RED;
				} else if (pct < 0.5) {
					tar = ENERGY_BAR_YELLOW;
				} else {
					tar = ENERGY_BAR_GREEN;
				}
				_energy_bar.framePixels.copyPixels(
					tar.framePixels,
					new Rectangle(0, 0, tar.width, tar.height),
					new Point(0, 0)
				);
				_energy_bar.framePixels.copyPixels(
					ENERGY_BAR_EMPTY.framePixels, 
					new Rectangle(ENERGY_BAR_EMPTY.width * pct, 0, ENERGY_BAR_EMPTY.width - ENERGY_BAR_EMPTY.width * pct, ENERGY_BAR_EMPTY.height), 
					new Point(ENERGY_BAR_EMPTY.width * pct, 0)
				);
				_energy_bar_pct = pct;
			}
			
		}
		
	}

}