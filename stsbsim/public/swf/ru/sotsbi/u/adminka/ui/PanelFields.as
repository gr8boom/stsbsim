package ru.sotsbi.u.adminka.ui {
	import ru.sotsbi.u.adminka.i18.I18MovieClip;
	
    public class PanelFields extends I18MovieClip
    {
		private var _attributes:Array;
		public function PanelFields()
        {
        }
		public function get attributes(){
			return _attributes;
		}
		public function set attributes(a:Array){
			_attributes = a;
		}
    } 
}