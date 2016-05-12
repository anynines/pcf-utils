package com.pivotal;

import static org.junit.Assert.*;

import java.io.FileNotFoundException;
import java.io.InputStream;

import org.junit.Test;

public class JsonParserTest {
	private String fileName = "/installation-1.7.json";
	
	@Test
	public void validateMicroBoshDetails() {
		try {
			JsonParser jsonParser = new JsonParser() {

				@Override
				InputStream getFileStream(String fileName) throws FileNotFoundException {
					InputStream is = this.getClass().getResourceAsStream(fileName);
					return is;
				}

			};

			String response = jsonParser.getValue(fileName, ApplicationConstant.MICROBOSH, "director", "director");
			String[] values = response.split("\\|");
			assertTrue(values.length == 3);
			assertEquals("director", values[0]);
			assertEquals("a1dc7d4f0e324906b607", values[1]);
			assertEquals("172.16.1.41", values[2]);

		} catch (Exception e) {
			fail("This is unexpected: \n" + e);
		}
	}

	@Test
	public void validateMySqlDBDetails() {
		try {
			JsonParser jsonParser = new JsonParser() {

				@Override
				InputStream getFileStream(String fileName) throws FileNotFoundException {
					InputStream is = this.getClass().getResourceAsStream(fileName);
					return is;
				}

			};

			String response = jsonParser.getValue(fileName, ApplicationConstant.CF, ApplicationConstant.MYSQL_DB,
					"root");
			String[] values = response.split("\\|");
			assertTrue(values.length == 3);
			assertEquals("root", values[0]);
			assertEquals("ad0b5f49d0424f63d3fd", values[1]);
			assertEquals("172.16.1.51", values[2]);

		} catch (Exception e) {
			fail("This is unexpected: \n" + e);
		}
	}

	@Test
	public void validateNFSServerDetails() {
		
		try {
			JsonParser jsonParser = new JsonParser() {

				@Override
				InputStream getFileStream(String fileName) throws FileNotFoundException {
					InputStream is = this.getClass().getResourceAsStream(fileName);
					return is;
				}

			};

			String response = jsonParser.getValue(fileName, ApplicationConstant.CF, ApplicationConstant.NFS_SERVER,
					"vcap");
			String[] values = response.split("\\|");
			assertTrue(values.length == 3);
			assertEquals("vcap", values[0]);
			assertEquals("9e07b82c2985a444", values[1]);
			assertEquals("172.16.1.49", values[2]);

		} catch (Exception e) {
			fail("This is unexpected: \n" + e);
		}
	}

}
