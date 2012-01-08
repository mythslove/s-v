package bing.mvc.core
{
	import bing.ds.HashMap;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	import bing.mvc.interfaces.IContext;
	import bing.mvc.interfaces.IContextEvtMap;
	import bing.mvc.interfaces.IMediator;
	import bing.mvc.interfaces.IModel;
	
	/**
	 * MVC环境 
	 * @author zhouzhanglin
	 */	
	public class Context extends EventDispatcher implements IContext,IContextEvtMap
	{
		public var contextView:DisplayObjectContainer;
		private var _mediatorHash:HashMap ;
		private var _modelHash:HashMap ;
		
		public function Context( displayObjectContainer:DisplayObjectContainer )
		{
			this.contextView = displayObjectContainer ;
			this._mediatorHash = new HashMap();
			this._modelHash = new HashMap();
			preStart();
			if(this.contextView.stage)
			{
				startUp();
			}
			else
			{
				contextView.addEventListener(Event.ADDED_TO_STAGE , addToStage);
			}
		}
		
		private function addToStage(e:Event):void 
		{
			contextView.removeEventListener(Event.ADDED_TO_STAGE , addToStage);
			startUp();
		}
		
		/**
		 * 已经addToStage
		 */		
		public function startUp():void
		{
		}
		
		/**
		 * 初始化完成，但未addToStage 
		 */		
		public function preStart():void 
		{
			
		}

		public function registerMeditor(mediator:IMediator):void 
		{
			_mediatorHash.put( this.getName(mediator) , mediator );
		}
		
		public function retrieveMediator(className:Class):IMediator
		{
			return _mediatorHash.getValue( this.getName(className) ) as IMediator;
		}

		public function hasMediatorByName(className:Class):Boolean
		{
			return _mediatorHash.containsKey( this.getName(className) );
		}
		
		public function hasMediator(mediator:IMediator):Boolean
		{
			return _mediatorHash.containsKey( this.getName(mediator) );
		}

		public function removeMediatorByName(className:Class):void
		{
			_mediatorHash.remove( this.getName(className) );
		}
		
		public function removeMediator( mediator:IMediator ):void 
		{
			_mediatorHash.remove( this.getName(mediator) );
		}

		public function registerModel(model:IModel):void 
		{
			_modelHash.put( this.getName(model) , model );
		}
		
		public function retrieveModel(className:Class):IModel
		{
			return _modelHash.getValue( this.getName(className) ) as IModel;
		}
		
		public function hasModelByName(className:Class):Boolean
		{
			return _modelHash.containsKey( this.getName(className) );
		}
		
		public function hasModel(model:IModel):Boolean
		{
			return _modelHash.containsKey( this.getName(model) );
		}
		
		public function removeModelByName(className:Class):void
		{
			_modelHash.remove( this.getName(className) );
		}
		
		public function removeModel( model:IModel ):void 
		{
			_modelHash.remove( this.getName(model) );
		}
		
		/**
		 * 侦听全局事件 
		 * @param type
		 * @param callFun
		 */		
		public function addContextListener( type:String , callFun:Function ):void
		{
			this.addEventListener( type,callFun );
		}
		
		/**
		 * 抛出全局事件 
		 * @param event
		 */		
		public function dispatchContextEvent( event:Event):void
		{
			this.dispatchEvent(event);
		}
		
		/**
		 * 移除全局侦听 
		 * @param type
		 * @param callFun
		 */		
		public function removeContextListener(type:String , callFun:Function):void 
		{
			this.removeEventListener(type,callFun);
		}
		
		public function getName( obj:* ):String 
		{
			var name:String  = getQualifiedClassName(obj);
			return name.substring( name.lastIndexOf(":")+1);
		}
	}
}