package gameData
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.xml.*;
	

	public class XMLmachineData extends MovieClip
	{
		public static var loader:URLLoader=new URLLoader();
		protected static var ready:Boolean = false;
		protected static var machineValues:XML = new XML();
			
		public function XMLmachineData()
		{
			this.loadXML();
		}
		
		private function loadXML():void
		{
			
			loader.addEventListener(Event.COMPLETE,completeHandler);
		
			var request:URLRequest=new URLRequest('gameData/machines.xml');
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
			var securityCheckUnits:XML = new XML(e.target.data);
			
			machineValues = securityCheckUnits;
		}
		
		public static function getXML(chkPnt:String, attName:String, AcuLevel:String = "1", pwrUp:String = ""):String
		{
			//return(this.ready);
			var Response:String = "error";
			
			switch (attName){
				
				case "accuracy":
					Response = machineValues.unit.(@name == chkPnt).(@level == AcuLevel).accuracy.text();
					break;
				
				case "speed":
					Response = machineValues.unit.(@name == chkPnt).(@level == AcuLevel).speed.text();
					break;
					
				case "price":
					Response = machineValues.unit.(@name == chkPnt).(@level == AcuLevel).price.text();
					break;
					
				case "sellFor":
					Response = machineValues.unit.(@name == chkPnt).(@level == AcuLevel).sellFor.text();
					break;
				
				case "moodChange":
					Response = machineValues.unit.(@name == chkPnt).(@level == AcuLevel).moodChange.text();
					break;
					
				case "speedMin":
					Response = machineValues.unit.(@name == chkPnt).(@level == AcuLevel).speedMin.text();
					break;
					
				case "speedMax":
					Response = machineValues.unit.(@name == chkPnt).(@level == AcuLevel).speedMax.text();
					break;
					
				case "accuracyMin":
					Response = machineValues.unit.(@name == chkPnt).(@level == AcuLevel).accuracyMin.text();
					break;
				
				case "accuracyMax":
					Response = machineValues.unit.(@name == chkPnt).(@level == AcuLevel).accuracyMax.text();
					break;
					
				case "powerUpPrice":
					Response = machineValues.unit.(@name == chkPnt).(@level == AcuLevel).powerUpPrice.text();
					break;
					
				case "speedUpGuardPrice":
					Response = machineValues.unit.(@name == chkPnt).(@level == AcuLevel).speedUpGuardPrice.text();
					break;
					
				case "speedUpGuardSpeed":
					Response = machineValues.unit.(@name == chkPnt).(@level == AcuLevel).speedUpGuardSpeed.text();
					break;
					
				case "offenses":
					var array:Array = new Array();
					for each (var offense:String in machineValues.unit.(@name == chkPnt).(@level == AcuLevel).offenses.offense) {
						array.push(offense);
					}
					Response = array.toString();
					break;
					
				case "name":
					Response = machineValues.unit.(@name == chkPnt).(@level == AcuLevel).name.text();
					break;
			}//end of switch
			
			return(Response);
		}
	}
}
