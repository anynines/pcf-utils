package com.pivotal;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.util.Set;

import javax.json.Json;
import javax.json.JsonArray;
import javax.json.JsonObject;
import javax.json.JsonReader;

public class JsonParser {

	public static void main(String[] args) throws Exception {
		String fileName = args[0];
		String fieldName = args[1];
		String jobType = args[2];
		String username = args[3];

		String value = new JsonParser().getValue(fileName, fieldName, jobType, username);

		System.out.println(value);
	}

	String getValue(String fileName, String fieldName, String jobType, String username) throws Exception {
		String details = username;

		InputStream fis = getFileStream(fileName);

		JsonReader rdr = Json.createReader(fis);

		JsonObject obj = rdr.readObject();

		details = getDetails(fieldName, jobType, username, details, obj);

		return details;
	}

	private String getDetails(String fieldName, String jobType, String username, String details, JsonObject obj) {
		JsonArray jsonArray = obj.getJsonArray(ApplicationConstant.PRODUCTS);

		details = getInfo(fieldName, jobType, username, details, jsonArray);
		return details;
	}

	private String getInfo(String fieldName, String jobType, String username, String details, JsonArray jsonArray) {
		for (JsonObject result : jsonArray.getValuesAs(JsonObject.class)) {
			if (result.getString(ApplicationConstant.TYPE).equalsIgnoreCase(fieldName)) {
				JsonArray jobs = result.getJsonArray(ApplicationConstant.JOBS);
				for (JsonObject job : jobs.getValuesAs(JsonObject.class)) {
					if (job.getString(ApplicationConstant.TYPE).equalsIgnoreCase(jobType)) {
						JsonArray properties = job.getJsonArray(ApplicationConstant.PROPERTIES);
						for (JsonObject property : properties.getValuesAs(JsonObject.class)) {
							if (property.getJsonObject(ApplicationConstant.VALUE)
									.getString(ApplicationConstant.IDENTITY).equalsIgnoreCase(username)) {
								details += "|"
										+ property.getJsonObject(ApplicationConstant.VALUE).getString(
												ApplicationConstant.PASSWORD);
								break;
							}
						}
					}
				}

				JsonObject ips = result.getJsonObject(ApplicationConstant.IPS);
				Set<String> keys = ips.keySet();
				for (String key : keys) {
					if (key.contains(jobType)) {
						if (ips.getJsonArray(key).toArray().length >= 1) {
							details += "|" + ips.getJsonArray(key).get(0).toString().replaceAll("\"", "");
							break;
						}
					}
				}
			}
		}
		return details;
	}

	InputStream getFileStream(String fileName) throws FileNotFoundException {
		File file = new File(fileName);
		FileInputStream fis = new FileInputStream(file);
		return fis;
	}

}