import XCTest

#if CombineX
import CombineX
#else
import Combine
#endif

typealias Assign = CombineX.Subscribers.Assign

class AssignTests: XCTestCase {
    
    func testAssign() {
        #if CombineX
        print("combineX")
        #else
        print("combine")
        #endif
    }
}
