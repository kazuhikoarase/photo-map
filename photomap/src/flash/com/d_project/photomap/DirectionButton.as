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

        private var size : Number;

        private var points : Array;

        private var selected : Boolean;

        public function DirectionButton(type : String, size : Number) {

            this.size = size;
            this.buttonMode = true;
            this.selected = false;
            
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
            
            points = [
                new Point(size * -0.35, size * -0.5),
                new Point(size * 0.5, 0),
                new Point(size * -0.35, size * 0.5)
            ];
            for (var i : int = 0; i < points.length; i++) {
                points[i] = matrix.transformPoint(points[i]);
            }

            addEventListener(MouseEvent.MOUSE_OVER, function(e : MouseEvent) : void {
                selected = true;
            } );

            addEventListener(MouseEvent.MOUSE_OUT, function(e : MouseEvent) : void {
                selected = false;
            } );
            
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }
        
        private function onEnterFrame(e : Event) : void {

            this.alpha = selected? 1.0 : 0.8;

            var g : Graphics = graphics;
            g.clear();

            // 本体
            g.lineStyle(1, 0x666666);
            g.beginFill(0xdddddd);
            g.drawRoundRect(-size, -size, size * 2, size * 2, size * 0.4, size* 0.4);
            g.endFill();

            // 方向を表す三角形
            g.lineStyle();
            g.beginFill(0x666666);
            g.moveTo(points[0].x, points[0].y);
            g.lineTo(points[1].x, points[1].y);
            g.lineTo(points[2].x, points[2].y);
            g.endFill();
        }
    }
}