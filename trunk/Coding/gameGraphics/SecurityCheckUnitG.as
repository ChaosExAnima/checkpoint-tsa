package gameGraphics {

	import utilities.*;
	import flash.display.*;
	import flash.events.*;
	import gameLogic.SecurityCheckUnit;

	
	/* This holds all variables and methods all graphical representations of Security Check Units have in common. 
	   Use subclasses of this class to display Security Check Units. */
	
	public class SecurityCheckUnitG extends Sprite {
		
		//private var xLoc:Number;
		//private var yLoc:Number;
		private var _spot:int;
		
		//Unit form that is displayed by SecurityCheckUnitG
		protected var unitForm:MovieClip; //= new CheepieMetalDetectorG();
		
		//Logical security check unit
		protected var secCheck:SecurityCheckUnit; // = new CheepieMetalDetector();
		
		// Contains stats for upgrade UI
		public var upgradeAcc:Array = new Array(null, null);
		public var upgradeType:Array = new Array(1, 1, 1, 1);
		// Set in line
		public var oncoming:Boolean = false
		
		public function SecurityCheckUnitG(xLoc:Number, yLoc:Number, secCheck:SecurityCheckUnit, secCheckG:MovieClip) {
		    this.x = xLoc;//Utilities.randRange(0,700);
			this.y = yLoc;//Utilities.randRange(0,500);
			this.secCheck = secCheck;
			this.unitForm = secCheckG;
			
			this.addChild(unitForm);
			secCheck.setSecCheckG(this);
			//this.addEventListener(Event.ENTER_FRAME, frameEntered);
			//drawMe();
			idle();
		}
		
		public function upgrade(type:Boolean = false):void {
			trace("Upgrade not implemented yet!");
		}
				
		public function caught():void {
			unitForm.gotoAndStop(4);
		}
		
		public function go():void {
			unitForm.gotoAndStop(3);
		}
		
		public function checking():void {
			unitForm.gotoAndStop(2);
		}
		
		public function idle():void {
			unitForm.gotoAndStop(1);
		}
		
		public function get logic():SecurityCheckUnit {
			return secCheck;
		}
		
		public function getUnitForm():MovieClip
		{
			return unitForm;
		}
		
		/*public function reLocate(xLoc:Number, yLoc:Number):void
		{
			this.x = xLoc;//Utilities.randRange(0,700);
			this.y = yLoc;//Utilities.randRange(0,500);
			//drawMe();
		}*/
		
		public function getProhObjs():Array
		{
			return secCheck.getProhObjs();
		}
		
		protected function swapUnitForm(swapMc:MovieClip) {
			removeChild(unitForm);
			unitForm = swapMc;
			addChild(unitForm);
		}
		
		public function get spot():int {
			return _spot;
		}
		
		public function set spot(num:int):void {
			_spot = num;
		}
	}
}