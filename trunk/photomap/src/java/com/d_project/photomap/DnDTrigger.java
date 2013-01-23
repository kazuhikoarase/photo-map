package com.d_project.photomap;

import java.awt.dnd.DnDConstants;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionListener;

import javax.swing.JComponent;

/**
 * DnDTrigger
 * @author Kazuhiko Arase
 */
public class DnDTrigger implements MouseListener, MouseMotionListener {

    private JComponent comp;
    private boolean triggered;

    private DnDTrigger(JComponent comp) {
        this.comp = comp;
        this.triggered = false;
    }
    
    public void mousePressed(MouseEvent e) {
        this.triggered = false;
    }
    
    public void mouseDragged(MouseEvent e) {
        if (!triggered) {
           comp.getTransferHandler().exportAsDrag(comp, e, DnDConstants.ACTION_COPY);
           triggered = true;
        }
    }
    
    public void mouseEntered(MouseEvent e) {}
    public void mouseExited(MouseEvent e) {}
    public void mouseReleased(MouseEvent e) {}
    public void mouseClicked(MouseEvent e) {}
    public void mouseMoved(MouseEvent e) {}

    public static void attach(JComponent comp) {
        DnDTrigger dt = new DnDTrigger(comp);
        comp.addMouseListener(dt);
        comp.addMouseMotionListener(dt);
    }
}
