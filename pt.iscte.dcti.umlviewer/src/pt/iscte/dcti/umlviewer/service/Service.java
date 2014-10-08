package pt.iscte.dcti.umlviewer.service;

import java.lang.reflect.Method;
import java.util.Collection;
import java.util.Map;

public interface Service {

	public void showFragment(Map<Class<?>, Collection<Method>> fragment_classes); //Alternatively, could receive a MethodFilter

	public void clear();

}