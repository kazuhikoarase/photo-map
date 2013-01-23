package {
	
	import com.d_project.photomap.Direction;
	import com.d_project.photomap.DirectionButton;
	import com.d_project.photomap.Loading;
	import com.d_project.photomap.PhotoMapEvent;
	import com.d_project.photomap.PhotoMapView;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	
	/**
	 * photomap
	 * @author Kazuhiko Arase
	 */
	public class PhotoMap extends Sprite {
		
		private var photoMapView : PhotoMapView;
		
		private var loading : Loading;
		
		private var titleText : TextField;
		
		private var memoText : TextField;
		
		private var buttonPane : Sprite;
		
		private var leftButton : DirectionButton;
		
		private var frontButton : DirectionButton;
		
		private var rightButton : DirectionButton;
		
		private var step : int;
		
		private var status : String;
		
		private var mouseLeave : Boolean;
		
		public function PhotoMap() {
			
			// コンポーネントを作成する。
			createComponents();
			
			// 読み込み中を非表示にする。
			hideLoading();
			
			// コントロール類を非表示にする。
			hideControls();
			
			// マウス制御
			mouseLeave = false;
			stage.addEventListener(MouseEvent.MOUSE_OVER, function (e : Event) : void {
				mouseLeave = false;
			} );
			stage.addEventListener(Event.MOUSE_LEAVE, function (e : Event) : void {
				mouseLeave = true;
			} );
			
			// キー操作用    
			stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e : KeyboardEvent) : void {
				
				switch(e.keyCode) {
					
					case Keyboard.LEFT :
						toLeft();
						break;
					
					case Keyboard.UP :
						toFront();
						break;
					
					case Keyboard.RIGHT :
						toRight();
						break;
					
					default :
						break;
				}
			} );
			
			// 既定のURLを取得する
			var defaultUrl : String = this.loaderInfo.parameters.defaultUrl;
			if (defaultUrl == null) {
				defaultUrl = "sample/DSCF0001.JPG";
			}
			
			buttonPane.alpha = 0;
			step = 0;
			status = Status.STOP;
			
			showLoading();
			photoMapView.load(defaultUrl);
		}
		
		private function createComponents() : void {
			
			// 明示的なサイズ(コンパイル時の設定値と同じ)    
			var explicitWidth : Number = 400;
			
			var explicitHeight : Number = 500;
			
			// 余白
			var gap : Number = 5;
			
			// ボタンのサイズ
			var buttonSize : Number = 10;
			
			// タイトルのフォントサイズ
			var titleFontSize : Number = 14;
			
			// メモのフォントサイズ
			var memoFontSize : Number = 12;
			
			photoMapView = new PhotoMapView();
			photoMapView.x = 0;
			photoMapView.y = gap;
			photoMapView.explicitWidth = 400;
			photoMapView.explicitHeight = 300;
			photoMapView.addEventListener(PhotoMapEvent.LOAD_COMPLETE, function (e : Event) : void {
				hideLoading();
			});
			photoMapView.addEventListener(PhotoMapEvent.WALK_COMPLETE, function (e : Event) : void {
				showControls();
			});
			addChild(photoMapView);
			
			// ボタン領域
			buttonPane = new Sprite();
			buttonPane.x = explicitWidth / 2;
			buttonPane.y = gap + photoMapView.explicitHeight - (buttonSize + gap);
			buttonPane.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addChild(buttonPane);
			
			// 「左へ」ボタン
			leftButton = new DirectionButton(Direction.LEFT, buttonSize);
			leftButton.x = - (buttonSize * 2 + gap);
			leftButton.y = 0;
			leftButton.addEventListener(MouseEvent.CLICK, function(e : MouseEvent) : void {
				toLeft();
			});
			buttonPane.addChild(leftButton);
			
			// 「前へ」ボタン
			frontButton = new DirectionButton(Direction.FRONT, buttonSize);
			frontButton.x = 0;
			frontButton.y = 0;
			frontButton.addEventListener(MouseEvent.CLICK, function(e : MouseEvent) : void {
				toFront();
			});
			buttonPane.addChild(frontButton);
			
			// 「右へ」ボタン
			rightButton = new DirectionButton(Direction.RIGHT, buttonSize);
			rightButton.x = (buttonSize * 2 + gap);
			rightButton.y = 0;
			rightButton.addEventListener(MouseEvent.CLICK, function(e : MouseEvent) : void {
				toRight();
			});
			buttonPane.addChild(rightButton);
			
			// loading... 表示
			loading = new Loading();
			loading.x = explicitWidth / 2 - loading.textWidth / 2;
			loading.y = gap + photoMapView.explicitHeight + gap * 5;
			addChild(loading);
			
			// 文字表示
			var txtYPos : Number = gap + photoMapView.explicitHeight + gap;
			
			titleText = new TextField();
			titleText.x = 0;
			titleText.y = txtYPos;
			titleText.width = explicitWidth;
			titleText.defaultTextFormat = new TextFormat("Verdana", titleFontSize, 0x000000, true);
			addChild(titleText);
			
			txtYPos += titleFontSize + gap;
			
			memoText = new TextField();
			memoText.x = 0;
			memoText.y = txtYPos;
			memoText.width = explicitWidth;
			memoText.height = explicitHeight - gap - txtYPos;
			memoText.multiline = true;
			memoText.defaultTextFormat = new TextFormat("Verdana", memoFontSize, 0x000000);
			addChild(memoText);
			
			
		}
		
		private function toLeft() : void {
			if (photoMapView.hasLeft() ) {
				hideControls();
				showLoading();
				photoMapView.toLeft();
			}
		}
		
		private function toFront() : void {
			if (photoMapView.hasFront() ) {
				hideControls();
				showLoading();
				photoMapView.toFront();
			}
		}
		
		private function toRight() : void {
			if (photoMapView.hasRight() ) {
				hideControls();
				showLoading();
				photoMapView.toRight();
			}
		}
		
		private function showControls() : void {
			titleText.text = photoMapView.title;
			memoText.text = photoMapView.memo;
			leftButton.visible = photoMapView.hasLeft();
			frontButton.visible = photoMapView.hasFront();
			rightButton.visible = photoMapView.hasRight();
		}
		
		private function hideControls() : void {
			titleText.text = "";
			memoText.text = "";
			leftButton.visible = false;
			frontButton.visible = false;
			rightButton.visible = false;
		}
		
		private function showLoading() : void {
			loading.start();
		}
		
		private function hideLoading() : void {
			loading.stop();
		}
		
		private function onEnterFrame(e : Event) : void {
			
			if (!mouseLeave && photoMapView.hitTestPoint(photoMapView.mouseX, photoMapView.mouseY, true) ) {
				// ビュー上にマウスがある場合はフェードインする。
				status = Status.FADE_IN;
			}
			
			switch(status) {
				
				case Status.FADE_IN :
					step += 2;
					if (step >= 20) {
						// フェードイン終了 > フェードアウト
						step = 20;
						status = Status.FADE_OUT;
					}
					buttonPane.alpha = step / 20;
					break;
				
				case Status.FADE_OUT :
					step--;
					if (step <= 0) {
						// フェードアウト終了 > 停止
						step = 0;
						status = Status.STOP;
					}
					buttonPane.alpha = step / 20;
					break;
				
				case Status.STOP :
				default :
					break;
			}
		}
	}
}

final class Status {
	
	public static const STOP : String = "stop";
	
	public static const FADE_IN : String = "fadeIn";
	
	public static const FADE_OUT : String = "fadeOut";
}
