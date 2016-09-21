package ru.sotsbi.u.adminka.data{
    public dynamic class UObject extends Object {
        public function UObject(){
            super();
        }
        public static function merge(obj0:Object, obj1:Object):Object{
			var obj:Object = {};
			var p:String;
			for (p in obj0){
				if(obj0[p]!= null){
					obj[p] = obj0[p];
				}
			}
			for (p in obj1){
				if(obj1[p]!= null){
					obj[p] = obj1[p];
				}
			}
			return obj;
		}
    }
}