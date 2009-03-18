package gameData
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.xml.*;
	

	public class XMLgameData extends MovieClip
	{
		public static var loader:URLLoader=new URLLoader();
		protected static var ready:Boolean = false;
		protected static var gameValues:XML = new XML();
			
		public function XMLgameData()
		{
			this.loadXML();
		}
		
		private function loadXML():void
		{
			
			loader.addEventListener(Event.COMPLETE,completeHandler);
		
			var request:URLRequest=new URLRequest('gameData/gameLevels.xml');
			try 
			{
				loader.load(request);
			} 
			catch(error:Error) 
			{
				trace('Unable to load requested document.');
			}
		}
		
		private function completeHandler(e:Event):void
		{
			ready = true;
			trace("Data Loaded Successfully");
			trace(ready);
			
			
			XML.ignoreWhitespace = true; 
			var gameLevels:XML = new XML(e.target.data);
			
			gameValues = gameLevels;
		}
		
		public function getLevel(level:uint, attName:String):Array //Um, maybe we should return an array? Just saying
		{
			//return(this.ready);
			var Response:Array = new Array();
			
			switch (attName) {
				case "budget":
					Response.push(gameValues.game.(@level == level).budget.text());
					break;
					
				case "passengers":
					Response.push(gameValues.game.(@level == level).passengers.text());
					break;
					
				case "violationChance":
					Response.push(gameValues.game.(@level == level).violationChance.text());
					break;
				
				case "minViolations":
					Response.push(gameValues.game.(@level == level).minViolations.text());
					break;
				
				case "securityAlert":
					Response.push(gameValues.game.(@level == level).securityAlert.text());
					break;
				
				case "offenses":
					for each (var offense:String in gameValues.game.(@level == level).offenses.offense) {
						Response.push(offense);
					}
					break;

				case "items": 
					for each (var item:String in gameValues.game.(@level == level).items.item) {
						Response.push(item);
					}
					break;
			}//end of switch
			return(Response);
		}
	}
}
