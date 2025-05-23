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

	private InterfaceControladorTemp frame;
	//private TemperaturaAmbienteSimulator TA;
	//private AC ac_model = new AC(false, 25, 25);

	public void setup() {
		//defineObsProperty("ligado", ac_model.isOn());
		//defineObsProperty("temperatura_ambiente", ac_model.getTemperatura_ambiente());
		//defineObsProperty("temperatura_ac", ac_model.getTemperatura());
		//System.out.println("Inicializado com " + ac_model.getTemperatura());
		
		create_frame();
	}
	
	void create_frame() {
		frame = new InterfaceControladorTemp();
		linkActionEventToOp(frame.setTemperatureButton,"ok"); // Nao gostei desse string
		linkWindowClosingEventToOp(frame, "closed"); // 
		frame.setVisible(true);		
	}

	@INTERNAL_OPERATION 
	void ok(ActionEvent ev){
		//ac_model.setTemperatura(Integer.parseInt(frame.getTemperaturaD()));
		//ac_model.setTemperatura_ambiente(Integer.parseInt(frame.getTemperaturaA()));
		//getObsProperty("temperatura_ac").updateValue(ac_model.getTemperatura()); - Comunicao com o agente
		//getObsProperty("temperatura_ambiente").updateValue(ac_model.getTemperatura_ambiente());
		signal("Temperatura Definida");
	}

    class InterfaceControladorTemp extends JFrame {	
		
		private JButton setTemperatureButton;
		private JTextField temperaturaAmbiente;
		private JTextField temperaturaDesejada;
		
		public InterfaceControladorTemp(){
			setTitle(" Temperature_Controller ");
			setSize(500,300);
						
			JPanel panel = new JPanel();
			JLabel tempA = new JLabel();
			tempA.setText("Temperatura Atual:    ");
			JLabel tempD = new JLabel();
			tempD.setText("Temperatura Desejada: ");
			setContentPane(panel);
			
			setTemperatureButton = new JButton("Set Temperature");
			setTemperatureButton.setSize(80,50); // Modificar tamanho do botao para texto ficar legivel
			
			temperaturaAmbiente = new JTextField(10);
			temperaturaAmbiente.setText("33"); // Necessita definir esse valor ao iniciar?
			temperaturaAmbiente.setEditable(true);
			
			temperaturaDesejada = new JTextField(10);
			temperaturaDesejada.setText("19"); // Necessita definir esse valor ao iniciar?
			temperaturaDesejada.setEditable(true);
			
			panel.setLayout(new BoxLayout(panel, BoxLayout.Y_AXIS));
			panel.add(tempA);
			panel.add(temperaturaAmbiente);
			panel.add(tempD);
			panel.add(temperaturaDesejada);
			panel.add(setTemperatureButton);
			
		}
		
		public String getTemperaturaAmbiente(){
			return temperaturaAmbiente.getText();
		}
		
		public String getTemperaturaDesejada(){
			return temperaturaDesejada.getText();
		}
	}
}