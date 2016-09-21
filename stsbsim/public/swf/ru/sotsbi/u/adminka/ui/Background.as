package ru.sotsbi.u.adminka.ui{

	import flash.events.*;
	import flash.net.URLRequest;
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.*;
	public class Background extends Loader {

		private var _url:URLRequest;

		public function Background() {
		}

		public function loadFile(fileName:String) {
			trace('loading...');
			_url=new URLRequest(fileName);
			load(_url);
		}
	}
}