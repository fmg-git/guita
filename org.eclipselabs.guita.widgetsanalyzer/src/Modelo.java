import org.eclipse.swt.SWT;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.swt.widgets.Text;

public class Modelo {
	
	private static Button[] ola = new Button[10];
	
	private static Shell shell;

	public static void main(String[] args) {
		final Display display = new Display();
		shell = new Shell(display);
		shell.setLayout(new GridLayout(1, false));
		shell.setText("Form 1");

		Label label1 = new Label(shell, SWT.NULL);
		label1.setText("Algum texto !!!");
		
		for(int i = 0; i != ola.length; i++){
			ola[i] = new Button(shell, SWT.PUSH);
			ola[i].setText("ALGO");
		}

		Button button1 = new Button(shell, SWT.PUSH);
		button1.setText("OK");
		button1.addSelectionListener(new SelectionAdapter(){
			public void widgetSelected(SelectionEvent e){
				shell.setVisible(false);
				final Shell shell2 = new Shell(display);
				shell2.setLayout(new GridLayout(1, false));
				shell2.setText("Form 2");
				
				Label label1 = new Label(shell2, SWT.NULL);
				label1.setText("DOIS");
				
				Button button2 = new Button(shell2, SWT.PUSH);
				button2.setText("TRES");
				button2.addSelectionListener(new SelectionAdapter(){
					public void widgetSelected(SelectionEvent e){
						shell2.setVisible(false);
						shell.setVisible(true);
					}
				});
				
				shell2.pack ();
				shell2.open ();
				while (!shell2.isDisposed ()) {
					if (!display.readAndDispatch ()) 
						display.sleep ();
				}
			}
		});

		Button button2 = new Button(shell, SWT.PUSH);
		button2.setText("Cancelar");

		Text text = new Text(shell, SWT.SINGLE);
		text.setText("Introduzir algum texto aqui...");

		label1.setText("Outro texto");

		shell.pack ();
		shell.open ();
		while (!shell.isDisposed ()) {
			if (!display.readAndDispatch ()) 
				display.sleep ();
		}
		display.dispose ();
	}

}