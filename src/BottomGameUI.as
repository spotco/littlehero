package  
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.FlxText;
	
	public class BottomGameUI extends FlxGroup{
		
		var _energy_bar:FlxSprite = new FlxSprite();
		
		var _hp_text:FlxText = Util.cons_text(0, 3, "HP: 0/0", 0xFFFFFF, 35);
		var _gold_text:FlxText = Util.cons_text(0, 50, "Gold: 0", 0xFFFFFF, 14);
		
		public function BottomGameUI() {
			_energy_bar.loadGraphic(Resource.ENERGY_BAR_GREEN);
			_energy_bar.y = Util.HEI - _energy_bar.frameHeight;
			this.add(_energy_bar);
			energy_bar_pct(1);
			
			this.add(Util.cons_text(0, Util.HEI - 35, "Energy"));
			this.add(_gold_text);
			this.add(_hp_text);
		}
		
		public function _update(g:BottomGame):void {
			this.energy_bar_pct(GameStats._energy / GameStats._max_energy);
			this._hp_text.text = "HP: " + GameStats._health + "/" + GameStats._max_health;
			this._gold_text.text = "Gold: " + GameStats._gold;
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