package com.d_project.photomap;

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.GridLayout;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.io.File;
import java.io.IOException;

import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JSplitPane;
import javax.swing.border.TitledBorder;

/**
 * ImagePane
 * @author Kazuhiko Arase
 */
@SuppressWarnings("serial")
class ImagePane extends JPanel {
    
    private MainFrame mainFrame;

    private ImagePaneMainView mainView;
    private ImagePaneEditPane editPane;

    private ImagePaneIconView leftView;
    private ImagePaneIconView frontView;
    private ImagePaneIconView rightView;

    public ImagePane(MainFrame mainFrame) {

        this.mainFrame = mainFrame;

        setLayout(new BorderLayout() );
        
        mainView = new ImagePaneMainView(this);

        leftView  = new ImagePaneIconView(this);
        leftView.setBorder(new TitledBorder("Left") );
        leftView.addMouseListener(new MouseAdapter() {
            public void mousePressed(MouseEvent e) {
                if (e.getClickCount() == 2) {
                    try {
                        toLeft();
                    } catch(IOException ie) {
                        getMainFrame().handleException(ie);
                    }
               }
            }
        });
        
        frontView = new ImagePaneIconView(this);
        frontView.setBorder(new TitledBorder("Front") );
        frontView.addMouseListener(new MouseAdapter() {
            public void mousePressed(MouseEvent e) {
                if (e.getClickCount() == 2) {
                    try {
                        toFront();
                    } catch(IOException ie) {
                        getMainFrame().handleException(ie);
                    }
               }
            }
        });

        rightView = new ImagePaneIconView(this);
        rightView.setBorder(new TitledBorder("Right") );
        rightView.addMouseListener(new MouseAdapter() {
            public void mousePressed(MouseEvent e) {
                if (e.getClickCount() == 2) {
                    try {
                        toRight();
                    } catch(IOException ie) {
                        getMainFrame().handleException(ie);
                    }
               }
            }
        });

        JSplitPane mainPane = new JSplitPane();
        mainPane.setDividerSize(4);
        mainPane.setOrientation(JSplitPane.VERTICAL_SPLIT);
        
        mainPane.setTopComponent(new JScrollPane(mainView) {
            public Dimension getPreferredSize() {
                return new Dimension(400, 300);
            }
        });
        
        editPane = new ImagePaneEditPane();

        mainPane.setBottomComponent(new JScrollPane(editPane) {
            public Dimension getPreferredSize() {
                return new Dimension(100, 100);
            }
        });

        JPanel iconPane = new JPanel();
        iconPane.setLayout(new GridLayout() );
        iconPane.add(leftView);
        iconPane.add(frontView);
        iconPane.add(rightView);

        add("Center", mainPane);
        add("South",  iconPane);
    }

    private void toLeft() throws IOException {
        
        File file = leftView.getFile();
        
        if (file== null) {
            return;
        }

        LinkData nextData = new LinkData(file);

        if (nextData.getValue(LinkData.Keys.RIGHT).length() == 0) {
            String path = FileUtil.getRelativePath(
                mainView.getFile(), file.getParentFile() );
            nextData.setValue(LinkData.Keys.RIGHT, path);
        }

        nextData.save();
            
        mainView.setFile(file);
    }

    private void toFront() throws IOException {
        
        File file = frontView.getFile();
        
        if (file== null) {
            return;
        }

        mainView.setFile(file);
    }

    private void toRight() throws IOException {
        
        File file = rightView.getFile();
        
        if (file== null) {
            return;
        }

        try {
            
            LinkData nextData = new LinkData(file);

            if (nextData.getValue(LinkData.Keys.LEFT).length() == 0) {
                String path = FileUtil.getRelativePath(
                    mainView.getFile(), file.getParentFile() );
                nextData.setValue(LinkData.Keys.LEFT, path);
            }

            nextData.save();
            
        } catch(IOException e) {
            throw new Error(e);
        }
        
        mainView.setFile(file);
    }
    
    public MainFrame getMainFrame() {
        return mainFrame;
    }
    public ImagePaneMainView getMainView() {
        return mainView;
    }
    
    public ImagePaneEditPane getEditPane() {
        return editPane;
    }
    
    public ImagePaneIconView getLeftView() {
        return leftView;
    }
    public ImagePaneIconView getFrontView() {
        return frontView;
    }
    public ImagePaneIconView getRightView() {
        return rightView;
    }
    
}
        