package bing.utils  
{
	import flash.net.SharedObject;
	import flash.system.Security;
	import flash.system.SecurityPanel;

	public class Cookie
	{

		private var _time:uint;
		private var _name:String;
		private var _so:SharedObject;

		public function Cookie(name:String="fairyvillage",timeOut:uint=3600)
		{
			_name = name;
			_time = timeOut;
			_so = SharedObject.getLocal(name,"/");
		}

		//清楚超时内容;  
		public function clearTimeOut():void
		{
			var obj:* = _so.data.cookie;
			if (obj == undefined)
			{
				return;
			}
			for (var key:* in obj)
			{
				if (obj[key] == undefined || obj[key].time == undefined || isTimeOut(obj[key].time))
				{
					delete obj[key];
				}
			}
			_so.data.cookie = obj;
			flush();
		}

		private function isTimeOut(time:uint):Boolean
		{
			var today:Date = new Date  ;
			return time + _time * 1000 < today.getTime();
		}

		//获取超时值;  
		public function getTimeOut():uint
		{
			return _time;
		}

		//获取名称;  
		public function getName():String
		{
			return _name;
		}

		//清除Cookie所有值;  
		public function clear():void
		{
			_so.clear();
		}

		//添加Cookie值  
		public function put(key:String,value: * ):void
		{
			var today:Date = new Date  ;
			key = "key_" + key;
			//value.time = today.getTime();
			if (_so.data.cookie == undefined)
			{
				var obj:Object = {};
				obj[key] = value;
				_so.data.cookie = obj;
			}
			else
			{
				_so.data.cookie[key] = value;
			}
			flush();
		}

		
		private function flush():void
		{
			if(_so){
				try{
					_so.flush();
				}catch(e:Error){
					Security.showSettings();
					Security.showSettings( SecurityPanel.LOCAL_STORAGE );
				}
			}
		}

		//删除Cookie值;  
		public function remove(key:String):void
		{
			if (contains(key))
			{
				delete _so.data.cookie["key_" + key];
				flush();
			}
		}

		//获取Cookie值;  
		public function get(key:String):Object
		{
			return contains(key) ? _so.data.cookie["key_" + key]:null;
		}

		//Cookie值是否存在;  
		public function contains(key:String):Boolean
		{
			key = "key_" + key;
			return _so.data.cookie != undefined && _so.data.cookie[key] != undefined;
		}
	}
}