package artifacts;

import java.awt.event.ActionEvent;
import java.awt.event.WindowEvent;

// Interface Grafica Swing:
import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;

import cartago.INTERNAL_OPERATION;
import cartago.OPERATION;
import cartago.tools.GUIArtifact;

public class Temperature_Controller extends GUIArtifact{

    class InterfaceControladorTemp extends JFrame {	
		
		private JButton okButton;
		private JTextField temperaturaAmbiente;
		private JTextField temperaturaDesejada;
		
		public InterfaceControladorTemp(){
			setTitle(" Ar Condicionado ");
			setSize(200,300);
						
			JPanel panel = new JPanel();
			JLabel tempA = new JLabel();
			tempA.setText("Temperatura Atual:    ");
			JLabel tempD = new JLabel();
			tempD.setText("Temperatura Desejada: ");
			setContentPane(panel);
			
			okButton = new JButton("ok");
			okButton.setSize(80,50);
			
			temperaturaAmbiente = new JTextField(10);
			temperaturaAmbiente.setText("25");
			temperaturaAmbiente.setEditable(true);
			
			temperaturaDesejada = new JTextField(10);
			temperaturaDesejada.setText("25");
			temperaturaDesejada.setEditable(true);
			
			panel.setLayout(new BoxLayout(panel, BoxLayout.Y_AXIS));
			panel.add(tempA);
			panel.add(temperaturaAmbiente);
			panel.add(tempD);
			panel.add(temperaturaDesejada);
			panel.add(okButton);
			
		}
		
		public String gettemperaturaAmbiente(){
			return temperaturaAmbiente.getText();
		}
		
		public String gettemperaturaDesejada(){
			return temperaturaDesejada.getText();
		}
	}
}