﻿package gameLogic {	import gameData.*;/*	A SecurityCheckUnit models either any kind of a Security Check unit, 	which can be either a metal detector, X-ray machine, sniffing dogs or security personnel*/		public class BombCanine extends Canine{				public function BombCanine(){			super("BombCanine",				  Number(XMLmachineData.getXML("BombCanine","moodChange","1")),				  Number(XMLmachineData.getXML("BombCanine","speed","1")),				  Number(XMLmachineData.getXML("BombCanine","accuracy","1")),				  Number(XMLmachineData.getXML("BombCanine", "price", "1")),				  Number(XMLmachineData.getXML("BombCanine", "sellFor", "1")),				  [new Bomb()],				  Number(XMLmachineData.getXML("BombCanine", "price", "2")),				  Number(XMLmachineData.getXML("BombCanine","accuracy","2")),				  Number(XMLmachineData.getXML("BombCanine", "price", "3")),				  Number(XMLmachineData.getXML("BombCanine","accuracy","3"))				  				  ); //READ IN FROM XML:		}			}}