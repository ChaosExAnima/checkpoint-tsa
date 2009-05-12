﻿package gameGraphics {	import gameLogic.TicketChecker;	import gameGraphics.PassengerG;	import gameLogic.Airport;	import flash.display.MovieClip;		public class TicketCheckerG extends MovieClip {		private var _unit:MovieClip;		private var _logic:TicketChecker;		private var _airport:AirportG;				public function TicketCheckerG(airport:AirportG):void {			_unit = new GTicketChecker();			Airport.addTicketChecker();			_logic = Airport.getTicketChecker();			_airport = airport;			this.addChild(_unit);		}								//Sends passengers to a line. 		//Without powerup: Random line		//with powerup: shortest line		public function getShortestLine():LineG {						var lineArray:Array = new Array();			lineArray = _airport.afloor.getTargetedLines();			trace("array1:" + _airport.afloor.getTargetedLines());			trace("array2:" + lineArray);									for (var i:int = 0; i < lineArray.length; i++)			{				lineArray[i] = lineArray[i]*10+i;			}			trace("short array: "+ lineArray);			lineArray = lineArray.sort();						var iLineIndx = lineArray[0] % 10;			trace("choosen Index: " + iLineIndx);			var targLine = _airport.lines[iLineIndx].line;			return targLine;		}	}}