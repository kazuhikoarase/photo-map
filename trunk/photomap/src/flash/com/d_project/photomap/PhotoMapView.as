package com.d_project.photomap {

    import flash.display.Bitmap;
    import flash.display.Graphics;
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.net.URLLoader;
    import flash.net.URLRequest;

    /**
     * PhotoMapView
     * @author Kazuhiko Arase
     */
    public class PhotoMapView extends Sprite {

        private static const XML_EXT : String = ".xml"; 
            
        private var _url : String;

        private var _data : XML;

        private var _lastBitmap : Bitmap;

        private var _currBitmap : Bitmap;

        private var _lastCanvas : Sprite;

        private var _currCanvas : Sprite;

        private var _status : String;

        private var _step : Number;
        
        private var _direction : String;
        
        private var _perspectiveLevel : Number;

        public var explicitWidth : Number;

        public var explicitHeight : Number;
        
        public function PhotoMapView() {
            
            explicitWidth = 320;
            explicitHeight = 240;
            _perspectiveLevel = 0.0015;
            _step = 0;
            _direction = null;

            _lastBitmap = null;
            _currBitmap = null;

            _lastCanvas = new Sprite();
            _lastCanvas.mask = new Sprite();
            
            _currCanvas = new Sprite();
            _currCanvas.mask = new Sprite();

            addChild(_lastCanvas);
            addChild(_lastCanvas.mask);
            addChild(_currCanvas);
            addChild(_currCanvas.mask);

            _status = Status.IDLE;
            addEventListener(Event.ENTER_FRAME, enterFrameHandler);
        }
		
		public function get url() : String {
			return _url;
		}
		
        public function get title() : String {
            return _data.title;
        }

        public function get description() : String {
            var s : String = _data.description;
            if (!isEmpty(s) ) {
                // CRLF を LF に変換
                s = s.replace(/\r\n/g, "\n");
            }
            return s;
        }

        public function toLeft() : void {
            _direction = Direction.LEFT;
            load(buildURL(_data.left) );
        }

        public function toFront() : void {
            _direction = Direction.FRONT;
            load(buildURL(_data.front) );
        }

        public function toRight() : void {
            _direction = Direction.RIGHT;
            load(buildURL(_data.right) );
        }

        public function hasLeft() : Boolean {
            return !isBusy() && _data != null && !isEmpty(_data.left);
        }

        public function hasFront() : Boolean {
            return !isBusy() && _data != null && !isEmpty(_data.front);
        }

        public function hasRight() : Boolean {
            return !isBusy() && _data != null && !isEmpty(_data.right);
        }

        private function isEmpty(s : String) : Boolean {
            return (s == null || s.length == 0);
        }

        private function isBusy() : Boolean {
            return _status != Status.IDLE;
        }

        public function load(url : String) : void {
            
            if (isBusy() ) {
                return;
            }
            
            this._url = url;
            
            // XMLデータロード開始
            var xmlLoader : URLLoader = new URLLoader();
            xmlLoader.addEventListener(Event.COMPLETE, xmlLoader_completeHandler);
            xmlLoader.load(new URLRequest(url + XML_EXT) );

            _status = Status.LOADING;
        }

        private function xmlLoader_completeHandler(event : Event) : void {

            var xmlLoader : URLLoader = URLLoader(event.target);
            _data = XML(xmlLoader.data);

            // 画像データロード開始
            var loader : Loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loader_completeHandler);
            loader.load(new URLRequest(buildURL(_data.name) ) );
        }

        private function loader_completeHandler(event : Event) : void {

            var loaderInfo : LoaderInfo = LoaderInfo(event.target);
            _lastBitmap = _currBitmap;
            _currBitmap = Bitmap(loaderInfo.content);

            _status = Status.LOAD_COMPLETE;
        }

        private function enterFrameHandler(event : Event) : void {

            drawMask(Sprite(_lastCanvas.mask) );
            drawMask(Sprite(_currCanvas.mask) );
            
            switch(_status) {

            case Status.LOADING :
                break;

            case Status.LOAD_COMPLETE :
                _step = 0;
                _status = Status.WALKING;
                updateImages();
                dispatchEvent(new PhotoMapEvent(PhotoMapEvent.LOAD_COMPLETE) );
                break;
                    
            case Status.WALKING :
                _step = _step + 5;
                if (_step > 100) {
                    _step = 100;
                    _status = Status.WALK_COMPLETE;
                }
                updateImages();
                break;

            case Status.WALK_COMPLETE :
                _lastBitmap = null;
                _status = Status.IDLE;
                dispatchEvent(new PhotoMapEvent(PhotoMapEvent.WALK_COMPLETE) );
                break;

            case Status.IDLE :
                break;

            default :
                break;
            }
        }

        private function updateImages() : void {

            switch(_direction) {

            case Direction.LEFT :
                updateLeftImages();
                break;

            case Direction.FRONT :
                updateFrontImages();      
                break;

            case Direction.RIGHT :
                updateRightImages();   
                break;

            default :
                updateDefaultImages();
                break;
            }
        }

        private function updateLeftImages() : void {

            // PI ~ PI / 2
            var theta : Number = Math.PI - Math.PI * _step / 200;
            updateRotateImages(_currCanvas, _currBitmap, theta);

            if (_lastBitmap != null) {
                updateRotateImages(_lastCanvas, _lastBitmap, theta - Math.PI / 2);
            }
        }

        private function updateRightImages() : void {

            // 0 ~ PI / 2
            var theta : Number = Math.PI * _step / 200;
            updateRotateImages(_currCanvas, _currBitmap, theta);

            if (_lastBitmap != null) {
                updateRotateImages(_lastCanvas, _lastBitmap, theta + Math.PI / 2);
            }
        }

        private function updateFrontImages() : void {

            updateLinerImages(_currCanvas, _currBitmap, 0.5 + _step / 200, _step / 100);

            if (_lastBitmap != null) {
                updateLinerImages(_lastCanvas, _lastBitmap, 1 + _step / 100, 1);
            }
        }

        private function updateDefaultImages() : void {

            updateLinerImages(_currCanvas, _currBitmap, 1, _step / 100);

            if (_lastBitmap != null) {
                updateLinerImages(_lastCanvas, _lastBitmap, 1, 1 - _step / 100);
            }
        }

        private function updateLinerImages(canvas : Sprite, bitmap : Bitmap, scale : Number, alpha : Number) : void {

            var rect : Rectangle = getImageRect(bitmap);

            var x1 : Number = explicitWidth / 2 - rect.width / 2 * scale;
            var x2 : Number = explicitWidth / 2 + rect.width / 2 * scale;
            var y1 : Number = explicitHeight / 2 - rect.height / 2 * scale;
            var y2 : Number = explicitHeight / 2 + rect.height / 2 * scale;
            
            drawBitmap(
                canvas, bitmap,
                new Point(x1, y1),
                new Point(x2, y1),
                new Point(x1, y2),
                new Point(x2, y2),
                alpha
            );
        }
        
        private function updateRotateImages(canvas : Sprite, bitmap : Bitmap, theta : Number) : void {
            
            var rect : Rectangle = getImageRect(bitmap);
            var pos : Object = calcRotatePosition(theta, rect);
            var sc1 : Number = (explicitWidth / 2 - pos.y1) * _perspectiveLevel + 1;
            var sc2 : Number = (explicitWidth / 2 - pos.y2) * _perspectiveLevel + 1;

            drawBitmap(
                canvas, bitmap,
                new Point(explicitWidth / 2 + pos.x1 * sc1, explicitHeight / 2 - rect.height / 2 * sc1),
                new Point(explicitWidth / 2 + pos.x2 * sc2, explicitHeight / 2 - rect.height / 2 * sc2),
                new Point(explicitWidth / 2 + pos.x1 * sc1, explicitHeight / 2 + rect.height / 2 * sc1),
                new Point(explicitWidth / 2 + pos.x2 * sc2, explicitHeight / 2 + rect.height / 2 * sc2),
                1
            );
        }

        private function drawBitmap(
            canvas : Sprite,
            bitmap : Bitmap,
            p0 : Point, p1 : Point,
            p2 : Point, p3 : Point,
            alpha : Number
        ) : void {
            
            canvas.alpha = alpha;

            var g : Graphics = canvas.graphics;

            g.clear();
            
            TransformUtil.drawBitmapQuadrangle(
                g, bitmap.bitmapData,
                new Point(0, 0),
                new Point(bitmap.width, 0),
                new Point(0, bitmap.height),
                new Point(bitmap.width, bitmap.height),
                p0, p1, p2, p3
            );
        }
        
        /**
         * 現在の URL とからの相対 URL を組み立てる
         * @param relativeURL 相対 URL
         */
        private function buildURL(relativeURL : String) : String {

            // ディレクトリ組み立て
            var i : int = _url.lastIndexOf("/");
            var dir : String = (i != -1)? _url.substring(0, i) : _url;

            return trimURL(dir + "/" + relativeURL);
        }        

        private function trimURL(url : String) : String {

            // 'path/../' を削除
            var regexp : RegExp = /[^\/]+\/\.\.\//g;
            while (url.match(regexp).length > 0) {
                url = url.replace(regexp, "");
            }

            return url;
        }        

        private function drawMask(mask : Sprite) : void {
            mask.graphics.clear();
            mask.graphics.beginFill(0xffffff);
            mask.graphics.drawRect(0, 0, explicitWidth, explicitHeight);
            mask.graphics.endFill();
        }

        private function calcRotatePosition(theta : Number, rect : Rectangle) : Object {

            var cs : Number = Math.cos(theta);
            var sn : Number = Math.sin(theta);

            return {
                x1 : cs * explicitWidth / 2 - sn * rect.width / 2,
                y1 : sn * explicitWidth / 2 + cs * rect.width / 2,
                x2 : cs * explicitWidth / 2 - sn * -rect.width / 2,
                y2 : sn * explicitWidth / 2 + cs * -rect.width / 2
            }
        }

        private function getImageRect(bitmap : Bitmap) : Rectangle {

            var w : Number = bitmap.width;
            var h : Number = bitmap.height;

            if (w / h > explicitWidth / explicitHeight) {
                // 幅に合わせる
                return new Rectangle(0, 0, explicitWidth, explicitWidth * h / w);
            } else {
                // 高さに合わせる
                return new Rectangle(0, 0, explicitHeight * w / h, explicitHeight);
            }
        }
    }
}

final class Status {

    public static const IDLE : String = "idle"; 

    public static const LOADING : String = "loading"; 

    public static const LOAD_COMPLETE : String = "loadComplete"; 

    public static const WALKING : String = "walking"; 

    public static const WALK_COMPLETE : String = "walkComplete"; 
}
