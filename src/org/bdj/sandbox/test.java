package org.bdj.sandbox;

public class test {

    public static void main(String[] args) {

        try {
            Class.forName("sun.launcher.LauncherHelper");
            System.out.println("Class exists");

            SecurityManager sm = System.getSecurityManager();

            if (sm == null) {
            	System.out.println(sm);
                System.out.println("No SecurityManager");
                return;
            }

            sm.checkPackageAccess("sun.launcher");

            System.out.println("Package access OK");

        } catch (Throwable e) {
            System.out.println("FAILED:");
            System.out.println(e.toString());
        }
    }
}