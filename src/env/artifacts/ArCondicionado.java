// CArtAgO artifact code for project aula10

package artifacts;

import java.awt.event.ActionEvent;
import java.awt.event.WindowEvent;

import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;

import cartago.INTERNAL_OPERATION;
import cartago.OPERATION;
import cartago.tools.GUIArtifact;

public class ArCondicionado extends GUIArtifact {
	
	private InterfaceAC frame;
	private TemperaturaAmbienteSimulator TA;
	private AC ac_model = new AC(false, 25, 25);
	
	public void setup() {
		defineObsProperty("ligado", ac_model.isOn());
		defineObsProperty("temperatura_ambiente", ac_model.getTemperatura_ambiente());
		defineObsProperty("temperatura_ac", ac_model.getTemperatura());
		System.out.println("Inicializado com " + ac_model.getTemperatura());
		
		create_frame();
	}
	
	void create_frame() {
		frame = new InterfaceAC();
		linkActionEventToOp(frame.okButton,"ok");
		linkWindowClosingEventToOp(frame, "closed");
		frame.setVisible(true);		
	}
	
	
	@OPERATION
	void ligar() {
		this.ac_model.setOn(true);
		getObsProperty("ligado").updateValue(ac_model.isOn());
		this.TA = new TemperaturaAmbienteSimulator();
		TA.start();
	}
	
	@OPERATION
	void desligar() {
		this.ac_model.setOn(false);
		getObsProperty("ligado").updateValue(ac_model.isOn());
		TA.stopThread();
	}
	
	@OPERATION
	void definir_temperatura(int temperatura) {
		ac_model.setTemperatura(temperatura);
		getObsProperty("temperatura_ac").updateValue(ac_model.getTemperatura());
	}
	
	@INTERNAL_OPERATION 
	void ok(ActionEvent ev){
		ac_model.setTemperatura(Integer.parseInt(frame.getTemperaturaD()));
		ac_model.setTemperatura_ambiente(Integer.parseInt(frame.getTemperaturaA()));
		getObsProperty("temperatura_ac").updateValue(ac_model.getTemperatura());
		getObsProperty("temperatura_ambiente").updateValue(ac_model.getTemperatura_ambiente());
		signal("alterado");
	}

	@INTERNAL_OPERATION 
	void closed(WindowEvent ev){
		signal("closed");
	}
	
	@OPERATION 
	void update(){
		getObsProperty("temperatura_ambiente").updateValue(ac_model.getTemperatura_ambiente());
		// commit();
		// System.out.println("temperatura ==>> " + ac_model.getTemperatura_ambiente());
	}
	
	void atualiza_artefato(){
		execInternalOp("update");
	}
	
	class AC { //Comportamento
		
		private boolean isOn = false;
		private int temperatura_ambiente = 0;
		private int temperatura = 0;
		
		public AC(boolean isOn, int temperatura_ambiente, int temperatura_desejavel) {
			super();
			this.isOn = isOn;
			this.temperatura_ambiente = temperatura_ambiente;
			this.temperatura = temperatura_desejavel;
		}

		public boolean isOn() {
			return isOn;
		}

		public void setOn(boolean isOn) {
			this.isOn = isOn;
		}

		public int getTemperatura_ambiente() {
			return temperatura_ambiente;
		}

		public void setTemperatura_ambiente(int temperatura_ambiente) {
			this.temperatura_ambiente = temperatura_ambiente;
		}

		public int getTemperatura() {
			return temperatura;
		}

		public void setTemperatura(int temperatura_desejavel) {
			this.temperatura = temperatura_desejavel;
		}	
			
	}

	class TemperaturaAmbienteSimulator extends Thread {
		
	    private boolean running;

	    public TemperaturaAmbienteSimulator() {
	        this.running = true;
	    }

	    public void stopThread() {
	        this.running = false;
	    }

	    @Override
	    public void run() {
	        while (running) {
	        	System.out.println("Temperatura ambiente: " + ac_model.getTemperatura_ambiente());
	            try {
	                Thread.sleep(5000); 
	                int currentTemp = ac_model.getTemperatura_ambiente();
	                if (currentTemp > ac_model.getTemperatura()) { 
	                	ac_model.setTemperatura_ambiente(currentTemp - 1); 
	                	atualiza_artefato();
	                }
	                if (currentTemp < ac_model.getTemperatura()) { 
	                	ac_model.setTemperatura_ambiente(currentTemp + 1); 
	                	atualiza_artefato();
	                }
	            } catch (InterruptedException e) {
	                e.printStackTrace();
	            }
	        }
	    }
	}

	class InterfaceAC extends JFrame {	
		
		private JButton okButton;
		private JTextField temperaturaA;
		private JTextField temperaturaD;
		
		public InterfaceAC(){
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
			
			temperaturaA = new JTextField(10);
			temperaturaA.setText("25");
			temperaturaA.setEditable(true);
			
			temperaturaD = new JTextField(10);
			temperaturaD.setText("25");
			temperaturaD.setEditable(true);
			
			panel.setLayout(new BoxLayout(panel, BoxLayout.Y_AXIS));
			panel.add(tempA);
			panel.add(temperaturaA);
			panel.add(tempD);
			panel.add(temperaturaD);
			panel.add(okButton);
			
		}
		
		public String getTemperaturaA(){
			return temperaturaA.getText();
		}
		
		public String getTemperaturaD(){
			return temperaturaD.getText();
		}
	}
}











