package bing.map.utils
{
	import bing.map.data.MapData;
	import bing.map.model.Builder;
	import bing.map.model.Npc;
	import bing.map.model.Transport;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.net.URLRequest;
	
	import mx.controls.Alert;

	/**
	 * 导入地图数据 
	 * @author zhouzhanglin
	 */	
	public class DataImport extends EventDispatcher
	{
		//地图的文件夹
		private var _directory:File = null ;
		//文件 
		private var _file:File = null ;
		//地图配置文件 
		private var _mapConfig:XML = null ;
		//文件流
		private var _fs:FileStream = null ;
		//文件加载器
		private var _loader:Loader = null ;
		
		/**
		 * 地图数据恢复和导入 构造函数 
		 */		
		public function DataImport()
		{
			MapData.initMapData();
			_directory = new File();
			_directory.browseForDirectory("选择地图数据文件夹");
			_directory.addEventListener(Event.SELECT , selectedDir );
		}
		
		/**
		 * 选择了地图文件夹 ，先读取和处理地图配置文件 
		 */		
		private function selectedDir(e:Event):void{
			try{
				var configFile:File = new File(_directory.nativePath+"/config.xml") ;
				_fs = new FileStream();
				_fs.open(configFile,FileMode.READ);
				this._mapConfig = XML(_fs.readUTFBytes(_fs.bytesAvailable));
				//地图信息
				MapData.mapName = _mapConfig.map[0].name;
				MapData.xNum =parseInt(  _mapConfig.map[0].xNum );
				MapData.yNum =parseInt(  _mapConfig.map[0].yNum );
				MapData.mapWidth =parseInt(  _mapConfig.map[0].width );
				MapData.mapHeight =parseInt(  _mapConfig.map[0].height );
				MapData.tileWidth =parseInt(  _mapConfig.map[0].tileWidth );
				MapData.tileHeight =parseInt(  _mapConfig.map[0].tileHeight );
				//传输点信息
				var len:int = _mapConfig.transport[0].trans.length() ;
				MapData.transportVector = new Vector.<Transport>();
				for( var i:int = 0 ; i<len ; i++ ){
					var trans:Transport = new Transport(_mapConfig.transport[0].trans[i].@point , _mapConfig.transport[0].trans[i].@isShow );
					trans.direction = parseInt( _mapConfig.transport[0].trans[i].@birthDirection ) ;
					trans.nextMapId = parseInt( _mapConfig.transport[0].trans[i].@birthMapId ) ;
					trans.nextMapLoc = _mapConfig.transport[0].trans[i].@birthPoint ;
					trans.isShow= _mapConfig.transport[0].trans[i].@isShow=="true" ?true:false;
					MapData.transportVector.push(trans);
				}
				//清除资源
				this._mapConfig = null ;
				configFile = null ;
			}catch(e:Error){
				Alert.show("未找到config.xml文件") ;
				return ;
			}finally{
				_fs.close();
				//读取地表图片
				readBgGround();
			}
		}
		
		/**
		 * 读取背景图片 
		 */		
		private function readBgGround():void {
			try{
				var bgPath:String = _directory.nativePath+"/ground.jpg";
				MapData.bgPath = bgPath;
				_loader = new Loader();
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE , loadedBg);
				_loader.load(new URLRequest(bgPath));
			}catch(e:Error){
				Alert.show("未找到ground.jpg图片") ;
				return ;
			}
		}
		
		/**
		 * 背景图片加载完成  
		 */		
		private function  loadedBg(e:Event):void {
			MapData.bg = e.target.content;
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE , loadedBg);
			_loader = null ;
			//读取建筑数据
			readBuildData();
		}
		
		/**
		 * 读取建筑数据 
		 */		
		private function readBuildData():void{
			try{
				_file = new File(_directory.nativePath+"/build.bing");
				_fs = new FileStream()
				_fs.open(_file,FileMode.READ );
				var len:int = _fs.readShort() ;//建筑的个数
				for(var i:int = 0 ; i< len ; i++ ){
					var type:int = _fs.readUnsignedByte() ;//建筑类型
					var id:int = _fs.readUnsignedByte() ;//建筑ID
					//位置
					var x:int = _fs.readUnsignedByte() ;
					var y:int = _fs.readUnsignedByte() ;
					var build:Builder = new Builder(type+"_"+id,new Point(x,y));
					MapData.builderVector.push( build );
				}
			}catch(e:Error){
				Alert.show("未找到build.bing文件") ;
			}finally{
				_fs.close();
				//读取NPC数据
				readNpcData();
			}
		}
		
		/**
		 * 读取NPC数据 
		 */		
		private function readNpcData():void {
			try{
				_file = new File(_directory.nativePath+"/npc.bing");
				_fs = new FileStream()
				_fs.open(_file,FileMode.READ );
				var len:int = _fs.readShort() ;//npc的个数
				for(var i:int = 0 ; i< len ; i++ ){
					var id:int = _fs.readUnsignedByte() ;//npcID
					//位置
					var x:int = _fs.readUnsignedByte() ;
					var y:int = _fs.readUnsignedByte() ;
					var npc:Npc = new Npc( id+"",new Point(x,y)) ;
					MapData.npcVector.push(npc);
				}
			}catch(e:Error){
				Alert.show("未找到npc.bing文件") ;
			}finally{
				_fs.close();
				//读取npc配置
				readNpcConfig();
			}
		}
		
		/**
		 * 读取npc配置
		 */		
		private function readNpcConfig():void {
			try{
				var configFile:File = new File(_directory.nativePath+"/npc.xml") ;
				_fs = new FileStream();
				_fs.open(configFile,FileMode.READ);
				var config:XML  = XML(_fs.readUTFBytes(_fs.bytesAvailable));
				for( var i:int = 0; i<config.npc.length() ; i++ ){
					var npc:Npc = MapData.npcVector[i];
					if( npc!=null ){
						npc.npcName = config.npc[i].name ;
						npc.npcId = parseInt( config.npc[i].npcId );
						npc.npcPanel = config.npc[i].panel ;
					}
				}
			}catch(e:Error){
				Alert.show("未找到npc.xml文件") ;
				return ;
			}finally{
				_fs.close();
				//读取碰撞块数据
				readImpactData();
			}
		}
		
		/**
		 * 读取碰撞块和遮罩数据 
		 */		
 		private function readImpactData():void {
			try{
				_file = new File(_directory.nativePath+"/impact_mask.bing");
				_fs = new FileStream()
				_fs.open(_file,FileMode.READ );
				for(var i:int = 0; i<MapData.xNum ; i++ ){
					for(var j:int = 0; j<MapData.yNum*2+1 ; j++ ){
						var num:int = _fs.readUnsignedByte();
						if(num==0){
							MapData.impactArray[i+"-"+j] = false ;
							MapData.maskArray[i+"-"+j] = false ;
						}else if(num==1){
							MapData.impactArray[i+"-"+j] = true ;
							MapData.maskArray[i+"-"+j] = false ;
						}else if(num==2){
							MapData.impactArray[i+"-"+j] = false ;
							MapData.maskArray[i+"-"+j] = true ;
						}
					}
				}
			}catch(e:Error){
				Alert.show("未找到impact_mask.bing文件") ;
			}finally{
				_fs.close();
				//读取完成
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}

	}
}