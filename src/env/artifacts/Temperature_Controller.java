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
	private ControladorTemperatura controlador = new ControladorTemperatura(false, 19, 25);

	public void setup() {
		defineObsProperty("tc_on", controlador.isOn());
		defineObsProperty("temperatura_ambiente", controlador.getTemperatura_ambiente());
		defineObsProperty("temperatura_desejada", controlador.getTemperatura_definida());
		System.out.println("Inicializado com temp desejada" + controlador.getTemperatura_definida());
		
		create_frame();
		return;
	}
	
	void create_frame() {
		frame = new InterfaceControladorTemp();
		linkActionEventToOp(frame.setTemperatureDesButton,"setDesiredTemp"); // Nao gostei desse string
		linkActionEventToOp(frame.setTemperatureAmbButton,"setAmbientTemp");
		linkWindowClosingEventToOp(frame, "closed"); // 
		frame.setVisible(true);
		return;		
	}

	@OPERATION
	void ligar() {
		this.controlador.setOn(true);
		getObsProperty("tc_on").updateValue(controlador.isOn());
		System.out.println("Operacao ligar() executada. Controlador ligado.");
		return;
	}
	
	@OPERATION
	void desligar() {
		this.controlador.setOn(false);
		getObsProperty("tc_on").updateValue(controlador.isOn());
		return;
	}

	@OPERATION
	void atualizarTempAmbienteInterface(int temperaturaAmbiente){
		frame.temperaturaAmbiente.setText(Integer.toString(temperaturaAmbiente));
		System.out.println("Temperatura Ambiente atualizada: " + temperaturaAmbiente);
		return;
	}

	@INTERNAL_OPERATION 
	void setDesiredTemp(ActionEvent ev){
		controlador.setTemperatura_definida(Integer.parseInt(frame.getTemperaturaDesejada()));
		getObsProperty("temperatura_desejada").updateValue(controlador.getTemperatura_definida());
		System.out.println("Temperatura Desejada Definida: " + controlador.getTemperatura_definida());
		signal("setDesiredTemp");
		return;
	}

	@INTERNAL_OPERATION
	void setAmbientTemp(ActionEvent ev){
		controlador.setTemperatura_ambiente(Integer.parseInt(frame.getTemperaturaAmbiente()));
		getObsProperty("temperatura_ambiente").updateValue(controlador.getTemperatura_ambiente());
		System.out.println("Temperatura Ambiente Definida: " + controlador.getTemperatura_ambiente());
		signal("setAmbientTemp");
		return;
	}

	@INTERNAL_OPERATION 
	void closed(WindowEvent ev){
		signal("closed");
		return;
	}

	class ControladorTemperatura { //Comportamento
		
		private boolean isOn = false;
		private int temperaturaAmbiente; // Devo inicializar os valores?
		private int temperaturaDefinida;
		
		public ControladorTemperatura(boolean isOn, int TA, int TD) { // Construtor
			super(); // Usado para chamar o construtor da superclasse sem parâmetros. Nesse caso, não é necessário, mas é uma boa prática.
			this.isOn = isOn;
			this.temperaturaAmbiente = TA;
			this.temperaturaDefinida = TD;
		}

		public boolean isOn() {
			return isOn;
		}

		public void setOn(boolean isOn) {
			this.isOn = isOn;
		}

		public int getTemperatura_ambiente() {
			return temperaturaAmbiente;
		}

		public void setTemperatura_ambiente(int temperatura_ambiente) {
			this.temperaturaAmbiente = temperatura_ambiente;
		}

		public int getTemperatura_definida() {
			return temperaturaDefinida;
		}

		public void setTemperatura_definida(int temperatura_desejada) {
			this.temperaturaDefinida = temperatura_desejada;
		}	
			
	}

    class InterfaceControladorTemp extends JFrame {	
		
		private JButton setTemperatureAmbButton;
		private JButton setTemperatureDesButton;
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
			
			setTemperatureAmbButton = new JButton("Set Ambient Temperature");
			setTemperatureAmbButton.setSize(120,50); // Modificar tamanho do botao para texto ficar legivel
			setTemperatureDesButton = new JButton("Set Temperature");
			setTemperatureDesButton.setSize(80,50); // Modificar tamanho do botao para texto ficar legivel
			
			temperaturaAmbiente = new JTextField(10);
			temperaturaAmbiente.setText(""); // Necessita definir esse valor ao iniciar?
			temperaturaAmbiente.setEditable(true);
			
			temperaturaDesejada = new JTextField(10);
			temperaturaDesejada.setText(""); // Necessita definir esse valor ao iniciar?
			temperaturaDesejada.setEditable(true);
			
			panel.setLayout(new BoxLayout(panel, BoxLayout.Y_AXIS));
			panel.add(tempA);
			panel.add(temperaturaAmbiente);
			panel.add(setTemperatureAmbButton);
			panel.add(tempD);
			panel.add(temperaturaDesejada);
			panel.add(setTemperatureDesButton);
			
		}
		
		public String getTemperaturaAmbiente(){
			return temperaturaAmbiente.getText();
		}
		
		public String getTemperaturaDesejada(){
			return temperaturaDesejada.getText();
		}
	}
}