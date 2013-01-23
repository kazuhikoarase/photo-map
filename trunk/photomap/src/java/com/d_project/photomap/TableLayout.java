package com.d_project.photomap;

import java.awt.Component;
import java.awt.Container;
import java.awt.*;

/**
 * TableLayout
 * @author Kazuhiko Arase
 */
public class TableLayout implements LayoutManager {

    private int hgap;
    private int vgap;

    public TableLayout(int hgap, int vgap) {
        this.hgap = hgap;
        this.vgap = vgap;
    }
    
    public void addLayoutComponent(String name, Component comp) {
    }

    public void removeLayoutComponent(Component comp) {
    }

    public void layoutContainer(Container parent) {

        int labelWidth = 0;
        int fieldWidth = 0;
        
        for (int i = 0; i < parent.getComponentCount(); i += 2) {
            Component c1 = parent.getComponent(i);
            Component c2 = (i + 1 < parent.getComponentCount() )?
                parent.getComponent(i + 1) : null;
            Dimension s1 = c1.getPreferredSize();
            Dimension s2 = (c2 != null)? c2.getPreferredSize() : new Dimension(0, 0);
            labelWidth = Math.max(labelWidth, s1.width);
            fieldWidth = Math.max(fieldWidth, s2.width);
        }
        
        Insets insets = parent.getInsets();
        int y = insets.top;

        for (int i = 0; i < parent.getComponentCount(); i += 2) {
            Component c1 = parent.getComponent(i);
            Component c2 = (i + 1 < parent.getComponentCount() )?
                parent.getComponent(i + 1) : null;
            Dimension s1 = c1.getPreferredSize();
            Dimension s2 = (c2 != null)? c2.getPreferredSize() : new Dimension(0, 0);

            c1.setBounds(insets.left, y, s1.width, s1.height);
            c2.setBounds(insets.left + labelWidth + hgap, y, s2.width, s2.height);
            y += Math.max(s1.height, s2.height) + vgap;
        }

    }

    public Dimension minimumLayoutSize(Container parent) {
        return new Dimension(50, 50);
    }

    public Dimension preferredLayoutSize(Container parent) {

        int labelWidth = 0;
        int fieldWidth = 0;
        int width = 0;
        int height = 0;
        
        for (int i = 0; i < parent.getComponentCount(); i += 2) {
            Component c1 = parent.getComponent(i);
            Component c2 = (i + 1 < parent.getComponentCount() )?
                parent.getComponent(i + 1) : null;
            Dimension s1 = c1.getPreferredSize();
            Dimension s2 = (c2 != null)? c2.getPreferredSize() : new Dimension(0, 0);
            labelWidth = Math.max(labelWidth, s1.width);
            fieldWidth = Math.max(fieldWidth, s2.width);
            height += Math.max(s1.height, s2.height) + vgap;
        }

        width = labelWidth + hgap + fieldWidth;

        Insets insets = parent.getInsets();
        width  += insets.left + insets.right;
        height += insets.top + insets.bottom;

        return new Dimension(width, height);
    }
}
