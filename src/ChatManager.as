package  {
	import flash.geom.Vector3D;
	import org.flixel.*;
	import particles.*;
	public class ChatManager extends FlxGroup {
		
		public static var m_top_0:Array = [
			{id:0, msg:"Hello class. Did everyone do the assigned reading?" },
			{id:0, msg:"Let's do attendance. Say present when called." },
			{id:0, msg:"Can someone read this passage for us?" },
			{id:0, msg:"There's going to be a quiz about this." },
			{id:0, msg:"Everyone please flip to chapter 2." },
			{id:0, msg:"Can anyone explain what the author meant here?" },
			{id:0, msg:"I hope you brought your textbooks today." },
			{id:0, msg:"Who's making that noise?" },
			
			{id:1, msg:"lol i farted" },
			{id:1, msg:"do you smell something?" },
			{id:1, msg:"Zzzz....Zzzz....Zzz....." },
			{id:1, msg:"pull my finger" },
			{id:1, msg:"i totally forgot to shower today" },
			{id:1, msg:"ive got tater tots in my pocket" },
			{id:1, msg:"hey man you got a tissue??" },
			{id:1, msg:"doorknob cherry!!!" },
			
			{id:2, msg:"420 blaze it smoke weed erryday" },
			{id:2, msg:"tupac lives" },
			{id:2, msg:"u can't get high off a plant its all natural" },
			{id:2, msg:"yo whaaaaaaaaaaaaaaat" },
			{id:2, msg:"LEGALIZE IT" },
			{id:2, msg:"hey mang pass da vape" },
			{id:2, msg:"hey hey hey hey...smoke weed every day" },
			{id:2, msg:"ne1 else really hungry right now too???" },
			
			{id:3, msg:"u wot m8?" },
			{id:3, msg:"do you even lift bro" },
			{id:3, msg:"gotta eat big to get big cmon" },
			{id:3, msg:"creatine ain't a drug" },
			{id:3, msg:"tfw no gf" },
			{id:3, msg:"do SS + GOMAD lel" },
			{id:3, msg:"scooby pls go" },
			{id:3, msg:"rip lyl she did nothing wrong" },
			{id:3, msg:"this cardio's killin my GAINS" }
		];
		
		public static var m_top_1:Array = [
			{id:0, msg:"Hello class. Did everyone do the assigned reading?" },
			{id:0, msg:"Let's do attendance. Say present when called." },
			{id:0, msg:"Can someone read this passage for us?" },
			{id:0, msg:"There's going to be a quiz about this." },
			{id:0, msg:"Everyone please flip to chapter 2." },
			{id:0, msg:"Can anyone explain to us what the author meant here?" },
			{id:0, msg:"I hope you brought your textbooks today." },
			{id:0, msg:"Who's making that noise?" },
			
			{id:2, msg:"420 blaze it smoke weed erryday" },
			{id:2, msg:"tupac lives" },
			{id:2, msg:"u can't get high off a plant its all natural" },
			{id:2, msg:"yo whaaaaaaaaaaaaaaat" },
			{id:2, msg:"LEGALIZE IT" },
			{id:2, msg:"hey mang pass da vape" },
			{id:2, msg:"hey hey hey hey...smoke weed every day" },
			{id:2, msg:"ne1 else really hungry right now too???" },
			
			{id:3, msg:"u wot m8?" },
			{id:3, msg:"do you even lift bro" },
			{id:3, msg:"gotta eat big to get big cmon" },
			{id:3, msg:"creatine ain't a drug" },
			{id:3, msg:"tfw no gf" },
			{id:3, msg:"do SS + GOMAD lel" },
			{id:3, msg:"scooby pls go" },
			{id:3, msg:"rip lyl she did nothing wrong" },
			{id:3, msg:"this cardio's killin my GAINS" }
		];
		
		public static var m_top_2:Array = [
			{id:0, msg:"Hello class. Did everyone do the assigned reading?" },
			{id:0, msg:"Let's do attendance. Say present when called." },
			{id:0, msg:"Can someone read this passage for us?" },
			{id:0, msg:"There's going to be a quiz about this." },
			{id:0, msg:"Everyone please flip to chapter 2." },
			{id:0, msg:"Can anyone explain to us what the author meant here?" },
			{id:0, msg:"I hope you brought your textbooks today." },
			{id:0, msg:"Who's making that noise?" },
			
			{id:3, msg:"u wot m8?" },
			{id:3, msg:"do you even lift bro" },
			{id:3, msg:"gotta eat big to get big cmon" },
			{id:3, msg:"creatine ain't a drug" },
			{id:3, msg:"tfw no gf" },
			{id:3, msg:"do SS + GOMAD lel" },
			{id:3, msg:"scooby pls go" },
			{id:3, msg:"rip lyl she did nothing wrong" },
			{id:3, msg:"this cardio's killin my GAINS" }
		];
		
		public static var m_boss_0:Array = [
			{id:1, msg:"oh man i really gotta go to the bathroom" },
			{id:1, msg:"lol i farted" },
			{id:1, msg:"do you smell something?" },
			{id:1, msg:"Zzzz....Zzzz....Zzz....." },
			{id:1, msg:"pull my finger" },
			{id:1, msg:"i totally forgot to shower today" },
			{id:1, msg:"ive got tater tots in my pocket" },
			{id:1, msg:"hey man you got a tissue??" },
			{id:1, msg:"doorknob cherry!!!" }
		];
		
		public static var m_boss_1:Array = [
			{id:2, msg:"hey mang hapy 420 jus b urself" },
			{id:2, msg:"420 blaze it smoke weed erryday" },
			{id:2, msg:"tupac lives" },
			{id:2, msg:"u can't get high off a plant its all natural" },
			{id:2, msg:"yo whaaaaaaaaaaaaaaat" },
			{id:2, msg:"LEGALIZE IT" },
			{id:2, msg:"hey mang pass da vape" },
			{id:2, msg:"hey hey hey hey...smoke weed every day" },
			{id:2, msg:"ne1 else really hungry right now too???" }
		];
		
		public static var m_boss_2:Array = [
			{id:3, msg:"u preparing 4 a trip to snap city LEL CROSSFIT" },
			{id:3, msg:"u wot m8?" },
			{id:3, msg:"do you even lift bro" },
			{id:3, msg:"gotta eat big to get big cmon" },
			{id:3, msg:"creatine ain't a drug" },
			{id:3, msg:"tfw no gf" },
			{id:3, msg:"do SS + GOMAD lel" },
			{id:3, msg:"scooby pls go" },
			{id:3, msg:"rip lyl she did nothing wrong" },
			{id:3, msg:"this cardio's killin my GAINS" }
		];
		
		public static var _inst:ChatManager = new ChatManager();
		
		public var _teacher_sprite:FlxSprite = new FlxSprite(0,354);
		public var _snakeboss_sprite:FlxSprite = new FlxSprite(0,354);
		public var _spider_sprite:FlxSprite = new FlxSprite(0, 354);
		public var _fireboss_sprite:FlxSprite = new FlxSprite(0,354);
		
		var _text:FlxText;
		var _text_scroll:ScrollText;
		
		public var _cur_sprite:FlxSprite;
		var _chat_cover:FlxSprite = new FlxSprite(0, 500 - 30, Resource.CHAT_COVER);
		public function ChatManager() {
			this.add(_chat_cover);
			
			_teacher_sprite.loadGraphic(Resource.CHAT_TEACHER_SS, true, false, 120, 146);
			_teacher_sprite.addAnimation("chat", [0, 1], 10);
			_teacher_sprite.play("chat");
			_teacher_sprite.alpha = 0.8;
			
			_fireboss_sprite.loadGraphic(Resource.CHAT_FIREBOSS_SS, true, false, 120, 146);
			_fireboss_sprite.addAnimation("chat", [0, 1], 10);
			_fireboss_sprite.addAnimation("chat_angry", [2, 3], 10);
			_fireboss_sprite.play("chat");
			_fireboss_sprite.alpha = 0.8;
			
			_snakeboss_sprite.loadGraphic(Resource.CHAT_SNAKEBOSS_SS, true, false, 120, 146);
			_snakeboss_sprite.addAnimation("chat", [0, 1], 10);
			_snakeboss_sprite.addAnimation("chat_angry", [2, 3], 10);
			_snakeboss_sprite.play("chat");
			_snakeboss_sprite.alpha = 0.8;
			
			_spider_sprite.loadGraphic(Resource.CHAT_SPIDERBOSS_SS, true, false, 120, 146);
			_spider_sprite.addAnimation("chat", [0, 1], 10);
			_spider_sprite.addAnimation("chat_angry", [2, 3],10);
			_spider_sprite.play("chat");
			_spider_sprite.alpha = 0.8;
			
			_text = Util.cons_text(125, 473, "", 0xFFFFFF, 20, 1000);
			this.add(_text);
			
			_text_scroll = new ScrollText(_text, "", 5);
			_cur_sprite = _teacher_sprite;
			this.add(_cur_sprite);
		}
		
		var _has_set_angry:Boolean = false;
		public function set_angry():void {
			if (!_has_set_angry) {
				_fireboss_sprite.play("chat_angry");
				_snakeboss_sprite.play("chat_angry");
				_spider_sprite.play("chat_angry");
			}
		}
		
		var _chat_cover_vis_mlt:Number = 1;
		public function show_back(t:Boolean):void {
			if (t) {
				_chat_cover_vis_mlt = 1;
				_text.x = 125;
				_text.y = 473;
			} else {
				_chat_cover_vis_mlt = 0;
				_text.x = 105;
				_text.y = 453;
			}
			_text_scroll.load("");
			_update();
		}
		
		public var _spd:Number = 100;
		var _use_messages:Array;
		var _ct:Number = 0;
		public function _update():void {
			if (_use_messages == null) pick_message_set(m_top_0);
			if (_text_scroll.finished()) {
				_ct--;
				if (_ct <= 60) {
					_cur_sprite.alpha -= 0.1;
					_chat_cover.alpha -= 0.1;
					_text.alpha -= 0.1;
					_chat_cover.alpha *= _chat_cover_vis_mlt;
					if (_ct <= 0) {
						pick_new_message(_use_messages);
					}
				}
			} else {
				_cur_sprite.alpha = 1;
				_chat_cover.alpha = 1;
				_text.alpha = 1;
				_ct = _spd + Util.float_random(-50,50);
				_text_scroll._update();
				_chat_cover.alpha *= _chat_cover_vis_mlt;
			}
		}
		
		public function pick_message_set(msg:Array) {
			_use_messages = msg;
			pick_new_message(msg, 0);
		}
		
		public function pick_new_message(msg:Array, ct:Number = -1) {
			var tar;
			if (ct == -1) {
				tar = msg[Math.floor(Math.random() * msg.length)];
			} else {
				tar = msg[ct];
			}
			_text_scroll.load(tar.msg);
			this.remove(_cur_sprite);
			_cur_sprite = [_teacher_sprite, _snakeboss_sprite, _spider_sprite, _fireboss_sprite][tar.id];
			this.add(_cur_sprite);
		}
		
	}

}