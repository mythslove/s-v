package bing.gl.a3d.core
{
	import alternativa.engine3d.animation.AnimationClip;
	import alternativa.engine3d.animation.AnimationController;
	import alternativa.engine3d.animation.AnimationSwitcher;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.loaders.*;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.materials.StandardMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.objects.Surface;
	import alternativa.engine3d.resources.ExternalTextureResource;
	import alternativa.engine3d.resources.Geometry;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	public class Pivot3D extends Object3D
	{
		private var _createdCall:Function=null ;
		private var _obj3DName:String;
		private var _type:String ;
		private var _textureFolder:String ;
		private var _req:URLRequest ;
		private var _mesh:Mesh ;
		private var _animationController:AnimationController ;
		private var _animationSwitcher:AnimationSwitcher ;
		private var _animation:AnimationClip;
		private var _animationDic:Dictionary ;
		private var _textures:Vector.<ExternalTextureResource>; 
		
		public function get mesh():Mesh
		{
			return _mesh ;
		}
		
		public function Pivot3D()
		{
			super();
		}
		
		/**
		 *  
		 * @param obj3DName 对象名称
		 * @param embed3dFile 绑定的3d文件的实例 
		 * @param material 贴图
		 * @param type 有dae,3ds,a3d
		 */		
		public function createdFromEmbedRes(obj3DName:String , embed3dFile:*  , material:Material ,type:String ):void
		{
			this._obj3DName = obj3DName ;
			this.name = obj3DName ; 
			_type = type.toLocaleLowerCase();
			if(_type=="dae")
			{
				var parserCollada:ParserCollada = new ParserCollada();
				parserCollada.parse(embed3dFile);
				if(!_obj3DName){
					_mesh = parserCollada.objects[0] as Mesh;
				}else{
					_mesh = parserCollada.getObjectByName(_obj3DName) as Mesh;
				}
				for( var i:int = 0 ; i<parserCollada.objects.length ; i++)
				{
					if(parserCollada.objects[i] is Mesh)
					{
						addChild(parserCollada.objects[i]);
						uploadResources(parserCollada.objects[i].getResources(false, Geometry));
					}
				}
				//获取动画
				getAnimation(parserCollada,_mesh) ;
			}
			else if(_type=="a3d")
			{
				var parserA3d:ParserA3D = new ParserA3D();
				parserA3d.parse(embed3dFile);
				if(!_obj3DName){
					_mesh = parserA3d.objects[0] as Mesh;
				}else{
					_mesh = parserA3d.getObjectByName(_obj3DName) as Mesh;
				}
				for( i=0 ; i<parserA3d.objects.length ; i++)
				{
					if(parserA3d.objects[i] is Mesh)
					{
						addChild(parserA3d.objects[i]);
						uploadResources(parserA3d.objects[i].getResources(false, Geometry));
					}
				}
			}
			else if(_type=="3ds")
			{
				var parser3ds:Parser3DS = new Parser3DS();
				parser3ds.parse(embed3dFile);
				if(!_obj3DName){
					_mesh = parser3ds.objects[0] as Mesh;
				}else{
					_mesh = parser3ds.getObjectByName(_obj3DName) as Mesh;
				}
				for( i=0 ; i<parser3ds.objects.length ; i++)
				{
					if(parser3ds.objects[i] is Mesh)
					{
						addChild(parser3ds.objects[i]);
						uploadResources(parser3ds.objects[i].getResources(false, Geometry));
					}
				}
			}
			_mesh.setMaterialToAllSurfaces( material );
			_mesh.geometry.upload( Scene3D.context ); 
			uploadResources( material.getResources());
		}
		
		/**
		 * 加载3d资源和贴图 
		 * @param req
		 * @param obj3DName
		 */		
		public function loadRes(req:URLRequest,obj3DName:String):void
		{
			this._req = req ;
			this._obj3DName = obj3DName ;
			this.name = obj3DName ; 
			this._textureFolder = req.url.substring(0, req.url.lastIndexOf("/")+1) ;
			this._type = req.url.substring( req.url.lastIndexOf(".")+1 ).toLocaleLowerCase() ;
			//下载
			var urlLoader:URLLoader= new URLLoader();
			if(_type=="dae"){
				urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			}else if(_type=="a3d" || _type=="3ds"){
				urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			}
			urlLoader.addEventListener(Event.COMPLETE, loadedHandler);
			urlLoader.load(req);
		}
		//3d文件下载完成，开始解析3d文件，获取里面的网格的材质
		private function loadedHandler(e:Event):void
		{
			e.target.removeEventListener(Event.COMPLETE, loadedHandler);
			if(_type=="dae")
			{
				var parserCollada:ParserCollada = new ParserCollada();
				parserCollada.parse(XML((e.target as URLLoader).data),"", true);
				if(!_obj3DName){
					_mesh = parserCollada.objects[0] as Mesh;
				}else{
					_mesh = parserCollada.getObjectByName(_obj3DName) as Mesh;
				}
				for( var i:int = 0 ; i<parserCollada.objects.length ; i++)
				{
					if(parserCollada.objects[i] is Mesh)
					{
						addChild(parserCollada.objects[i]);
						uploadResources(parserCollada.objects[i].getResources(false, Geometry));
					}
				}
				//获取动画
				getAnimation(parserCollada,_mesh) ;
			}
			else if(_type=="a3d")
			{
				var parserA3d:ParserA3D = new ParserA3D();
				parserA3d.parse((e.target as URLLoader).data);
				if(!_obj3DName){
					_mesh = parserA3d.objects[0] as Mesh;
				}else{
					_mesh = parserA3d.getObjectByName(_obj3DName) as Mesh;
				}
				for( i=0 ; i<parserA3d.objects.length ; i++)
				{
					if(parserA3d.objects[i] is Mesh)
					{
						addChild(parserA3d.objects[i]);
						uploadResources(parserA3d.objects[i].getResources(false, Geometry));
					}
				}
			}
			else if(_type=="3ds")
			{
				var parser3ds:Parser3DS = new Parser3DS();
				parser3ds.parse((e.target as URLLoader).data);
				if(!_obj3DName){
					_mesh = parser3ds.objects[0] as Mesh;
				}else{
					_mesh = parser3ds.getObjectByName(_obj3DName) as Mesh;
				}
				for( i=0 ; i<parser3ds.objects.length ; i++)
				{
					if(parser3ds.objects[i] is Mesh)
					{
						addChild(parser3ds.objects[i]);
						uploadResources(parser3ds.objects[i].getResources(false, Geometry));
					}
				}
			}
			//获取贴图地址，并加载
			_textures = new Vector.<ExternalTextureResource>();
			for ( i=0; i < _mesh.numSurfaces; i++) {
				var surface:Surface = _mesh.getSurface(i);
				var material:ParserMaterial = surface.material as ParserMaterial;
				if (material != null) {
					var diffuse:ExternalTextureResource = material.textures["diffuse"];
					var opacity:ExternalTextureResource = material.textures["opacity"];
					if (diffuse != null) {
						diffuse.url = _textureFolder+diffuse.url;
						_textures.push(diffuse);
					}
					if (opacity != null) {
						opacity.url = _textureFolder+opacity.url;
						_textures.push(opacity);
					}
					surface.material = new TextureMaterial(diffuse,opacity);
				}
			}
			var texturesLoader:TexturesLoader = new TexturesLoader(Scene3D.context);
			texturesLoader.addEventListener(Event.COMPLETE , textureLoadedHandler );
			texturesLoader.loadResources(_textures);
		}
		
		private function textureLoadedHandler(e:Event):void
		{
			e.target.removeEventListener(Event.COMPLETE , textureLoadedHandler );
			if(_createdCall!=null){
				_createdCall(this);
				_createdCall = null ;
			}
		}
		
		public function addCallBack(fun:Function):void
		{
			_createdCall = fun ;
		}
		
		/**
		 * 获取动画  
		 * @param parserCollada
		 * @param mesh
		 */		
		private function getAnimation( parserCollada:ParserCollada , mesh:Mesh ):void
		{
			_animation = parserCollada.getAnimationByObject(mesh);
			if(_animation){
				_animationSwitcher = new AnimationSwitcher();
			}
		}
		
		public function addFrame(lable:String , start:Number , end:Number=int.MAX_VALUE):Pivot3D
		{
			if(_animation){
				if(!_animationDic) _animationDic = new Dictionary();
				if(end==int.MAX_VALUE)end = _animation.length ;
				_animationDic[lable] = _animation.slice( start , end );
				if(!_animationSwitcher) _animationSwitcher = new AnimationSwitcher();
				_animationSwitcher.addAnimation( _animationDic[lable] );
			}
			return this ;
		}
		
		/**
		 * 播放动作 
		 * @param label 动作名称 
		 * @param speed 速度
		 */		
		public function playAction( label:String , speed:Number=1 ):void
		{
			if(_animationSwitcher){
				_animationSwitcher.activate( _animationDic[label] , 0.1);
				_animationSwitcher.speed = speed ;
				if(!_animationController) _animationController= new AnimationController();
				_animationController.root = _animationDic[label] ;
			}
		}
		
		/**
		 * 不断更新
		 */		
		public function update():void
		{
			if(_animationController) _animationController.update();
		}
		
		/**
		 * 上传资源到GPU渲染 
		 * @param resources 
		 */		
		public function uploadResources( resources:Vector.<Resource>):void
		{
			for each( var res:Resource in resources){
				res.upload(Scene3D.context);
			}
		}
		
		/**
		 * 清除资源 
		 * @deep true的话会释放材质资源
		 */		
		public function dispose( deep:Boolean ):void
		{
			if(deep){
				for each( var res:Resource in _textures){
					res.dispose();
				}
			}
			_textures = null ;
			_mesh = null ;
			_animationController = null ;
			_animation = null ;
			_animationDic = null ;
			_animationSwitcher = null ;
		}
	}
}