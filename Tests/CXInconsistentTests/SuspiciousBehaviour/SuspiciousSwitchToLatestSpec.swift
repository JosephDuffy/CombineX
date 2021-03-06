import CXShim
import CXTestUtility
import Nimble
import Quick

class SuspiciousSwitchToLatestSpec: QuickSpec {
    
    override func spec() {
        
        // MARK: 1.1 should not crash if the child sends more events than initial demand.
        it("should not crash if the child sends more events than initial demand.") {
            let subject1 = PassthroughSubject<Int, Never>()
            
            let subject = PassthroughSubject<PassthroughSubject<Int, Never>, Never>()
            
            let pub = subject.switchToLatest()
            let sub = pub.subscribeTracingSubscriber(initialDemand: .max(10)) { v in
                return [0, 10].contains(v) ? .max(1) : .none
            }
            
            subject.send(subject1)
            
            (1...10).forEach(subject1.send)
            
            // SUSPICIOUS: Combine will crash here. This should be a bug.
            #if !SWIFT_PACKAGE
            expect {
                subject1.send(11)
            }.toBranch(
                combine: throwAssertion(),
                cx: beVoid()
            )
            #endif
            
            _ = sub
        }
    }
}
