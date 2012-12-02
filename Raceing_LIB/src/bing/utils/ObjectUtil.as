package bing.utils
{
	import flash.utils.ByteArray;
	import flash.utils.describeType;

	public class ObjectUtil
	{
		/**
		 * 深度复制
		 * copy Object 
		 * @param obj
		 * @return 
		 */		
		public static function copyObj( obj:Object ):Object 
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeObject( obj );
			byteArray.position=0 ;
			return byteArray.readObject() as Object;
		}
		
		/**
		 *通过xml属性来复制 
		 * @param obj
		 * @param clasName
		 * @return 
		 * 
		 */		
		public static function copyObjByClass( obj:Object , clasName:Class ):Object
		{
			var newObj:Object = new clasName();
			
			var xml:XML = describeType(newObj);
			var len:int = xml.variable.length();
			var prop:String ;
			var val:String;
			var type:String;
			for( var i:int  = 0 ; i<len ; i++)
			{
//				type = xml.variable[i].@type;
				prop = xml.variable[i].@name ;
				if( newObj.hasOwnProperty(prop)&& obj.hasOwnProperty(prop))
				{
					newObj[prop] = obj[prop] ;
				}
			}
			return newObj ;
		}
	
	}
}