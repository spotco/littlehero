package  
{
	import enemy.BaseEnemy;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.FlxText;
	
	public class BottomGameUI extends FlxGroup{
		
		var _boss_bar:FlxSprite = new FlxSprite();
		var _boss_text:FlxText;
		
		var _energy_bar:FlxSprite = new FlxSprite();
		var _health_bar:FlxSprite = new FlxSprite();
		var _wave_text:FlxText;
		var _wave_ct_text:FlxText;
		
		var _red_overlay:FlxSprite = new FlxSprite(0, 0, Resource.RED_OVERLAY);
		
		var _gold_text:FlxText = Util.cons_text(2, 40, "GOLD: 0", 0xFFFFFF, 12);
		
		public function BottomGameUI() {
			_health_bar.loadGraphic(Resource.HEARTS_FULL);
			_health_bar.x = -55;
			_health_bar.y = 0;
			_health_bar.set_scale(0.75);
			this.health_bar_pct(1);
			this.add(_health_bar);//16
			
			_energy_bar.loadGraphic(Resource.ENERGY_BAR_GREEN);
			_energy_bar.set_scale(0.75);
			_energy_bar.x = -8 * 0.75;
			_energy_bar.y = 30 * 0.75;
			this.add(_energy_bar);
			energy_bar_pct(1);
			
			this.add(Util.cons_text(2, 24, "ENG:",0xFFFFFF,12));
			this.add(_gold_text);
			
			_wave_text = Util.cons_text(0, 0, "WAVE: 0", 0xFFFFFF, 20);
			_wave_text.alignment = "right";
			this.add(_wave_text);
			
			_wave_ct_text = Util.cons_text(0, 25, "NEXT: 0", 0xFFFFFF, 14);
			_wave_ct_text.alignment = "right";
			this.add(_wave_ct_text);
			
			
			_boss_bar.loadGraphic(Resource.BOSS_BAR_EMPTY);
			_boss_bar.y = 480;
			this.add(_boss_bar);
			
			_boss_text = Util.cons_text(0, 455, "Boss", 0xFFFFFF, 20);
			_boss_text.alpha = 0;
			this.add(_boss_text);
			this.boss_bar_pct(0);
			
			_red_overlay.alpha = 0;
			this.add(_red_overlay);
		}
		
		var _boss_in_bar_anim:Number = 0;
		var _track_boss:BaseEnemy = null;
		public function track_boss(enem:BaseEnemy):void {
			_boss_text.alpha = 1;
			_track_boss = enem;
			_boss_in_bar_anim = 0;
		}
		
		var _last_health:Number = 0;
		public function _update(g:BottomGame):void {
			this.energy_bar_pct(GameStats._energy / GameStats._max_energy);
			this.health_bar_pct(GameStats._health / GameStats._max_health);
			this._gold_text.text = "GOLD: " + GameStats._gold;
			_wave_text.text = "WAVE: " + GameWaves._wave;
			_wave_ct_text.text = "NEXT: " + GameWaves._ct;
			_wave_ct_text.alpha = (GameWaves._ct < 0 ? 0:1);
			
			_red_overlay.alpha *= 0.95;
			if (GameStats._health < _last_health) {
				_red_overlay.alpha = 1;
			}
			_last_health = GameStats._health;
			
			if (_track_boss != null) {
				if (_boss_in_bar_anim < 1) {
					_boss_in_bar_anim += 0.01;
					this.boss_bar_pct(_boss_in_bar_anim);
				} else {
					this.boss_bar_pct(_track_boss._health / _track_boss._max_health);
				}
			} else {
				this.boss_bar_pct(0);
			}
		}
		
		private static var BOSS_BAR_RED:FlxSprite = new FlxSprite(0, 0, Resource.BOSS_BAR_RED);
		private static var BOSS_BAR_EMPTY:FlxSprite = new FlxSprite(0, 0, Resource.BOSS_BAR_EMPTY);
		var _boss_bar_pct:Number = 0;
		private function boss_bar_pct(pct:Number):void {
			if (pct != _boss_bar_pct) {
				var tar:FlxSprite = BOSS_BAR_RED;
				_boss_bar.framePixels.copyPixels(
					tar.framePixels,
					new Rectangle(0, 0, tar.width-1, tar.height),
					new Point(0, 0)
				);
				_boss_bar.framePixels.copyPixels(
					BOSS_BAR_EMPTY.framePixels, 
					new Rectangle(tar.width * pct, 0, tar.width - tar.width * pct, tar.height), 
					new Point(tar.width * pct, 0)
				);
				_boss_bar_pct = pct;
			}
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
					new Rectangle(0, 0, tar.width-1, tar.height),
					new Point(0, 0)
				);
				_energy_bar.framePixels.copyPixels(
					ENERGY_BAR_EMPTY.framePixels, 
					new Rectangle(tar.width * pct, 0, tar.width - tar.width * pct, tar.height), 
					new Point(tar.width * pct, 0)
				);
				_energy_bar_pct = pct;
			}
			
		}
		
		private static var HEALTH_BAR_EMPTY:FlxSprite = new FlxSprite(0, 0, Resource.HEARTS_EMPTY);
		private static var HEALTH_BAR_FULL:FlxSprite = new FlxSprite(0, 0, Resource.HEARTS_FULL);
		var _health_bar_pct:Number = 1;
		private function health_bar_pct(pct:Number) {
			if (pct != _health_bar_pct) {
				var tar:FlxSprite = HEALTH_BAR_FULL;
				_health_bar.framePixels.copyPixels(
					tar.framePixels,
					new Rectangle(0, 0, tar.width, tar.height),
					new Point(0, 0)
				);
				tar = HEALTH_BAR_EMPTY;
				_health_bar.framePixels.copyPixels(
					tar.framePixels,
					new Rectangle(tar.width * pct, 0, tar.width - tar.width * pct, tar.height),
					new Point(tar.width*pct,0)
				);
				_health_bar_pct = pct;
			}
		}
		
		
		
	}

}