package gameControl {
	import gameSound.SoundManager;
	import gameUI.*;
	import gameGraphics.*;
	import flash.net.LocalConnection;
	
	public class Globals {
		// Static vars that reference instances.
		public static var soundManager:SoundManager;
		public static var UI:Interface;
		public static var menus:Menus;
		public static var airport:AirportG;
		public static var infoBox:InfoBox;
		public static var conn:LocalConnection;
	}
}