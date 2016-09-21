package ru.sotsbi.u.adminka.ui.answer {
	import flash.events.Event;
    public class AEvent extends Event
    {
		public static const NEXT_CLICK:String = 'nextAnswer';
		public static const PREV_CLICK:String = 'prevAnswer';
		public static const ADD_CLICK:String = 'addAnswer';
		public static const REMOVE_CLICK:String = 'removeAnswer';
		public static const	REMOVE_ARROW:String = 'xmlError';
		public static const	SELECTED:String = 'selected';
		public static const	TEXT_CHANGED:String = 'textChanged';
		public function AEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	
		public override function clone():Event
		{
			return new AEvent(type, bubbles, cancelable);
		}
	}
}