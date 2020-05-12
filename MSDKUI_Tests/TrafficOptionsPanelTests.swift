//
// Copyright (C) 2017-2020 HERE Europe B.V.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

@testable import MSDKUI
import XCTest

final class TrafficOptionsPanelTests: XCTestCase {
    /// The object under test.
    private var panel = TrafficOptionsPanel()

    /// The mock delegate used to verify expectations.
    private var mockDelegate = OptionsPanelDelegateMock() // swiftlint:disable:this weak_delegate

    /// The `NMADynamicPenalty` object for configuring the `panel` object.
    private var dynamicPenalty = NMADynamicPenalty()

    override func setUp() {
        super.setUp()

        // Configure the test object
        dynamicPenalty.trafficPenaltyMode = .avoidLongTermClosures

        panel.title = "Traffic options"
        panel.dynamicPenalty = dynamicPenalty
        panel.delegate = mockDelegate
    }

    // MARK: - Tests

    /// Tests the panel height.
    func testPanelHeight() {
        XCTAssertGreaterThan(panel.intrinsicContentSize.height, 0, "It has intrinsic content height")
    }

    /// Tests the panel.
    func testPanel() {
        // Is the panel title OK?
        XCTAssertNotNil(panel.titleItem, "No title item after setting the title!")
        XCTAssertNotNil(panel.titleItem?.label, "No title label in the title item!")
        XCTAssertEqual(panel.titleItem?.label?.text, "Traffic options", "It has the correct title")

        // Has the panel expected number of option items?
        XCTAssertEqual(panel.optionItems.count, 1, "The panel has not expected number of option items!")
    }

    /// Tests the option.
    func testOption() throws {
        let item = try require(panel.optionItems.first as? SingleChoiceOptionItem)

        // Is the delegate set?
        XCTAssertNotNil(item.delegate, "The SingleChoiceOptionItem object has no delegate!")

        // Has the panel expected number of options?
        XCTAssertEqual(item.labels.count, TrafficOptionsPanel.options.count, "The panel has not expected number of options!")

        // Change the selected option
        item.selectedItemIndex = 0

        // Is the panel change detected?
        XCTAssertTrue(mockDelegate.didChangeToOption, "It tells the delegate method about the option change")
        XCTAssertEqual(mockDelegate.didChangeToOptionCount, 1, "It calls the delegate method only once")

        // Is the underlying NMADynamicPenalty object updated?
        XCTAssertEqual(
            dynamicPenalty.trafficPenaltyMode, NMATrafficPenaltyMode.disabled,
            "Not the expected NMADynamicPenalty.trafficPenaltyMode value!"
        )

        // Set the same selected item again
        item.selectedItemIndex = 0

        // Is the panel change not detected?
        XCTAssertEqual(mockDelegate.didChangeToOptionCount, 1, "It doesn't call the delegate method again")
    }
}
