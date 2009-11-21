﻿package gameControl {

	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.net.LocalConnection;
	
	/* This class controls the game, fires the levels, controls game time, losing and winning conditions,
		money and reputation.
	*/
	
	public class TheGame {
		private static var money:int = 1000; //to be read from XML!!! initially 50
		private static var reputation:int = 50; // [0,inf)
		private static var timePlayed:int = 0;
		private static var delay:int = 250;
		private static var gameTik:Timer = new Timer(delay,0);
		private static var numPass:int;
		private static var maxPass:int = 0;
		private static var curArrests:int = 0;
		private static var curLevel:int = 1;
		private static var curPeopleActive:int = 0;
		private static var maxPeopleActive = 20;
		
		public function TheGame() {
			gameTik.start();
			Globals.conn = new LocalConnection();
		}
		
		//Adds the amount to the money
		public static function addMoney(amount:int):void {
			if(amount > 0) {
				money = money + amount;
			}
		}
		
		//Subtracts the amount from the money, regardless whether it is affordable or not.
		//????If after transaction, money is below 0, trigger youlose!
		public static function subtractMoney(amount:int):void {
			if(amount > 0) {
				money = money - amount;
			}
			/*
			if(money<0) {
				youLose();
			}*/
		}
		
		public static function resetGame():void {
			money = 1000;
			reputation = 50;
			curLevel = 1;
			resetNumPass();
			resetArrests();
		}
		
		//POST: Stops gameTik timer
		public static function pauseGame():void {
			gameTik.stop();
		}
		
		//POST: Start gameTik timer.
		public static function startGame():void {
			gameTik.start();
		}
		
		//Tells whether player can afford to buy something for amount
		public static function affordable(amount:int):Boolean {
			if (money<amount) return false;
			else return true;
		}
		
		public static function getMoney():int {
			return money;
		}
		
		public static function getReputation():int {
			return reputation;
		}
		
		public static function addReputation(amount:int):void {
			if (amount > 0)
				reputation = reputation + amount;
		}
		
		//Subtracts the amount from the reputation.
		//If after transaction reputation is below 0, trigger youLose!
		public static function subtractReputation(amount:int):void {
			if (amount > 0) {
				reputation = reputation - amount;
			}
		}
		
		public static function getGameTik():Timer {
			return gameTik;
		}
		
		//PRE: timeInMin is f.ex. passenger's time left to flight in minutes (shown to player)
		//POST: timeInMin with 1 game tik subtracted. The unit of timeInMin is still the same as in PRE!
		/* SHOULD NOT BE IN HERE!
		public static function subtractGameTimeFromMinTime(timeInMin:Number):Number {
			return timeInMin - delay/1000;
		}*/
		
		public static function getNumPass():int {
			return numPass;
		}
		
		public static function incrementNumPass():void {
			numPass++;
			curPeopleActive--;
		}
		
		public static function resetNumPass():void {
			numPass = 0;
			curPeopleActive = 0;
			maxPeopleActive = 20+(5*(curLevel-1));
		}
		
		public static function incrementArrests():void {
			curArrests++;
		}
		
		public static function getArrests():int {
			return (curArrests);
		}
		
		public static function resetArrests():void {
			curArrests = 0;
		}
		
		public static function setMaxPass(val:int):void {
			maxPass = val;
		}
		
		public static function getLevel():int {
			return curLevel;
		}
		
		public static function setLevel(val:int):void {
			curLevel =  val;
		}
		
		public static function getPeopleActive():int {
			return curPeopleActive;
		}
		
		public static function incrementPeopleActive():void {
			curPeopleActive++;
		}
		
		public static function getMaxPeopleActive():int {
			return maxPeopleActive;
		}
		
		public static function minToGameTime(timeInMin:Number):Number {
			return timeInMin*1000/delay;
		}
		
		public static function gameToMinTime(gameTimeInMin:Number):Number {
			return gameTimeInMin*delay/1000;
		}
	}
}