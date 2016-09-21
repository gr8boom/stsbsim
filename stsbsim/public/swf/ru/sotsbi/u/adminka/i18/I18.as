package ru.sotsbi.u.adminka.i18{
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import fl.controls.LabelButton;
	import ru.sotsbi.u.adminka.debug.Dbg;
	
	/**
	 * @about singleton http://web.archive.org/web/20071026050851/http://yarovoy.com/2007/10/24/singleton_in_actionscript_3/
	 */
	public class I18 {
		private static var _lang:String;
		private static var _dict:Array;
		private static var __instance:I18;
		private static var __allowInstantiation:Boolean = false;

		public static function get instance():I18{
			_dict = new Array();
			_lang = 'en';
			if(!__instance)
			{
				// Разрешаем создание экземпляра класса.
				__allowInstantiation = true;
				// Создаем экземпляр.
				__instance = new I18();
				// Запрещаем создание экземпляров.
				__allowInstantiation = false;
			}
			return __instance;
		}
		/**
		 * Конструктор.
		 */
		public function I18(){
			if(!__allowInstantiation)
				throw new Error("Вы не можете создавать экземпляры класса при помощи конструктора. Для доступа к экземпляру используйте Singleton.instance.");
		}
		
		public static function set lang(s:String){
			_lang = s;
		}
		public static function get lang(){
			return _lang;
		}
		public static function set dict(a:Array){
//object with associative keys			
			_dict = a;
		}
		public static function t(s:String){
//			trace('i18.t "'+s+'"');
			if(_dict == null) 
				return s;
			var trans:String;
			var l:int = _dict.length;
			for(var i:int = 0; i<l; i++){
				if(_dict[i] is Array){
					if(_dict[i][0] == s){
						return _dict[i][1] as String;
					}
				}
			}
			return s;
		}
		public static function tObj(target:DisplayObjectContainer, dpt:int = 0){
			if(_dict == null || _dict.length == 0)
				return;
//			trace('translate '+target+ dpt);
			var obj:DisplayObject;
			var tf:TextField;
			var lb:LabelButton;
			var s:String;
			var n:int = target.numChildren;
			for(var i:int=0; i < n; i++){
				obj = target.getChildAt(i);
//				trace('obj '+obj);
				if(obj is TextField){
					tf = obj as TextField;
//					trace('textfield '+tf.text);
					tf.text = t(tf.text);

				}else if(obj is DisplayObjectContainer){
					tObj(obj as DisplayObjectContainer, dpt+1);
				}
			}
		}

	}
}