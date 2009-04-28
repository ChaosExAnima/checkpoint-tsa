/*	
	Random Name Generator Class
	Created by Ephraim Gregor
	Last Modified on 2/17/09
	
	Simply instantiate and call getName. A small delay is needed before calling getName to load the XML, though.
*/
	
package utilities {
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class NameGen {
		private var _lastNames:XMLList;
		private var _maleNames:XMLList;
		private var _femaleNames:XMLList;
		
		public function NameGen():void {
			var loader:URLLoader = new URLLoader(new URLRequest('gameData/names.xml'));
			loader.addEventListener(Event.COMPLETE, setNames);
		}
		
		private function setNames(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, setNames);
			var xml:XML = XML(e.target.data);
			_lastNames = XMLList(xml.lastnames);
			_maleNames = XMLList(xml.malenames);
			_femaleNames = XMLList(xml.femalenames);
		}
		
		// getName function. Returns a string in the form of 'firstname lastname'
		// Valid arguments are 'male' or 'female', otherwise throws an exception!
		public function getName(gender:String = 'male'):String {
			if (_lastNames) {
				var rand:uint = Utilities.randRange(0,_lastNames.name.length());
				var lastName:String = _lastNames.name[rand];
				var firstName:String;
				if (gender == 'female') {
					rand = Utilities.randRange(0,_femaleNames.name.length());
					firstName = _femaleNames.name[rand];
				} else if (gender == 'male') {
					rand = Utilities.randRange(0,_maleNames.name.length());
					firstName = _maleNames.name[rand];
				} else {
					throw new Error("Invalid argument in function 'getName'!");
				}
						
				return(firstName+' '+lastName);
			}
			return("Invalid");
		}
	}
}