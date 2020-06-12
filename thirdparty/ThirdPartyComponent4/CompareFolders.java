package com.pwc.automation.spinner;

import java.io.File;

/*Ant Command to execute it from Jenkins
deltaPackage -Dversion1=9634 -Dversion2=9633 -DsvnUsername=ankur.patel -DsvnPassword=Arth@2308*/

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.MessageDigest;
import java.util.Arrays;
import java.util.Iterator;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

import org.apache.commons.io.FilenameUtils;

public class CompareFolders {

	static String resultDir = "";
	static String checkOutLevel = "";

	public static void main(String[] args) {
		
		/*File fromDirectory = new File(args[0]);
		File toDirectory = new File(args[1]); 
		resultDir = args[2]; 
		checkOutLevel = args[3];*/

		File fromDirectory = new File("C:/Users/ankur.patel/Desktop/temp/HEAD/"); 
		File toDirectory = new File("C:/Users/ankur.patel/Desktop/temp/13333/");
		resultDir = "C:/Users/ankur.patel/Desktop/temp/resultFolder/";
		checkOutLevel = "test";

		
		CompareFolders compareFolders = new CompareFolders();
		try {
			System.out.println("Result Folder : " + resultDir);
			compareFolders.getDiff(fromDirectory, toDirectory, checkOutLevel);
		} catch (IOException ie) {
			ie.printStackTrace();
		}
	}

	public void getDiff(File dirA, File dirB, String checkOutLevel) throws IOException {

		File[] listOfFileDirA = dirA.listFiles();
		File[] listOfFileDirB = dirB.listFiles();

		Arrays.sort(listOfFileDirA);
		Arrays.sort(listOfFileDirB);

		// File Name, Path of the file
		ConcurrentHashMap<String, File> fileMap;

		if (listOfFileDirA.length < listOfFileDirB.length) {
			fileMap = new ConcurrentHashMap<String, File>();

			for (int i = 0; i < listOfFileDirA.length; i++) {
				if (!listOfFileDirA[i].getName().contains(".svn")) {
					fileMap.put(listOfFileDirA[i].getName(), listOfFileDirA[i]);
				}

				System.out.println(listOfFileDirA[i].getName() + " : " + listOfFileDirA[i]);
			}

			compareNow(listOfFileDirB, fileMap, checkOutLevel);
		} else {
			fileMap = new ConcurrentHashMap<String, File>();

			for (int i = 0; i < listOfFileDirB.length; i++) {
				if (!listOfFileDirB[i].getName().contains(".svn")) {
					fileMap.put(listOfFileDirB[i].getName(), listOfFileDirB[i]);
				}
			}

			compareNow(listOfFileDirA, fileMap, checkOutLevel);
		}
	}
											
	public void compareNow(File[] fileArr, ConcurrentHashMap<String, File> map, String checkOutLevel)
			throws IOException {

		File fComp = null;

		for (int i = 0; i < fileArr.length; i++) {

			String fName = fileArr[i].getName();
			fComp = map.get(fName);
			map.remove(fName);

			if (fComp != null) {

				if (fComp.isDirectory()) {
					getDiff(fileArr[i], fComp, checkOutLevel);
				} else {
					String checkSum1 = checksum(fileArr[i]);
					String checkSum2 = checksum(fComp);
					if (!checkSum1.equals(checkSum2)) {

						System.out.println(fileArr[i].getName() + "====== 1 ======" + " FILES ARE DIFFERENT ");

						Path path2 = Paths.get(resultDir + fileArr[i].getAbsolutePath()
								.substring(fileArr[i].getAbsolutePath().indexOf(checkOutLevel)));
						Files.createDirectories(path2.getParent());

						String extn = getExtensionByApacheCommonLib(path2.toString());
						System.out.println("Extension of the file : " + extn);

						/*if ((path2.toString().contains(checkOutLevel+"/spinner") || path2.toString().contains(checkOutLevel+"/Spinner")) 
								&& !(extn.equalsIgnoreCase("java") || extn.equalsIgnoreCase("jsp") || extn.equalsIgnoreCase("xml"))) {
							CompareFile compareCSV = new CompareFile();
							compareCSV.compareFiles(path2.getParent().toString(), fileArr[i], fComp,
									fComp.getName());
						} else {*/
							Path path1 = Paths.get(fileArr[i].getAbsolutePath());
							Files.copy(path1, path2);
							System.out.println("Not comparing the file as it is not in the Spinner folder");
						//}
						
						
						// If Different, Entire JAVA file should be copied
						/*if (extn.equalsIgnoreCase("java")) {
							Path path1 = Paths.get(fileArr[i].getAbsolutePath());
							Files.copy(path1, path2);
						} else {
							if (path2.toString().contains("spinner") && path2.toString().contains("Spinner")) {
								CompareFile compareCSV = new CompareFile();
								compareCSV.compareFiles(path2.getParent().toString(), fileArr[i], fComp,
										fComp.getName());
							} else {
								System.out.println("Not comparing the file as it is not in the Spinner folder");
							}

						}*/

					} else {
						System.out.println(fileArr[i].getName() + "====== 2 ======" + " NO DIFFERENCE IN FILE ");
					}
				}
			} else {
				if (fileArr[i].isDirectory()) {
					traverseDirectory(fileArr[i]);
				} else {
					Path path1 = Paths.get(fileArr[i].getAbsolutePath());
					// Path path2 = Paths.get(resultDir + fileArr[i].getName());
					Path path2 = Paths.get(resultDir + fileArr[i].getAbsolutePath()
							.substring(fileArr[i].getAbsolutePath().indexOf(checkOutLevel)));
					Files.createDirectories(path2.getParent());
					Files.copy(path1, path2);

					System.out.println(
							fileArr[i].getName() + "====== 3 ======" + " EXISTS ONLY IN " + fileArr[i].getParent());
				}
			}
		}

		Set<String> set = map.keySet();
		Iterator<String> it = set.iterator();
		while (it.hasNext()) {
			String n = it.next();
			File fileFrmMap = map.get(n);
			map.remove(n);
			if (fileFrmMap.isDirectory()) {
				traverseDirectory(fileFrmMap);
			} else {
				System.out.println(
						fileFrmMap.getName() + "****** 4 ******" + " EXISTS ONLY IN " + fileFrmMap.getParent());
			}
		}
	}

	public void traverseDirectory(File dir) throws IOException {
		File[] list = dir.listFiles();
		for (int k = 0; k < list.length; k++) {
			if (list[k].isDirectory()) {
				traverseDirectory(list[k]);
			} else {
				System.out.println(list[k].getName() + "###### 5 ######" + " EXISTS ONLY IN " + list[k].getParent());

				Path path2 = Paths
						.get(resultDir + list[k].getAbsolutePath().substring(list[k].getAbsolutePath().indexOf(checkOutLevel)));
				Files.createDirectories(path2.getParent());

				String extn = getExtensionByApacheCommonLib(path2.toString());
				System.out.println("Extension of the file : " + extn);

				Path path1 = Paths.get(list[k].getAbsolutePath());
				Files.copy(path1, path2);

			}
		}
	}

	public String checksum(File file) {

		try {

			InputStream fileInputStream = new FileInputStream(file);
			java.security.MessageDigest md5er = MessageDigest.getInstance("MD5");
			byte[] buffer = new byte[1024];
			int read;

			do {
				read = fileInputStream.read(buffer);
				if (read > 0)
					md5er.update(buffer, 0, read);
			} while (read != -1);

			fileInputStream.close();

			byte[] digest = md5er.digest();

			if (digest == null) {
				return null;
			}

			String strDigest = "0x";

			for (int i = 0; i < digest.length; i++) {
				strDigest += Integer.toString((digest[i] & 0xff) + 0x100, 16).substring(1).toUpperCase();
			}

			return strDigest;
		} catch (Exception e) {
			return null;
		}
	}
	
	public static String getExtensionByApacheCommonLib(String filename) {
		return FilenameUtils.getExtension(filename);
	}
}
