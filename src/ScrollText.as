package  {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import particles.*;
	public class ScrollText {
		
		var _text:FlxText;
		var _words:String;
		var _buf:String = "";
		var _ct:Number = 0;
		var _spd:Number = 0;
		public function ScrollText(text:FlxText, words:String = "test", spd:Number = 5) {
			_text = text;
			_words = words;
			_spd = spd;
			_text.text = _buf;
		}
		
		public function load(words:String, spd:Number = 5) {
			_buf = "";
			_ct = 0;
			_spd = spd;
			_text.text = _buf;
			_words = words;
		}
		
		public function _update():void {
			_ct++;
			if (_ct >= _spd) {
				_ct = 0;
				if (_words.length > _buf.length) {
					_buf += _words.charAt(_buf.length);
				}
				_text.text = _buf;
			}
		}
		
		public function finished():Boolean {
			return _buf.length == _words.length;
		}
		
	}

}