////
///  Array.swift
//

import Foundation

extension Array {
	public func safeValue(_ index: Int) -> Element? {
		return (startIndex..<endIndex).contains(index) ? self[index] : .none
	}

	public func find(_ test: (_ el: Element) -> Bool) -> Element? {
		for ob in self {
			if test(ob) {
				return ob
			}
		}
		return nil
	}
	
	public func randomItem() -> Element? {
		guard count > 0 else { return nil }
		let index = Int(arc4random_uniform(UInt32(count)))
		return self[index]
	}
}

extension Sequence {
	public func any(_ test: (_ el: Iterator.Element) -> Bool) -> Bool {
		for ob in self {
			if test(ob) {
				return true
			}
		}
		return false
	}
}
