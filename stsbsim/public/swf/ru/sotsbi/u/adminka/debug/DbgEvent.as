package ru.sotsbi.u.adminka.debug {
	import flash.events.Event;
    public class DbgEvent extends Event
    {
		public static const TRACE:String = 'trace';
		public var _params:Object;
		
		public function DbgEvent(type:String, params:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_params = params;
		}
	
		public override function clone():Event
		{
			return new DbgEvent(type, _params, bubbles, cancelable);
		}
		public function get params(){
			return _params;
		}
	}
}