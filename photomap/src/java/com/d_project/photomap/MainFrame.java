package com.d_project.photomap;

import java.awt.event.ActionEvent;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.io.File;
import java.io.IOException;

import javax.swing.AbstractAction;
import javax.swing.Action;
import javax.swing.JFrame;
import javax.swing.JList;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JOptionPane;
import javax.swing.JPopupMenu;
import javax.swing.JSplitPane;
import javax.swing.event.MenuEvent;
import javax.swing.event.MenuListener;

/**
 * MainFrame
 * @author Kazuhiko Arase
 */
@SuppressWarnings("serial")
class MainFrame extends JFrame {

    private ImageChooser imageChooser;
    private ImagePane imagePane;

    private Action resizeAllImagesAction;
    private Action exitAction;
    
    public MainFrame() {

        setTitleIndirect(null);

        File rootFile;

        try {
            rootFile = new File(".").getCanonicalFile();
        } catch(IOException e) {
            throw new Error(e);
        }


        resizeAllImagesAction = new AbstractAction() {
            public void actionPerformed(ActionEvent e) {
                resizeAllImages();
            }
        };
        resizeAllImagesAction.putValue(Action.NAME, "Resize All Images");
        resizeAllImagesAction.putValue(Action.MNEMONIC_KEY, Integer.valueOf('R') );
        
        exitAction = new AbstractAction() {
            public void actionPerformed(ActionEvent e) {
                exit();
            }
        };
        exitAction.putValue(Action.NAME, "Exit");
        exitAction.putValue(Action.MNEMONIC_KEY, Integer.valueOf('X') );

        
        MenuListener menuListener = new MenuListener() {
            public void menuSelected(MenuEvent e) {
                updateActionStatus();
            }
            public void menuCanceled(MenuEvent e) {
            }
            public void menuDeselected(MenuEvent e) {
            }
        };
        
        JMenu menu = new JMenu("File");
        menu.setMnemonic('F');
        menu.add(resizeAllImagesAction);
        menu.add(exitAction);
        menu.addMenuListener(menuListener);

        JMenuBar menuBar = new JMenuBar();
        menuBar.add(menu);
        setJMenuBar(menuBar);

        imageChooser = new ImageChooser(rootFile);
        imageChooser.getTree().addMouseListener(
            new MouseAdapter() {
                public void mouseClicked(MouseEvent e) {
                    if (e.isMetaDown() ) {
                        updateActionStatus();
                        JPopupMenu treePopupMenu = new JPopupMenu();
                        treePopupMenu.add(resizeAllImagesAction);
                        treePopupMenu.show(e.getComponent(), e.getX(), e.getY() );
                    }
                }
            }
        );
        
        imageChooser.getList().addMouseListener(
            new MouseAdapter() {

                public void mousePressed(MouseEvent e) {
                    if (e.getClickCount() == 2) {
                        File file = (File)imageChooser.getList().getSelectedValue();
                        try {
                            imagePane.getMainView().setFile(file);
                        } catch(IOException ie) {
                            handleException(ie);
                        }
                    }
                }
            }
        );
        
        imageChooser.getList().setTransferHandler(
            new DnDEventTransferHandler() {

                protected DnDEvent exportEvent() {
                    JList list = getImageChooser().getList();
                    return new DnDEvent(list, list.getSelectedValue() );
                }
    
                protected void importEvent(DnDEvent e) {
                    if (e.getSource() instanceof ImagePaneIconView) {
                        ImagePaneIconView view = (ImagePaneIconView)e.getSource();
                        try {
                            view.setFile(null);
                        } catch(IOException ie) {
                            handleException(ie);
                        }
                    }                
                }
            }
        );
        
        DnDTrigger.attach(imageChooser.getList() );        

        imagePane = new ImagePane(this);

        JSplitPane mainPane = new JSplitPane();
        mainPane.setOrientation(JSplitPane.HORIZONTAL_SPLIT);
        mainPane.setTopComponent(imageChooser);
        mainPane.setBottomComponent(imagePane);
        mainPane.setDividerSize(4);
        
        getContentPane().add(mainPane);
        setDefaultCloseOperation(EXIT_ON_CLOSE);

        addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                exit();
            }
        });
    }
    
    public void setTitleIndirect(String title) {

        String appName = "PhotoMap";

        if (title != null) {
            setTitle(appName + " - " + title);
        } else {
            setTitle(appName);
        }
        
    }
    
    private void updateActionStatus() {
        resizeAllImagesAction.setEnabled(imageChooser.getSelectedDirectory() != null);
    }
        
    public ImageChooser getImageChooser() {
        return imageChooser;
    }
    
    public ImagePane getImagePane() {
        return imagePane;
    }
    
    public void handleException(Throwable t) {

        t.printStackTrace();

        JOptionPane.showMessageDialog(this,
            t.getMessage(),
            "",
            JOptionPane.ERROR_MESSAGE);
    }

    private void resizeAllImages() {
        
        File dir = imageChooser.getSelectedDirectory();
        
        if (dir == null) return;
        
        ImageResizeDialog dialog = new ImageResizeDialog(this, dir);
        dialog.pack();
        dialog.setVisible(true);
        
    }

    private void exit() {

        try {
            getImagePane().getMainView().setFile(null);
        } catch(Throwable t) {
            handleException(t);
        }
        
        System.exit(0);
    }
    
        
}
