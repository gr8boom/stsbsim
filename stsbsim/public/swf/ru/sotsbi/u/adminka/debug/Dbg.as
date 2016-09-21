package ru.sotsbi.u.adminka.debug{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class Dbg extends Object {

		private var _blocks:Array;
		private var _arrows:Array;
		private var _nBlocks:uint;

		public function Dbg() {
			trace('DEBUGGER');
		}

		public static function trc(obj:*, tab:String = '') {
			var s:String = '';
			var type:String = '';
			if (obj is Number) {
				trace(tab + 'Num(' + obj + ')');
				return;
			}else if (obj is String) {
				trace(tab + 'Str(' + obj + ')');
				return;
			}else if(obj === undefined){
				trace(tab + 'undefined');
				return;
				
			}
			if (tab == ''){
				if (obj is Array) {
					trace('Array(');
				}else if (obj is Object) {
					trace('Object(');
				}
				tab = '    ';
			}
			for (var k:String in obj) {
				if (obj[k] is String || obj[k] is Number || obj[k] == undefined) {
					trace(tab + k + '(' + typeof(obj[k]) + ')=' + obj[k]);
					continue;
				}
				trace(tab + k+'('+typeof(obj[k])+')' + '(');
				trc(obj[k], tab + '    ');
				trace(tab + ')');
			}
		}
		public static function getClass(obj:Object):Class {
			return Class(getDefinitionByName(getQualifiedClassName(obj)));
		}
	}
}