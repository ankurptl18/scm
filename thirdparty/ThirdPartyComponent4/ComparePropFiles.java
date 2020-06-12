package com.pwc.automation.spinner;

import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;

public class ComparePropFiles {

	public static void main(final String[] args) throws IOException {
		final Path firstFile = Paths.get("C:/Users/ankur.patel/Desktop/test/emxComponents.properties");
		final Path secondFile = Paths.get("C:/Users/ankur.patel/Desktop/test/emxComponents2.properties");
		final List<String> firstFileContent = Files.readAllLines(firstFile, Charset.defaultCharset());
		final List<String> secondFileContent = Files.readAllLines(secondFile, Charset.defaultCharset());

		System.out.println(diffFiles(secondFileContent, firstFileContent));

	}

	private static List<String> diffFiles(final List<String> firstFileContent, final List<String> secondFileContent) {
		final List<String> diff = new ArrayList<String>();
		for (final String line : firstFileContent) {
			if (!secondFileContent.contains(line)) {
				diff.add(line);
			}
		}
		return diff;
	}
}