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
		
		/**
		 * print Object's details 
		 * @param obj  type is Object or Array
		 */		
		public static function printDetails( obj:Object ):void 
		{
			SystemUtil.debug("print Object================================================");
			if( obj is Array)
			{
				for( var i:int = 0 ; i<obj.length ; i++)
				{
					SystemUtil.debug("\n\n\n"+i+"----------------------------")
					debugObj(obj[i]);
				}
			}
			else 
			{
				debugObj(obj);
			}
		}
		
		/**
		 * Just print an object 
		 * @param obj
		 * @param txt
		 */		
		private static function debugObj( obj:Object , txt:String="" ):void
		{
			var xml:XML = describeType(obj);
			SystemUtil.debug( "name: "+xml.@name + "\t extendsClass:"+xml.extendsClass[0].@type+txt);
			var len:int = xml.variable.length();
			var prop:String ;
			var val:String;
			var type:String;
			for( var i:int  = 0 ; i<len ; i++)
			{
				type = xml.variable[i].@type;
				prop = xml.variable[i].@name ;
				switch(type)
				{
					case "int":
					case "uint":
					case "String":
						SystemUtil.debug("Property:\t"+prop+"("+type+")\t"+obj[prop] );
						break;
					case "Object":
						debugObj( obj[prop] );
						break;
					case "Array":
						if(obj[prop])
						{
							SystemUtil.debug("Property:\t"+prop+"("+type+"  len:"+obj[prop].length+")=========start");
							for( var j:int = 0 ; j< obj[prop] .length ; j++)
							{
								debugObj( obj[prop][j] , "\t\t\tvalue:"+obj[prop][j]  );
							}
							SystemUtil.debug("================================end");
						}
						else
						{
							SystemUtil.debug("Property:\t"+prop+"("+type+") null");
						}
						break;
				}
			}
		}
	}
}