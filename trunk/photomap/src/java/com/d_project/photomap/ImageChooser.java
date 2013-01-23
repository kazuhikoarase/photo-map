package com.d_project.photomap;

import java.awt.Dimension;
import java.io.File;
import java.util.ArrayList;
import java.util.List;

import javax.swing.DefaultListModel;
import javax.swing.JList;
import javax.swing.JScrollPane;
import javax.swing.JSplitPane;
import javax.swing.JTree;
import javax.swing.event.TreeSelectionEvent;
import javax.swing.event.TreeSelectionListener;
import javax.swing.tree.DefaultTreeModel;
import javax.swing.tree.TreeNode;
import javax.swing.tree.TreePath;

/**
 * ImageChooser
 * @author Kazuhiko Arase
 */
@SuppressWarnings("serial")
public class ImageChooser extends JSplitPane {

    private JTree tree;
    private JList list;
    private File rootFile;
    
    public ImageChooser(File rootFile) {
        
        this.rootFile = rootFile;

        setOrientation(HORIZONTAL_SPLIT);
        setDividerSize(4);
        
        TreeNode rootNode = new FileTreeNode(rootFile);

        tree = new JTree(new DefaultTreeModel(rootNode) );
        tree.setRootVisible(false);

        tree.getSelectionModel().addTreeSelectionListener(new TreeSelectionListener() {

            public void valueChanged(TreeSelectionEvent e) {

                File dir = getSelectedDirectory();
                
                if (dir != null) {
                    setFileList(dir.listFiles(new ImageFileFilter() ) );
                } else {
                    setFileList(new File[0]);
                }
            }
        } );
        
        list = new JList(new DefaultListModel() );

        list.setFixedCellWidth(130);
        list.setFixedCellHeight(120);

        list.setCellRenderer(new ImageCellRenderer() );

        setTopComponent(new JScrollPane(tree)  {
            public Dimension getPreferredSize() {
                return new Dimension(150, 150);
            }
        });
        
        setBottomComponent(new JScrollPane(list)  {
            public Dimension getPreferredSize() {
                return new Dimension(150, 150);
            }
        });
    }

    public JTree getTree() {
        return tree;
    }
    
    public JList getList() {
        return list;
    }

    public void setSelectedFile(File file) {

        List<FileTreeNode> paths = new ArrayList<FileTreeNode>();
        
        File parent = file.getParentFile();
        
        while (parent != null) {
            paths.add(0, new FileTreeNode(parent) );
            if (rootFile.equals(parent) ) {
                break;
            }
            parent = parent.getParentFile();
        }

        if (paths.size() > 0) {
            tree.setSelectionPath(new TreePath(paths.toArray() ) );
            list.setSelectedValue(file, true);
        }
    }
    
    public File getSelectedDirectory() {

        TreePath treePath = tree.getSelectionPath();

        if (treePath == null || treePath.getLastPathComponent() == null) {
            return null;
        }
        
        return ( (FileTreeNode)treePath.getLastPathComponent() ).getFile();
    }
    
    public void setFileList(File[] files) {

        DefaultListModel model = (DefaultListModel)list.getModel();

        model.removeAllElements();

        for (int i = 0; i < files.length; i++) {
            model.addElement(files[i]);
        }
    }
}
   