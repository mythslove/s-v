package
{
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	
	public class AvatarTool extends Sprite
	{
		[Embed(source="sprite 85.swf",symbol="Man")]
		private const MAN:Class ;
		[Embed(source="sprite 83.swf",symbol="Man")]
		private const MAN_BA:Class ;
		
		private var loader:Loader ;
		
		public function AvatarTool()
		{
			stage.color = 0xcccccc;
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE , loaded );
			loader.load( new URLRequest("avatar_asset.swf"));
		}
		
		private function loaded( e:Event):void
		{
			var obj:DisplayObject ;
			var skinColor:uint = 0x666666 ;
			var hairColor:uint = 0xffcc00 ;
			var ba:String="";//"_ba";
			
			if(ba){
				var mc:MovieClip = new MAN_BA() as MovieClip;
			}else{
				mc = new MAN() as MovieClip;
			}
			mc.x = stage.stageWidth>>1 ;
			mc.y = 50+stage.stageHeight>>1 ;
			mc.scaleX = mc.scaleY = 4;
			addChild(mc);
			var skins:Vector.<DisplayObject> = ContainerUtil.getChildsByName("skin",mc) ;
			for each( obj in skins )
			{
//				TweenMax.to(obj, 0, {colorMatrixFilter:{colorize:skinColor, amount:1}});
			}
			
			var domain:ApplicationDomain = loader.contentLoaderInfo.applicationDomain;
			
			var shirt:Sprite = ( new (domain.getDefinition("Shirt65"+ba) as Class)) as Sprite;
			obj = shirt.getChildByName("left_hand1") ; obj.x = obj.y = 0 ; //肩
			((mc.getChildByName("left_hand_1") as Sprite) .getChildByName("clothes") as Sprite).addChild(obj) ;
			obj = shirt.getChildByName("left_hand2") ;//膀
			if(obj){
				obj.x = obj.y = 0 ;
				((mc.getChildByName("left_hand_2") as Sprite) .getChildByName("clothes") as Sprite).addChild(obj) ;
			}
			obj = shirt.getChildByName("right_hand1") ; obj.x = obj.y = 0 ;//肩
			((mc.getChildByName("rigth_hand_1") as Sprite) .getChildByName("clothes") as Sprite).addChild(obj) ;
			obj = shirt.getChildByName("right_hand2") ;//膀
			if(obj){
				obj.x = obj.y = 0 ;
				((mc.getChildByName("rigth_hand_2") as Sprite) .getChildByName("clothes") as Sprite).addChild(obj) ;
			}
			obj = shirt.getChildByName("body") ; obj.x = obj.y = 0 ; //身体服装
			((mc.getChildByName("body") as Sprite) .getChildByName("clothes") as Sprite).addChild(obj) ;
			
			
			var pant:Sprite = ( new (domain.getDefinition("Pants26"+ba) as Class)) as Sprite; //下身
			obj = pant.getChildByName("left_crural1") ; obj.x = obj.y = 0 ;
			((mc.getChildByName("left_crura1") as Sprite) .getChildByName("clothes") as Sprite).addChild(obj) ;
			obj = pant.getChildByName("left_crural2") ; obj.x = obj.y = 0 ;
			((mc.getChildByName("left_crura2") as Sprite) .getChildByName("clothes") as Sprite).addChild(obj) ;
			obj = pant.getChildByName("shoes_left") ; obj.x = obj.y = 0 ;
			((mc.getChildByName("left_crura3") as Sprite) .getChildByName("clothes") as Sprite).addChild(obj) ;
			obj = pant.getChildByName("right_crural1") ; obj.x = obj.y = 0 ;
			((mc.getChildByName("right_crura1") as Sprite) .getChildByName("clothes") as Sprite).addChild(obj) ;
			obj = pant.getChildByName("right_crural2") ; obj.x = obj.y = 0 ;
			((mc.getChildByName("right_crura2") as Sprite) .getChildByName("clothes") as Sprite).addChild(obj) ;
			obj = pant.getChildByName("shoes_right") ; obj.x = obj.y = 0 ;
			((mc.getChildByName("right_crura3") as Sprite) .getChildByName("clothes") as Sprite).addChild(obj) ;
			obj = pant.getChildByName("pigu") ; 
			((mc.getChildByName("pigu") as Sprite) .getChildByName("clothes") as Sprite).addChild(obj) ;
			
			
			var head:Sprite = mc.getChildByName("head") as Sprite;
			obj = ( new (domain.getDefinition("hair002"+ba) as Class)) as Sprite; //头发
			((head.getChildByName("hair_mc") as Sprite).getChildByName("clothes") as Sprite).addChild(obj) ;
			TweenMax.to(obj, 0, {colorMatrixFilter:{colorize:hairColor, amount:1}});
			obj = ( new (domain.getDefinition("Hat21"+ba) as Class)) as Sprite; //帽子
			((head.getChildByName("cap") as Sprite).getChildByName("clothes") as Sprite).addChild(obj) ;
			if(!ba){
				obj = ( new (domain.getDefinition("Eyes5"+ba) as Class)) as Sprite; //眼睛
				((head.getChildByName("eyes_mc") as Sprite).getChildByName("clothes") as Sprite).addChild(obj) ;
				obj = ( new (domain.getDefinition("EyeBrow04") as Class)) as Sprite; //眉毛
				((head.getChildByName("eyebrow_mc") as Sprite).getChildByName("clothes") as Sprite).addChild(obj) ;
				obj = ( new (domain.getDefinition("Beard08") as Class)) as Sprite; //胡须
				((head.getChildByName("beard_mc") as Sprite).getChildByName("clothes") as Sprite).addChild(obj) ;
				obj = ( new (domain.getDefinition("Mouth8") as Class)) as Sprite; //嘴
				((head.getChildByName("mouth_mc") as Sprite).getChildByName("clothes") as Sprite).addChild(obj) ;
				obj = ( new (domain.getDefinition("Extra13") as Class)) as Sprite; //其他
				(head.getChildByName("clothes") as Sprite).addChild(obj) ;
			}
			
		}
	}
}