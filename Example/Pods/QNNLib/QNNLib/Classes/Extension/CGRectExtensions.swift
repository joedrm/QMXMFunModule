import UIKit

extension CGRect {
	public static var `default`: CGRect = CGRect(origin: .zero, size: CGSize(width: 600, height: 600))
	
	// MARK: debug
	public func tap(_ name: String = "frame") -> CGRect {
		print("\(name): \(self)")
		return self
	}
	
	// MARK: convenience
	public init(x: CGFloat, y: CGFloat, right: CGFloat, bottom: CGFloat) {
		self.init(x: x, y: y, width: right - x, height: bottom - y)
	}
	
	public init(x: CGFloat, y: CGFloat) {
		self.init(x: x, y: y, width: 0, height: 0)
	}
	
	public init(origin: CGPoint) {
		self.init(origin: origin, size: .zero)
	}
	
	public init(width: CGFloat, height: CGFloat) {
		self.init(origin: .zero, size: CGSize(width: width, height: height))
	}
	
	public init(size: CGSize) {
		self.init(origin: .zero, size: size)
	}
	
	// MARK: helpers
	public var x: CGFloat { return self.origin.x }
	public var y: CGFloat { return self.origin.y }
	public var center: CGPoint {
		get { return CGPoint(x: self.midX, y: self.midY) }
		set { origin = CGPoint(x: newValue.x - width / 2, y: newValue.y - height / 2) }
	}
	
	// MARK: dimension setters
	public func at(origin amt: CGPoint) -> CGRect {
		var f = self
		f.origin = amt
		return f
	}
	
	public func with(size amt: CGSize) -> CGRect {
		var f = self
		f.size = amt
		return f
	}
	
	public func at(x amt: CGFloat) -> CGRect {
		var f = self
		f.origin.x = amt
		return f
	}
	
	public func at(y amt: CGFloat) -> CGRect {
		var f = self
		f.origin.y = amt
		return f
	}
	
	public func with(width amt: CGFloat) -> CGRect {
		var f = self
		f.size.width = amt
		return f
	}
	
	public func with(height amt: CGFloat) -> CGRect {
		var f = self
		f.size.height = amt
		return f
	}
	
	// MARK: inset(xxx:)
	public func inset(all: CGFloat) -> CGRect {
		return self.inset(by: UIEdgeInsets(top: all, left: all, bottom: all, right: all))
	}
	
	public func inset(topBottom: CGFloat, sides: CGFloat) -> CGRect {
		return self.inset(by: UIEdgeInsets(top: topBottom, left: sides, bottom: topBottom, right: sides))
	}
	
	public func inset(topBottom: CGFloat) -> CGRect {
		return self.inset(by: UIEdgeInsets(top: topBottom, left: 0, bottom: topBottom, right: 0))
	}
	
	public func inset(sides: CGFloat) -> CGRect {
		return self.inset(by: UIEdgeInsets(top: 0, left: sides, bottom: 0, right: sides))
	}
	
	public func inset(top: CGFloat, sides: CGFloat, bottom: CGFloat) -> CGRect {
		return self.inset(by: UIEdgeInsets(top: top, left: sides, bottom: bottom, right: sides))
	}
	
	public func inset(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> CGRect {
		return self.inset(by: UIEdgeInsets(top: top, left: left, bottom: bottom, right: right))
	}
	
	public func inset(_ insets: UIEdgeInsets) -> CGRect {
		return self.inset(by: insets)
	}
	
	// MARK: shrink(xxx:)
	public func shrink(left amt: CGFloat) -> CGRect {
		return self.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: amt))
	}
	
	public func shrink(right amt: CGFloat) -> CGRect {
		return self.inset(by: UIEdgeInsets(top: 0, left: amt, bottom: 0, right: 0))
	}
	
	public func shrink(down amt: CGFloat) -> CGRect {
		return self.inset(by: UIEdgeInsets(top: amt, left: 0, bottom: 0, right: 0))
	}
	
	public func shrink(up amt: CGFloat) -> CGRect {
		return self.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: amt, right: 0))
	}
	
	// MARK: grow(xxx:)
	public func grow(_ margins: UIEdgeInsets) -> CGRect {
		return self.inset(by:  UIEdgeInsets(top: -margins.top, left: -margins.left, bottom: -margins.bottom, right: -margins.right))
	}
	
	public func grow(all: CGFloat) -> CGRect {
		return self.inset(by: UIEdgeInsets(top: -all, left: -all, bottom: -all, right: -all))
	}
	
	public func grow(topBottom: CGFloat, sides: CGFloat) -> CGRect {
		return self.inset(by: UIEdgeInsets(top: -topBottom, left: -sides, bottom: -topBottom, right: -sides))
	}
	
	public func grow(top: CGFloat, sides: CGFloat, bottom: CGFloat) -> CGRect {
		return self.inset(by: UIEdgeInsets(top: -top, left: -sides, bottom: -bottom, right: -sides))
	}
	
	public func grow(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) -> CGRect {
		return self.inset(by: UIEdgeInsets(top: -top, left: -left, bottom: -bottom, right: -right))
	}
	
	public func grow(left amt: CGFloat) -> CGRect {
		return self.inset(by: UIEdgeInsets(top: 0, left: -amt, bottom: 0, right: 0))
	}
	
	public func grow(right amt: CGFloat) -> CGRect {
		return self.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -amt))
	}
	
	public func grow(up amt: CGFloat) -> CGRect {
		return self.inset(by: UIEdgeInsets(top: -amt, left: 0, bottom: 0, right: 0))
	}
	
	public func grow(down amt: CGFloat) -> CGRect {
		return self.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: -amt, right: 0))
	}
	
	// MARK: from(xxx:)
	public func fromTop() -> CGRect {
		return CGRect(x: minX, y: minY, width: width, height: 0)
	}
	
	public func fromBottom() -> CGRect {
		return CGRect(x: minX, y: maxY, width: width, height: 0)
	}
	
	public func fromLeft() -> CGRect {
		return CGRect(x: minX, y: minY, width: 0, height: height)
	}
	
	public func fromRight() -> CGRect {
		return CGRect(x: maxX, y: minY, width: 0, height: height)
	}
	
	// MARK: shift(xxx:)
	public func shift(up amt: CGFloat) -> CGRect {
		return self.at(y: self.y - amt)
	}
	
	public func shift(down amt: CGFloat) -> CGRect {
		return self.at(y: self.y + amt)
	}
	
	public func shift(left amt: CGFloat) -> CGRect {
		return self.at(x: self.x - amt)
	}
	
	public func shift(right amt: CGFloat) -> CGRect {
		return self.at(x: self.x + amt)
	}
}
