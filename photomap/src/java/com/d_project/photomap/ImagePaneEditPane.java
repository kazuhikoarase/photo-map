package com.d_project.photomap;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;

import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.JTextField;
import javax.swing.SwingConstants;
import javax.swing.border.EmptyBorder;

/**
 * ImagePaneEditPane
 * @author Kazuhiko Arase
 */
@SuppressWarnings("serial")
class ImagePaneEditPane extends JPanel {
    
    private Map<String, EditableComponent> editableMap;    

    public ImagePaneEditPane() {

        setBorder(new EmptyBorder(4, 4, 4, 4) );
        setLayout(new TableLayout(2, 2) );

        this.editableMap = new HashMap<String, EditableComponent>();
        
        addText("title", "Title", 20);
        addTextArea("memo", "Memo", 10, 40);
    }

    public Set<String> getValueNames() {
        return editableMap.keySet();
    }
        
    public void setValue(String name, String value) {
        value = (value != null)? value : "";
        EditableComponent comp = getEditable(name);
        if (comp != null) {
            comp.setEditValue(value);
        }
    }

    public String getValue(String name) {
        EditableComponent comp = getEditable(name);
        String value = (comp != null)? comp.getEditValue() : null; 
        return (value != null)? value : "";
    }
    
    private void addEditable(String name, EditableComponent editable) {
        editableMap.put(name, editable);
    }
    
    private EditableComponent getEditable(String name) {
        return (EditableComponent)editableMap.get(name);
    }
    
    private interface EditableComponent {
        public void setEditValue(String value);
        public String getEditValue();
    }
                
    private void addText(String name, String label, int size) {
        EditTextField textField = new EditTextField(size);
        add(createLabel(label) );
        add(textField);
        addEditable(name, textField);
    }

    private void addTextArea(String name, String label, int col, int row) {
        EditTextArea textArea = new EditTextArea(col, row);
        add(createLabel(label) );
        add(new JScrollPane(textArea) );
        addEditable(name, textArea);
    }

    private JLabel createLabel(String text) {
        JLabel label = new JLabel();
        label.setText(text);
        label.setHorizontalAlignment(SwingConstants.LEFT);
        label.setVerticalAlignment(SwingConstants.TOP);
        return label;
    }

    private static class EditTextField extends JTextField implements EditableComponent {
        
        public EditTextField(int size) {
            super(size);
        }
        
        public String getEditValue() {
            return getText();
        }

        public void setEditValue(String value) {
            setText(value);
        }
    }

    private static class EditTextArea extends JTextArea implements EditableComponent {
        
        public EditTextArea(int col, int row) {
            super(col, row);
        }
        
        public String getEditValue() {
            return getText();
        }

        public void setEditValue(String value) {
            setText(value);
        }
    }
        
}
