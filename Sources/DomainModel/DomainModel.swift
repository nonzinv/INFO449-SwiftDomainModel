struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    var amount: Double
    var currency: String

    func convert(_ convertTo: String) -> Money {
        var newAmount = amount
        switch currency {
            case "EUR":
                newAmount = amount * 2.0 / 3.0
            case "CAN":
                newAmount = amount / 5.0 * 4.0
            case "GBP":
                newAmount = amount * 2.0
            default:
                break
        }

        switch convertTo {
            case "EUR":
                newAmount *= 1.5
            case "CAN":
                newAmount *= 1.25
            case "GBP":
                newAmount /= 2.0
            default:
                break
        }
        return Money(amount: newAmount, currency: convertTo)
    }

    func add(_ next: Money) -> Money {
        let oldMoney = self.convert(next.currency)
        return Money(amount: oldMoney.amount + next.amount, currency: next.currency)
    }
}

////////////////////////////////////
// Job
//
public class Job {
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    public var title: String
    public var type: JobType

    public init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }

    public func calculateIncome(_ hours: Int = 2000) -> Int {
        switch self.type {
        case .Hourly(let wage):
            return Int(Double(hours) * wage)
        case .Salary(let salary):
            return Int(salary)
        }
    }

    public func raise(byAmount: Double) {
        switch self.type {
        case .Hourly(let wage):
            self.type = .Hourly(wage + byAmount)
        case .Salary(let salary):
            self.type = .Salary(salary + UInt(Int(byAmount)))
        }
    }
    
    public func raise(byPercent: Double) {
        switch type {
        case .Hourly(let hourly):
            self.type = JobType.Hourly(hourly * (1.0 + byPercent))
        case .Salary(let salary):
            self.type = JobType.Salary(UInt(Double(salary) * (1.0 + byPercent)))
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    public var firstName: String
    public var lastName: String
    public var age: Int
    public var job: Job?
    public var spouse: Person?

    public init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }

    public func toString() -> String {
        return "[Person: firstName: \(firstName) lastName: \(lastName) age: \(age) job: \(job?.title ?? "nil") spouse: \(spouse?.firstName ?? "nil")]"
    }
}

////////////////////////////////////
// Family
//
public class Family {
    public var members: [Person]

    public init(spouse1: Person, spouse2: Person) {
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
        self.members = [spouse1, spouse2]
    }

    public func haveChild(_ child: Person) -> Bool {
        for member in members {
            if member.age > 21 {
                members.append(child)
                return true
            }
        }
        return false
    }

    public func householdIncome() -> Int {
        var totalIncome = 0
        for member in members {
            if let job = member.job {
                totalIncome += job.calculateIncome()
            }
        }
        return totalIncome
    }
}

