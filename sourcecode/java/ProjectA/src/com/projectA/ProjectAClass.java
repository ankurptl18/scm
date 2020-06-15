package com.projectA;

public class ProjectAClass {

	public static void main123(String[] args) {
		System.out.println("************" + args[0] + "****************");
		System.out.println("Main Method A Class");
		ProjectAClass obj = new ProjectAClass(); 
		obj.methodA("Calling from projectA main method");
	}
	
	public void methodA(String message) {
		System.out.println("####### From ProjectA & methodA ####### ");
		System.out.println("####### " + message + " #######");
	}
}
