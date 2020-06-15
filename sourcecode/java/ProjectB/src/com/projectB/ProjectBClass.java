package com.projectB;

import com.projectA.ProjectAClass;

public class ProjectBClass {

	public static void main(String[] args) {
		System.out.println("************" + args[0] + "****************");
		System.out.println("Main Method B Class");
		ProjectBClass obj = new ProjectBClass();
		obj.methodB();
	}

	public void methodB() {
		System.out.println("From method B");
		ProjectAClass projectA = new ProjectAClass();
		projectA.methodA("Calling from B");
	}

}
