package {
	import flash.display.Bitmap;
    import flash.utils.ByteArray;
	import flash.media.Sound;
	public class Resource {
		
		[Embed(source = "../resc/bottom_bg/bg.png")] public static var BOTTOM_BG:Class;
		[Embed(source = "../resc/bottom_bg/fg.png")] public static var BOTTOM_FG:Class;
		
		[Embed(source = "../resc/bottom_player/player.png")] public static var PLAYER:Class;
		
		[Embed(source = "../resc/bottom_item/crossbow.png")] public static var CROSSBOW:Class;
		[Embed(source = "../resc/bottom_item/sword.png")] public static var SWORD:Class;
		
		[Embed(source = "../resc/bottom_ui/arrow_reticule.png")] public static var ARROW_RETICULE:Class;
		
		[Embed(source = "../resc/bottom_enemy/spider.png")] public static var SPIDER:Class;
	}

}