﻿package gameGraphics
{
	import utilities.*;
	import gameLogic.*;
	import flash.display.*;
	import flash.events.*;
	import gameGraphics.Torso;
	import gameGraphics.Legs;
	import gameUI.UnselectedMenu;
	import gameUI.RedirectMenu;
	import gameControl.*;
	
	public class PassengerG extends Sprite
	{
		// Coordinates of waypoints
		private var xTarg:Array = new Array();
		private var yTarg:Array = new Array();
		
		// Current location
		private var originX:Number = 0;
		private var originY:Number = 0;
		
		private var targSpeed:Number = 0;
		
		// Walking speed
		private var xSpeed:Number = 0;
		private var ySpeed:Number = 0;
		
		private var footPrintW:Number = 40;
		private var footPrintH:Number = 20;
		private var footPrintX:Number = -20;
		private var footPrintY:Number = -10;
		
		private var spriteOffsetX:Number = 0;
		private var spriteOffsetY:Number = -40;
		private var spriteScale:Number = 1;
		
		public var atTic:Number = 0;
		public var waitTic:Number = 0;
		public var reroutTic:Number = 0; // Random number that determines when to try to go back to the old waypoint
		public var rerouting:Boolean = false; // True if encountered an obstacle and is going to a temp random point
		public var gimmeDist:Number = 10; // Distance at which person is at waypoint
		
		public var obsolete:Boolean = false; // no more waypoints
		public var bKillMe:Boolean = false; // time to die
		
		private var inittedB:Boolean = false; // Is initialized
		private var movingMC:MovieClip;
		
		private var myLine:LineG; // Target line
		
		private var logicPass:Passenger = null; // Logical equivalent of passenger
		
		// Graphical vars
		private var _colors:Array;
		private var _torso:MovieClip;
		private var _legs:MovieClip;
		private var _legRef:Legs = new Legs();
		private var _legColors:Array;
		private var _toggle:Boolean;
		
		private var _paused:Boolean;
		private var _redirect:RedirectMenu;
		private var _helloSound:String;
		public var _myMask:DisplayObject;
	
		public function PassengerG(x_:Number, y_:Number, logic:Passenger, line:LineG, torso:MovieClip, colors:Array, name:String):void
		{
			//this.addChild(new passHitBox());

			_torso = torso;
			_colors = colors;
			_legs = _legRef.getStand();
			_legColors = _legRef.setColor(_legs);
			this.name = name;
			
			x = x_;
			y = y_;
			
			targSpeed = Utilities.randRange(3,7);
			waitTic = Utilities.randRange(15,25);
			reroutTic = Utilities.randRange(15,30);
	
			logicPass = logic;
			
			
			setLine(line);
			
			this.addChild(_legs);
			this.addChild(_torso);
			
			this.addEventListener(MouseEvent.CLICK, toggleSelected);
			this.addEventListener(MouseEvent.MOUSE_OVER, overSelected);
			this.addEventListener(MouseEvent.MOUSE_OUT, outSelected);

			inittedB = true;
		}
		
		
		//------------------------------------------NAVIGATION FUNCTIONS--------------------------//
		
		// Sets current walk target to new entry on waypoint array
		public function setTarg(x_:Number, y_:Number):void
		{
			xTarg.unshift(x_);
			yTarg.unshift(y_);
			setOrigin();
			recalSpeeds();
			updateHeading();
			obsolete = false;
		}
		
		// Goes either to next waypoint or kills self,
		// depending on if there are any waypoints left
		private function atTarg():void
		{
			xTarg.shift();
			yTarg.shift();
			setOrigin();
			_toggle = true;
			rerouting = false;
			atTic = 0;
			if(xTarg.length < 1)
			{
				obsoleteMe();
				
			}else{
				//trace("reached target");
				recalSpeeds();
				updateHeading();
			}
		}
		
		// Sets the new waypoint to random point on the map
		public function randTarg():void
		{
			setTarg(x+Utilities.randRange(-100,100), y+Utilities.randRange(-100,100));
		}
		
		// Skips current target
		public function skipTarg():void
		{
			atTarg();
		}
		
		// Adds new waypoint to go to after finishing current waypoints
		public function addTarg(x_:Number, y_:Number):void
		{
			xTarg.push(x_);
			yTarg.push(y_);
			obsolete = false;
		}
		
		// Recalibrates the speed depending on the distance to the target
		private function recalSpeeds():void
		{
			if (xTarg[0]) {
				xSpeed = targSpeed*(xTarg[0] - x)/Math.sqrt(Math.pow(xTarg[0] - x,2) + Math.pow(yTarg[0] - y,2));
				ySpeed = targSpeed*(yTarg[0] - y)/Math.sqrt(Math.pow(xTarg[0] - x,2) + Math.pow(yTarg[0] - y,2));
			}
		}
		
		// Sets origin to current position
		private function setOrigin():void
		{
			originX = x;
			originY = y;
		}
		
		// Moves person
		public function tStep():void
		{
			if(SUtilities.switchedSide(yTarg[0], originY, y + ySpeed) && SUtilities.switchedSide(xTarg[0], originX, x + xSpeed))
			{
				 atTarg();
			}else{
				if(xTarg.length >= 1 && !_paused) 
				{
					x += xSpeed;
					y += ySpeed;
				}
			}
		}
		
		// Returns true if current distance to waypoint is under a certain distance
		public function closeEnough():Boolean
		{
			return distToTarg() <= gimmeDist;
		}
		
		// Kills self
		public function killMe():void
		{			
			//trace("killing myself");		
			bKillMe = true;
		}
		
		public function obsoleteMe():void
		{
			obsolete = true;
		}
		
		// Returns how far it is to current waypoint
		public function distToTarg():Number
		{
			return Math.sqrt(Math.pow(xTarg[0] - x,2) + Math.pow(yTarg[0] - y,2));
		}
		
		// Stops the person until called again
		public function halt(val:Boolean):void {
			_paused = val;
			if (_paused == true) {
				stopWalk();
			} else {
				startWalk();
			}
		}
		
		//----------------------------------------GRAPHICAL FUNCTIONS--------------------------------------//
		
		// Sets how person faces depending on angle to waypoint
		private function updateHeading():void
		{
			var theta:Number = Math.atan(Math.abs(xSpeed/ySpeed))*180/Math.PI;
			
			if(xSpeed >= 0 && ySpeed <= 0)
				theta = 90 - theta;
			else if(xSpeed <= 0 && ySpeed <= 0)
				theta = theta + 90;
			else if(xSpeed <= 0 && ySpeed >= 0)
				theta = 270 - theta;
			else if(xSpeed >= 0 && ySpeed >= 0)
				theta = theta + 270;
			
			theta += 22.5 + 90;
			
			theta = ((theta/360) - Math.floor(theta/360))*360;
			theta = Math.ceil(theta/45);
			if (theta != _torso.currentFrame) {
	 			_torso.gotoAndStop(theta);
			 	_torso.addFrameScript(_torso.currentFrame-1, setTorso);
			}
			if (theta != _legs.currentFrame) {
				_legs.gotoAndStop(theta);
				_legs.addFrameScript(_legs.currentFrame-1, setLegs);
			}
		}
		
		// Sets torso direction and recolors it
		private function setTorso():void {
			_torso.addFrameScript(_torso.currentFrame-1, null);
			new Torso().setColor(_torso, _colors);
		}
		
		// Sets legs direction and recolors it
		private function setLegs():void {
			_legs.addFrameScript(_legs.currentFrame-1, null);
			_legRef.setColor(_legs, _legColors);
			_legRef.scaleAnim(_legs, targSpeed);
		}
			
		// Sets legs to walk animation
		public function startWalk():void
		{
			if (_legs is stand1 && !_paused) {
				this.removeChild(_legs);
				_legs = _legRef.getWalk();
				_legs.addFrameScript(_legs.currentFrame-1, setLegs);
				this.addChildAt(_legs, 0);
			}

			updateHeading();
			recalSpeeds();
		}
		
		// Sets legs to stand animation
		public function stopWalk():void
		{
			if (_legs is walk1) {
				this.removeChild(_legs);
				_legs = _legRef.getStand();
				_legs.addFrameScript(_legs.currentFrame-1, setLegs);
				this.addChildAt(_legs, 0);
			}
			
			updateHeading();
		}
		
		//-------------------------------------------SELECTION FUNCTIONS------------------------------//
		
		// Clears person info on mouse out
		private function outSelected(e:MouseEvent):void {
			UnselectedMenu.setBlank();
		}
		
		// Sets person info on mouse in
		private function overSelected(e:MouseEvent):void {
			UnselectedMenu.setPerson(this);
			// Hilite person code here
		}
		
		// Selects person and shows redirect on mouse down
		private function toggleSelected(e:MouseEvent):void {
			if (!_redirect) {
				//trace("Redirect Menu created!");
				//trace(Globals.menus);
				_redirect = new RedirectMenu(this);
				Globals.airport.addChild(_redirect);
				_redirect.x = parent.x+this.x;
				_redirect.y = parent.y+this.y;
			} else {
				_redirect = null;
			}
		}
		
		// Removes redirect functionality
		public function noRedirect():void {
			this.removeEventListener(MouseEvent.CLICK, toggleSelected);
			if (_redirect) {
				_redirect.remove();
				_redirect = null;
				halt(false);
			}
		}
		
		
		//------------------------------------GETTERS AND SETTERS---------------------------------------//

		// Gets logic
		public function get logic():Passenger {
			return(logicPass);
		}
		
		// Gets whether is initialized
		public function initted():Boolean
		{
			return inittedB;
		}		
		
		public function getFootPrintX():Number
		{
			return footPrintX + x;
		}
		
		public function getFootPrintY():Number
		{
			return footPrintY + y;
		}
		
		public function getFootPrintW():Number
		{
			return footPrintW;
		}
		
		public function getFootPrintH():Number
		{
			return footPrintH;
		}
		
		public function getSpeedX():Number
		{
			return xSpeed;
		}
		
		public function getSpeedY():Number
		{
			return ySpeed;
		}
		
		public function set speed(val:int):void {
			targSpeed = val;
		}
		
		public function getLine():LineG
		{
			return myLine;
		}
		
		public function setLine(newLine:LineG)
		{
			myLine = newLine;
			//xTarg = new Array();
			//yTarg = new Array();
			if(Airport.hasTicketChecker())
			{
				setTarg(685-AirportG.FLOOR_X,845-AirportG.FLOOR_Y);
				newLine = AirportG.ticketChecker.getShortestLine();
				
			}
				 
			addTarg(newLine.station.x-AirportG.FLOOR_X-200,newLine.station.y-AirportG.FLOOR_Y+100);
		}
		
		public function set sound(str:String):void {
			_helloSound = str;
		}
		
		public function get sound():String {
			return _helloSound;
		}
	}
}