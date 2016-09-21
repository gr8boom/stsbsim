package ru.sotsbi.u.adminka.ui {
	import fl.accessibility.UIComponentAccImpl;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import flash.display.StageDisplayState
	import flash.external.ExternalInterface;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import ru.sotsbi.u.adminka.ui.answer.AWorkspace;
	import ru.sotsbi.u.adminka.data.Relations;
	import ru.sotsbi.u.adminka.debug.Dbg;
	import ru.sotsbi.u.adminka.debug.DbgEvent;
	
    public class Test extends MovieClip
    {
		private var panel:ArrowBtnPanelFields;
		
		public function Test() {
			init();
        } 
		public function init(){
			panel = new ArrowBtnPanelFields();
			addChild(panel);
		}
    }
}