package ru.sotsbi.u.adminka.data{
	import ru.sotsbi.u.adminka.ui.answer.AError;

	public class Relations extends Object {

		private var _arr:Array;

		public function Relations() {
			_arr = new Array();
		}

		public function merge(rls:Relations) {
			trace('merge Rel');
			var key:int;
			for each(var r:Object in rls.asArray) {
				key = getRelationById(r['id'], true);
				trace('key' + key);
				if (key >= 0) {
					_arr[key] = r;
//TODO:There must be an event because id already exists;					
				}else {
					_arr.push(r);
				}
			}
		}
		
		public function addRelation(r: Object) {
			trace('add relation '+r);
			_arr.push(r);
		}

		public function removeRelation(n:int) {
			_arr.splice(n, 1);
		}
		public function getRelationById(id:String, onlyKey:Boolean = false ) {
			for (var i:int = 0; i < _arr.length; i++) {
//				trace(_arr[i]['id'] + '??' + id + '='+(_arr[i]['id'] == id));
				if (_arr[i]['id'] == id) {
					if (onlyKey) {
						return i;
					}else {
						return _arr[i];
					}
				}
			}
			if(onlyKey){
				return -1;
			}else {
				return new Object();
			}
		}
		public function get asArray() {
			return _arr;
		}
	}
}