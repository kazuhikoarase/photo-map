package com.d_project.photomap {

    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Matrix;
    import flash.geom.Point;

    /**
     * DirectionButton
     * @author Kazuhiko Arase
     */
    public class DirectionButton extends Sprite {

        private var _size : Number;

        private var _points : Array;

        private var _selected : Boolean;

        public function DirectionButton(type : String, size : Number) {

            this._size = size;
            this.buttonMode = true;
            this._selected = false;
            
            var matrix : Matrix = new Matrix(1, 0, 0, 1, 0, 0);

            switch(type) {

            case Direction.LEFT :
                matrix.rotate(Math.PI);
                break;

            case Direction.FRONT :
                matrix.rotate(-Math.PI / 2);
                break;

            case Direction.RIGHT :
            default :
                break;
            }
            
            _points = [
                new Point(size * -0.35, size * -0.5),
                new Point(size * 0.5, 0),
                new Point(size * -0.35, size * 0.5)
            ];
            for (var i : int = 0; i < _points.length; i++) {
                _points[i] = matrix.transformPoint(_points[i]);
            }

            addEventListener(MouseEvent.MOUSE_OVER, function(e : MouseEvent) : void {
                _selected = true;
            } );

            addEventListener(MouseEvent.MOUSE_OUT, function(e : MouseEvent) : void {
                _selected = false;
            } );
            
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }
        
        private function onEnterFrame(e : Event) : void {

            this.alpha = _selected? 1.0 : 0.8;

            var g : Graphics = graphics;
            g.clear();

            // 本体
            g.lineStyle(1, 0x666666);
            g.beginFill(0xdddddd);
            g.drawRoundRect(-_size, -_size, _size * 2, _size * 2, _size * 0.4, _size* 0.4);
            g.endFill();

            // 方向を表す三角形
            g.lineStyle();
            g.beginFill(0x666666);
            g.moveTo(_points[0].x, _points[0].y);
            g.lineTo(_points[1].x, _points[1].y);
            g.lineTo(_points[2].x, _points[2].y);
            g.endFill();
        }
    }
}