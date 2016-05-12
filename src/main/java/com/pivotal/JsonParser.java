package com.pivotal;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;

import javax.json.Json;
import javax.json.JsonArray;
import javax.json.JsonObject;
import javax.json.JsonReader;

public class JsonParser {
	private String productGuid;
	private String jobGuid;
	private String azReference;

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
		details = getCredentials(fieldName, jobType, username, details, jsonArray);

		details += "|" + obj.getJsonObject(ApplicationConstant.IPS).getJsonObject(ApplicationConstant.ASSIGNMENTS)
				.getJsonObject(productGuid).getJsonObject(jobGuid).getJsonArray(azReference).getString(0);
		return details;
	}

	private String getCredentials(String fieldName, String jobType, String username, String details,
			JsonArray jsonArray) {
		for (JsonObject result : jsonArray.getValuesAs(JsonObject.class)) {
			if (result.getString(ApplicationConstant.TYPE).equalsIgnoreCase(fieldName)) {
				JsonArray jobs = result.getJsonArray(ApplicationConstant.JOBS);
				for (JsonObject job : jobs.getValuesAs(JsonObject.class)) {
					if (job.getString(ApplicationConstant.TYPE).equalsIgnoreCase(jobType)) {
						if (fieldName.equalsIgnoreCase(ApplicationConstant.MICROBOSH)) {
							JsonArray properties = job.getJsonArray(ApplicationConstant.PROPERTIES);
							for (JsonObject property : properties.getValuesAs(JsonObject.class)) {
								if (property.getJsonObject(ApplicationConstant.VALUE)
										.getString(ApplicationConstant.IDENTITY).equalsIgnoreCase(username)) {
									details += "|" + property.getJsonObject(ApplicationConstant.VALUE)
											.getString(ApplicationConstant.PASSWORD);
									productGuid = result.getString(ApplicationConstant.GUID);
									azReference = result.getString(ApplicationConstant.AZ);
									jobGuid = job.getString(ApplicationConstant.GUID);
									break;
								}
							}
						} else {
							JsonObject credentials = job.getJsonObject(ApplicationConstant.VM_CREDENTIALS);
							productGuid = result.getString(ApplicationConstant.GUID);
							azReference = job.getJsonArray(ApplicationConstant.PARTITIONS).getJsonObject(0)
									.getString(ApplicationConstant.AZ_REF);
							jobGuid = job.getJsonArray(ApplicationConstant.PARTITIONS).getJsonObject(0)
									.getString(ApplicationConstant.JOB_REFERENCE);

							if (credentials.getString(ApplicationConstant.IDENTITY).equalsIgnoreCase(username)) {
								details += "|" + credentials.getString(ApplicationConstant.PASSWORD);
								break;
							} else {
								JsonArray properties = job.getJsonArray(ApplicationConstant.PROPERTIES);
								for (JsonObject property : properties.getValuesAs(JsonObject.class)) {
									if (property.getJsonObject(ApplicationConstant.VALUE)
											.getString(ApplicationConstant.IDENTITY).equalsIgnoreCase(username)) {
										details += "|" + property.getJsonObject(ApplicationConstant.VALUE)
												.getString(ApplicationConstant.PASSWORD);
										break;
									}
								}
							}
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