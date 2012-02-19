package bing.gl.a3d.core
{
	import alternativa.engine3d.core.*;
	import alternativa.engine3d.materials.Material;
	
	import bing.gl.a3d.events.Scene3DEvent;
	
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	[Event(name="progressEvent",type="bing.gl.a3d.events.Scene3DEvent")]
	[Event(name="completeEvent",type="bing.gl.a3d.events.Scene3DEvent")]
	public class Scene3D extends Sprite
	{
		public static var context:Context3D ;
		public var camera:Camera3D=new Camera3D(1,10000);
		private var _rootContainer:Object3D= new Object3D();
		private var _world:Object3D = new Object3D();
		private var _renderSwitch:Boolean=true; //渲染开关
		private var _cameraArray:Vector.<Camera3D> = new Vector.<Camera3D>();
		private var _stage3D:Stage3D ;
		private var _loadTotal:int; //总共的
		private var _loadedNum:int ; //下载完成的
		
		//============getter/setter============
		
		/**
		 * 3D对象的容器，向里面添加和移除Object3D对象 
		 * @return 
		 */		
		public  function get world():Object3D
		{
			return this._world ;
		}
		
		//================================
		/**
		 * 创建基本的3D场景 
		 */		
		public function Scene3D()
		{
			super();
			if(stage){
				camera.view = new View(stage.stageWidth , stage.stageHeight,false,0,1,4);
			}else{
				camera.view = new View(700 , 500 ,false , 0,1,4);
			}
			addChild(camera.view);
			
			_rootContainer.addChild(camera);
			_rootContainer.addChild(_world);
			
			_cameraArray.push( camera );
			
			_stage3D = stage.stage3Ds[0];
			_stage3D.addEventListener(Event.CONTEXT3D_CREATE , context3DCreatedHandler );
			_stage3D.requestContext3D();
		}
		
		private function context3DCreatedHandler (e:Event):void
		{
			context = _stage3D.context3D ;
			_stage3D.removeEventListener(Event.CONTEXT3D_CREATE , context3DCreatedHandler );
			uploadResources(_rootContainer.getResources(true));
			this.addEventListener(Event.ENTER_FRAME , render );
			context3dCreated();
		}
		
		/**
		 * 3d环境创建完成 
		 */		
		protected function context3dCreated():void{}
		
		/**
		 * 上传资源到GPU渲染 
		 * @param resources 
		 */		
		public function uploadResources( resources:Vector.<Resource>):void
		{
			for each( var res:Resource in resources){
				res.upload(_stage3D.context3D);
			}
		}
		
		//=========添加和移除相机===================
		public function addCamera3D(camera:Camera3D):void
		{
			this._rootContainer.addChild( camera );
			this._cameraArray.push( camera );
		}
		public function removeCamera3D( camera:Camera3D):Object3D
		{
			for( var i:int = 0 ; i<_cameraArray.length ; i++){
				if(_cameraArray[i]==camera){
					_cameraArray.splice( i ,1);
					break ;
				}
			}
			return this._rootContainer.removeChild( camera );
		}
		
		//==========逻辑======================
		private function render( e:Event ):void
		{
			if(!_renderSwitch) return ;
			var camera:Camera3D ;
			for( var i:int = 0 ; i<_cameraArray.length ; i++){
				camera = _cameraArray[i] ;
				camera.render(_stage3D );
			}
		}
		/**
		 * 暂停 
		 */		
		public function pause():void
		{
			_renderSwitch = false ;
		}
		/**
		 * 恢复 
		 */		
		public function resume():void
		{
			_renderSwitch = true ;
		}
		
		//=========创建3D对象=================
		/**
		 * 添加一个3D对象到场景上
		 * @param req 3D文件的路径
		 * @param obj3DName 3D对象mesh或skin的名称，可以为null
		 * @return 
		 * 
		 */		
		public function addChildFromFile( req:URLRequest ,obj3DName:String):Pivot3D
		{
			_loadTotal++;
			_loadedNum++ ;
			var pivot3d:Pivot3D = new Pivot3D();
			pivot3d.addCallBack( createdCompleteHandler );
			pivot3d.loadRes( req,obj3DName);
			this.world.addChild( pivot3d );
			return pivot3d ;
		}
		private function createdCompleteHandler(pivot3d:Pivot3D):void
		{
			_loadedNum--;
			var pro:Number =  (_loadTotal-_loadedNum)/_loadTotal;
			this.dispatchEvent( new Scene3DEvent(Scene3DEvent.PROGRESS_EVENT,pro));
			if(pro==1 && _loadedNum==0){
				this.dispatchEvent( new Scene3DEvent(Scene3DEvent.COMPLETE_EVENT));
				_loadTotal = 0 ;
			}
		}
		
		/**
		 * 添加对象，用于已经有嵌入的资源  
		 * @param obj3DName 可以为null
		 * @param embed3dFile 绑定的文件的实例
		 * @param material 材质贴图
		 * @param type 类型，包括dae,3ds,a3d
		 * @return 
		 */			
		public function addChildFromEmbed( obj3DName:String , embed3dFile:*  , material:Material ,type:String ):Pivot3D
		{
			var pivot3d:Pivot3D = new Pivot3D();
			pivot3d.createdFromEmbedRes(obj3DName , embed3dFile , material ,type);
			this.world.addChild( pivot3d );
			return pivot3d ;
		}
	}
}