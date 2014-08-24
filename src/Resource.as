package {
	import flash.display.Bitmap;
    import flash.utils.ByteArray;
	import flash.media.Sound;
	public class Resource {
		
		[Embed(source = "../resc/bottom_bg/bg.png")] public static var BOTTOM_BG:Class;
		[Embed(source = "../resc/bottom_bg/fg.png")] public static var BOTTOM_FG:Class;
		
		[Embed(source = "../resc/bottom_player/player_ss.png")] public static var PLAYER_SS:Class;
		
		[Embed(source = "../resc/bottom_item/crossbow.png")] public static var CROSSBOW:Class;
		[Embed(source = "../resc/bottom_item/sword.png")] public static var SWORD:Class;
		[Embed(source = "../resc/bottom_item/sword_hitbox.png")] public static var SWORD_HITBOX:Class;
		[Embed(source = "../resc/bottom_item/arrow_hitbox.png")] public static var ARROW_HITBOX:Class;
		[Embed(source = "../resc/bottom_item/arrow.png")] public static var ARROW:Class;
		[Embed(source = "../resc/bottom_item/gold.png")] public static var GOLD:Class;
		
		[Embed(source = "../resc/bottom_ui/hearts_empty.png")] public static var HEARTS_EMPTY:Class;
		[Embed(source = "../resc/bottom_ui/hearts_full.png")] public static var HEARTS_FULL:Class;
		
		[Embed(source = "../resc/bottom_ui/arrow_reticule.png")] public static var ARROW_RETICULE:Class;
		[Embed(source = "../resc/bottom_ui/energy_bar_green.png")] public static var ENERGY_BAR_GREEN:Class;
		[Embed(source = "../resc/bottom_ui/energy_bar_yellow.png")] public static var ENERGY_BAR_YELLOW:Class;
		[Embed(source = "../resc/bottom_ui/energy_bar_red.png")] public static var ENERGY_BAR_RED:Class;
		[Embed(source = "../resc/bottom_ui/energy_bar_empty.png")] public static var ENERGY_BAR_EMPTY:Class;
		
		[Embed(source = "../resc/bottom_enemy/eyeder_ss.png")] public static var EYEDER_SS:Class;
		[Embed(source = "../resc/bottom_enemy/eyeder_hitbox.png")] public static var EYEDER_HITBOX:Class;
		[Embed(source = "../resc/bottom_enemy/blob_ss.png")] public static var BLOB_SS:Class;
		[Embed(source = "../resc/bottom_enemy/blob_hitbox.png")] public static var BLOB_HITBOX:Class;
		[Embed(source = "../resc/bottom_enemy/bullet.png")] public static var BULLET:Class;
		
		[Embed(source = "../resc/bottom_fx/explosion.png")] public static var EXPLOSION:Class;
		[Embed(source = "../resc/bottom_fx/sweat_ss.png")] public static var SWEAT_SS:Class;
		
		[Embed(source = "../resc/top_bg/bg.png")] public static var TOP_BG:Class;
		[Embed(source = "../resc/top_bg/bully_center.png")] public static var TOP_BULLY_CENTER:Class;
		[Embed(source = "../resc/top_bg/bully_left.png")] public static var TOP_BULLY_LEFT:Class;
		[Embed(source = "../resc/top_bg/bully_right.png")] public static var TOP_BULLY_RIGHT:Class;
		[Embed(source = "../resc/top_bg/player.png")] public static var TOP_PLAYER:Class;
		[Embed(source = "../resc/top_bg/teacher.png")] public static var TOP_TEACHER:Class;
	}

}