/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
import XCTest


class DDLFieldDate_Tests: XCTestCase {

	let parser:DDLParser = DDLParser(locale:NSLocale(localeIdentifier: "es_ES"))

	override func setUp() {
		super.setUp()
	}

	override func tearDown() {
		super.tearDown()
	}

	func test_Parse_ShouldExtractValues() {
		parser.xml =
			"<root available-locales=\"en_US\" default-locale=\"en_US\"> " +
			"<dynamic-element dataType=\"date\" " +
				"fieldNamespace=\"ddm\" " +
				"indexType=\"keyword\" " +
				"name=\"A_Date\" " +
				"readOnly=\"false\" " +
				"repeatable=\"true\" " +
				"required=\"false\" " +
				"showLabel=\"true\" " +
				"type=\"ddm-date\" " +
				"width=\"small\"> " +
					"<meta-data locale=\"en_US\"> " +
						"<entry name=\"label\"><![CDATA[A Date]]></entry> " +
						"<entry name=\"predefinedValue\"><![CDATA[12/31/2001]]></entry> " +
						"<entry name=\"tip\"><![CDATA[The tip]]></entry> " +
					"</meta-data> " +
			"</dynamic-element> </root>"

		let fields = parser.parse()

		XCTAssertTrue(fields != nil)
		XCTAssertEqual(1, fields!.count)
		XCTAssertTrue(fields![0] is DDLFieldDate)

		let dateField = fields![0] as DDLFieldDate

		XCTAssertEqual(DDLField.DataType.DDLDate, dateField.dataType)
		XCTAssertEqual(DDLField.Editor.Date, dateField.editorType)
		XCTAssertEqual("A_Date", dateField.name)
		XCTAssertEqual("A Date", dateField.label)
		XCTAssertEqual("The tip", dateField.tip)
		XCTAssertFalse(dateField.readOnly)
		XCTAssertTrue(dateField.repeatable)
		XCTAssertFalse(dateField.required)
		XCTAssertTrue(dateField.showLabel)

		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "dd/MM/yyyy"

		XCTAssertTrue(dateField.predefinedValue != nil)
		XCTAssertTrue(dateField.predefinedValue is NSDate)
		XCTAssertEqual(
				"31/12/2001",
				dateFormatter.stringFromDate(dateField.predefinedValue as NSDate))
		XCTAssertEqual(
				dateField.currentValue as NSDate,
				dateField.predefinedValue as NSDate)
	}

	func test_Validate_ShouldFail_WhenRequiredValueIsNil() {
		parser.xml = requireddateField
		let fields = parser.parse()
		let dateField = fields![0] as DDLFieldDate

		XCTAssertTrue(dateField.currentValue == nil)

		XCTAssertFalse(dateField.validate())
	}

	func test_CurrentStringValue_ShouldReturnEpochTimeInMilliseconds() {
		parser.xml = requireddateField
		let fields = parser.parse()
		let dateField = fields![0] as DDLFieldDate

		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "dd/MM/yyyy"

		dateField.currentValue = dateFormatter.dateFromString("19/06/2004")

		// converted with http://www.epochconverter.com/
		XCTAssertEqual("1087596000000", dateField.currentStringValue!)
	}

	func test_CurrentStringValue_ShouldSupportOneDigitMonth_WhenSettingTheStringValue() {
		parser.xml = requireddateField
		let fields = parser.parse()
		let dateField = fields![0] as DDLFieldDate

		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "dd/MM/yyyy"

		dateField.currentStringValue = "6/19/2004"

		XCTAssertEqual(
				"19/06/2004",
				dateFormatter.stringFromDate(dateField.currentValue as NSDate))
	}

	func test_CurrentStringValue_ShouldSupportFourDigitsYear_WhenSettingTheStringValue() {
		parser.xml = requireddateField
		let fields = parser.parse()
		let dateField = fields![0] as DDLFieldDate

		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "dd/MM/yyyy"

		dateField.currentStringValue = "6/19/04"

		XCTAssertEqual(
				"19/06/2004",
				dateFormatter.stringFromDate(dateField.currentValue as NSDate))
	}


	func test_CurrentDateLabel_ShouldReturnClientSideFormat() {
		parser.xml = requireddateField
		let fields = parser.parse()
		let dateField = fields![0] as DDLFieldDate

		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = "dd/MM/yyyy"

		dateField.currentValue = dateFormatter.dateFromString("19/06/2004")

		XCTAssertEqual("Jun 19, 2004", dateField.currentDateLabel!)
	}



	private let requireddateField =
		"<root available-locales=\"en_US\" default-locale=\"en_US\"> " +
			"<dynamic-element dataType=\"date\" " +
				"fieldNamespace=\"ddm\" " +
				"indexType=\"keyword\" " +
				"name=\"A_Date\" " +
				"readOnly=\"false\" " +
				"repeatable=\"true\" " +
				"required=\"true\" " +
				"showLabel=\"true\" " +
				"type=\"ddm-date\" " +
				"width=\"small\"> " +
					"<meta-data locale=\"en_US\"> " +
						"<entry name=\"label\"><![CDATA[A Date]]></entry> " +
					"</meta-data> " +
			"</dynamic-element> </root>"

}
