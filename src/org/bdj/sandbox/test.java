package org.bdj.sandbox;

public class test {

    public static void main(String[] args) {
    	Class<?> clazz = null;
        try {
        	clazz = Class.forName("sun.launcher.LauncherHelper");
            System.out.println("Success! Returned object: " + clazz);
        } catch (Throwable e) {
            System.out.println("Failed! The class does not exist or cannot be accessed.");
            
        }
        
        SecurityManager sm = System.getSecurityManager();
        try {
        	if (sm == null) {
                System.out.println("No Security Manager");
            }
        	else {
                System.out.println("Security Manager still working!");
                sm.checkPackageAccess("sun.launcher.LauncherHelper");
        	}
        	
        }
        catch (SecurityException e) {
        	System.out.println("SM cannot access sun.launcher.LauncherHelper");
        
        }
    }
}