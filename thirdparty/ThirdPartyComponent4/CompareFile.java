package com.pwc.automation.spinner;

import java.io.*;
import java.util.ArrayList;

public class CompareFile {

	public void compareFiles(String path, File file1, File file2, String file3)
			throws FileNotFoundException, IOException {

		ArrayList<String> lineList = new ArrayList<String>();
		ArrayList<String> al2 = new ArrayList<String>();

		BufferedReader inputFile1 = new BufferedReader(new FileReader(file1.getAbsoluteFile()));
		String dataRow1 = inputFile1.readLine();

		while (dataRow1 != null) {
			String[] dataArray1 = dataRow1.split(",");
			for (String item1 : dataArray1) {
				lineList.add(item1);
			}

			dataRow1 = inputFile1.readLine(); // Read next line of data.
		}

		inputFile1.close();

		BufferedReader inputFile2 = new BufferedReader(new FileReader(file2.getAbsoluteFile()));
		String dataRow2 = inputFile2.readLine();
		while (dataRow2 != null) {
			String[] dataArray2 = dataRow2.split(",");
			for (String item2 : dataArray2) {
				al2.add(item2);

			}
			dataRow2 = inputFile2.readLine(); // Read next line of data.
		}
		inputFile2.close();

		for (String bs : al2) {
			lineList.remove(bs);
		}

		int size = lineList.size();

		try {

			FileWriter writer = new FileWriter(path + "/" + file3);
			while (size != 0) {
				size--;
				writer.append("" + lineList.get(size));
				writer.append('\n');
			}
			writer.flush();
			writer.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}