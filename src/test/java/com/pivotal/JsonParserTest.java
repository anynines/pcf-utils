package com.pivotal;

import static org.junit.Assert.*;

import java.io.FileNotFoundException;
import java.io.InputStream;

import org.junit.Test;

public class JsonParserTest {
	@Test
	public void validateMicroBoshDetails() {
		String fileName = "/installation.yml";
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
			assertEquals("d98533512d91df542493", values[1]);
			assertEquals("172.16.1.41", values[2]);

		} catch (Exception e) {
			fail("This is unexpected: \n" + e);
		}
	}

	@Test
	public void validateCcDBDetails() {
		String fileName = "/installation.yml";
		try {
			JsonParser jsonParser = new JsonParser() {

				@Override
				InputStream getFileStream(String fileName) throws FileNotFoundException {
					InputStream is = this.getClass().getResourceAsStream(fileName);
					return is;
				}

			};

			String response = jsonParser.getValue(fileName, ApplicationConstant.CF, ApplicationConstant.CCDB, "admin");
			String[] values = response.split("\\|");
			assertTrue(values.length == 3);
			assertEquals("admin", values[0]);
			assertEquals("b40f5da19fbab9a20be8", values[1]);
			assertEquals("172.16.1.48", values[2]);

		} catch (Exception e) {
			fail("This is unexpected: \n" + e);
		}
	}

	@Test
	public void validateUaaDBDetails() {
		String fileName = "/installation.yml";
		try {
			JsonParser jsonParser = new JsonParser() {

				@Override
				InputStream getFileStream(String fileName) throws FileNotFoundException {
					InputStream is = this.getClass().getResourceAsStream(fileName);
					return is;
				}

			};

			String response = jsonParser.getValue(fileName, ApplicationConstant.CF, ApplicationConstant.UAADB, "vcap");
			String[] values = response.split("\\|");
			assertTrue(values.length == 3);
			assertEquals("vcap", values[0]);
			assertEquals("48610c1c4e90d5bc", values[1]);
			assertEquals("172.16.1.49", values[2]);

		} catch (Exception e) {
			fail("This is unexpected: \n" + e);
		}
	}

	@Test
	public void validateConsoleDBDetails() {
		String fileName = "/installation.yml";
		try {
			JsonParser jsonParser = new JsonParser() {

				@Override
				InputStream getFileStream(String fileName) throws FileNotFoundException {
					InputStream is = this.getClass().getResourceAsStream(fileName);
					return is;
				}

			};

			String response = jsonParser.getValue(fileName, ApplicationConstant.CF, ApplicationConstant.CONSOLE_DB,
					"vcap");
			String[] values = response.split("\\|");
			assertTrue(values.length == 3);
			assertEquals("vcap", values[0]);
			assertEquals("8594ada75673625d", values[1]);
			assertEquals("172.16.1.50", values[2]);

		} catch (Exception e) {
			fail("This is unexpected: \n" + e);
		}
	}

	@Test
	public void validateNFSServerDetails() {
		String fileName = "/installation.yml";
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
			assertEquals("ecdd39d20528ed48", values[1]);
			assertEquals("172.16.1.47", values[2]);

		} catch (Exception e) {
			fail("This is unexpected: \n" + e);
		}
	}

}
