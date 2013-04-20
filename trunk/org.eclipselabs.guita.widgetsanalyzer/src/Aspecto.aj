import java.io.IOException;
import java.io.ObjectInputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.HashMap;
import java.util.Iterator;
import java.util.WeakHashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.ArrayList;
import java.util.List;

import org.aspectj.lang.reflect.SourceLocation;
import org.eclipse.swt.graphics.Color;
import org.eclipse.swt.graphics.RGB;
import org.eclipse.swt.widgets.Control;
import org.eclipse.swt.widgets.Widget;
import org.eclipselabs.guita.request.Request;


public aspect Aspecto {

	public static final int PORT_IN = 8081;
	private ServerSocket serverSocket;

	private Map<String , Set<Widget>> widgetsList = new WeakHashMap<String, Set<Widget>>();

	private Map<Widget, Color> paintedWidgets = new HashMap<Widget, Color>();

	private List<Request> pendingRequests = new ArrayList<Request>();

	protected pointcut scope() : !within(Aspecto);


	public Aspecto(){
		System.out.println("HI from TRACER!");
		try {
			serverSocket = new ServerSocket(PORT_IN);
		} catch (IOException e) {
			System.exit(1);
		}
		new RequestHandler().start();
	}

	public class RequestHandler extends Thread {
		@Override
		public void run() {
			Socket socket = null;
			ObjectInputStream ois = null;

			while(true) {
				try {
					socket = serverSocket.accept();
					ois = new ObjectInputStream(socket.getInputStream());
					final Request request = (Request) ois.readObject();

					search(request);
				}
				catch(Exception e) {
					e.printStackTrace();
				} finally {
					if(ois != null){
						try {
							ois.close();
						} catch(IOException e){
						}
					}
					if(socket != null){
						try {
							socket.close();
						} catch(IOException e){
						}
					}
				}
			}
		}

		private void search(final Request request){
			if(widgetsList.containsKey(request.getLocation())){	
				for(Widget g: widgetsList.get(request.getLocation())){
					final Widget actualWidget = g;
					actualWidget.getDisplay().syncExec(new Runnable() {

						@Override
						public void run() {
							if(paintedWidgets.containsKey(actualWidget) && request.isToRemove()){
								removePaint(actualWidget);
							}else{
								paint(actualWidget, getColor(request));
							}
						}
					});
				}
			}else{
				pendingRequests.add(request);
			}
		}
	}

	private RGB getColor(Request request) {
		org.eclipselabs.guita.request.Request.Color color = request.getColor();
		return new RGB(color.getR(), color.getG(), color.getB());
	}

	public void paint(Widget g, RGB color){
		Control c = (Control)g;

		if(!paintedWidgets.containsKey(g))
			paintedWidgets.put(g, c.getBackground());

		c.setBackground(new Color(null, color));
	}

	public void removePaint(Widget g){
		Control c = (Control)g;

		c.setBackground(paintedWidgets.get(g));

		paintedWidgets.remove(g);
	}

	after() returning (Widget g): call(Widget+.new(..)) && scope() {
		SourceLocation loc = thisJoinPoint.getSourceLocation();
		String aux = loc.getFileName() + ":" + loc.getLine();
		if(widgetsList.containsKey(aux))
			widgetsList.get(aux).add(g);
		else{
			Set<Widget> auxList = new HashSet<Widget>();
			auxList.add(g);
			widgetsList.put(aux, auxList);
		}

		Iterator<Request> iterator = pendingRequests.iterator();
		while(iterator.hasNext()){
			Request r = iterator.next();
			if(r.getLocation().equals(aux)){
				paint(g, getColor(r));
				iterator.remove();
			}
		}
	}

	after(Widget g): call(* Widget+.*(..)) && target(g)  && scope() {
		SourceLocation loc = thisJoinPoint.getSourceLocation();
		String aux = loc.getFileName() + ":" + loc.getLine();
		if(widgetsList.containsKey(aux))
			widgetsList.get(aux).add(g);
		else{
			Set<Widget> auxList = new HashSet<Widget>();
			auxList.add(g);
			widgetsList.put(aux, auxList);
		}

		Iterator<Request> iterator = pendingRequests.iterator();
		while(iterator.hasNext()){
			Request r = iterator.next();
			if(r.getLocation().equals(aux)){
				paint(g, getColor(r));
				iterator.remove();
			}
		}
	}

}
