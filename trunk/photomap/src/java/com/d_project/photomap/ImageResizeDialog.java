package com.d_project.photomap;

import java.awt.event.ActionEvent;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.io.File;
import java.io.IOException;
import java.text.DecimalFormat;

import javax.swing.AbstractAction;
import javax.swing.Action;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JPanel;
import javax.swing.JProgressBar;
import javax.swing.border.EmptyBorder;

/**
 * ImageResizeDialog
 * @author Kazuhiko Arase
 */
@SuppressWarnings("serial")
public class ImageResizeDialog extends JDialog {

    private JProgressBar progress;
    private transient Thread thread;
    private File[] files;
    private boolean alive = false;

    public ImageResizeDialog(MainFrame mainFrame, File dir) {

        super(mainFrame, true);
        
        files = dir.listFiles(new ImageFileFilter() );
        
        progress = new JProgressBar(0, files.length);
        progress.setBorder(new EmptyBorder(4, 4, 4, 4) );
        progress.setString("");
        progress.setStringPainted(true);

        Action exitAction = new AbstractAction() {
            public void actionPerformed(ActionEvent e) {
                alive = false;    
            }
        };
        exitAction.putValue(Action.NAME, "Cancel");
                
        JPanel p = new JPanel();
        p.add(new JButton(exitAction) );
        getContentPane().add("Center", progress);
        getContentPane().add("South", p);

        addWindowListener(new WindowAdapter() {
            public void windowOpened(WindowEvent e) {
                thread = new Thread(new Runnable() {
                    public void run() {
                        task();
                    }
                });
        
                thread.start();
            }
        });
        
        setDefaultCloseOperation(DO_NOTHING_ON_CLOSE);
    }

    private void task() {

        alive = true;

        LinkData.setImageLock(true);
        
        try {
            
            long startTime = System.currentTimeMillis();
            
            for (int i = 0; i < files.length; i++) {

                if (!alive) break;
                
                LinkData linkData = new LinkData(files[i]);
                linkData.resizeImage();
                
                progress.setValue(i + 1);

                long time = System.currentTimeMillis() - startTime;
                long leftMin = (time * (files.length - (i + 1) ) / (i + 1) ) / 1000;

                String ts = (leftMin / 60)
                     + ":"
                     + new DecimalFormat("00").format(leftMin % 60);
                
                progress.setString( (i + 1) + "/" + files.length + " " + ts);

            }


        } catch(IOException e) {

        } finally {
            LinkData.setImageLock(false);
            dispose();
        }
    }
    
    
}
