# Swiftlint doc
* [AccessibilityPurpose rule](#accessibility_purpose)
* [Array Init rule](#array_init)
* [Assertion rule](#assertion)
* [Block Based KVO rule](#block_based_kvo)
* [Bool type inference rule](#bool_type_inference)
* [Class Delegate Protocol rule](#class_delegate_protocol)
* [Closing Brace Spacing rule (autocorrectable)](#closing_brace)
* [Closure End Indentation rule (autocorrectable)](#closure_end_indentation)
* [Closure Spacing rule (autocorrectable)](#closure_spacing)
* [Comma Spacing rule (autocorrectable)](#comma)
* [Compiler Protocol Init rule](#compiler_protocol_init)
* [Contains over first not nil rule](#contains_over_first_not_nil)
* [Control Statement rule](#control_statement)
* [CyrillicAvito rule](#cyrillic_avito)
* [Cyrillic Letters rule](#cyrillic_letters)
* [DI resolve rule rule](#di_resolve)
* [Discarded Notification Center Observer rule](#discarded_notification_center_observer)
* [Discouraged Direct Initialization rule](#discouraged_direct_init)
* [Discouraged Object Literal rule](#discouraged_object_literal)
* [Empty Count rule](#empty_count)
* [Empty Enum Arguments rule (autocorrectable)](#empty_enum_arguments)
* [Empty Parameters rule (autocorrectable)](#empty_parameters)
* [Empty Parentheses with Trailing Closure rule (autocorrectable)](#empty_parentheses_with_trailing_closure)
* [Empty String rule](#empty_string)
* [Empty Tuple Return rule (autocorrectable)](#empty_tuple_return)
* [Empty XCTest Method rule](#empty_xctest_method)
* [Excessive spaces after colon rule (autocorrectable)](#excessive_spaces_after_colon)
* [Explicit Init rule (autocorrectable)](#explicit_init)
* [Fatal Error Message rule](#fatal_error_message)
* [Feature toggle import rule rule](#feature_toggle_import)
* [First Where rule](#first_where)
* [Force Cast rule](#force_cast)
* [Force Try rule](#force_try)
* [Force Unwrapping rule](#force_unwrapping)
* [Generic Type Name rule](#generic_type_name)
* [Implicit Getter rule](#implicit_getter)
* [Implicit Return rule (autocorrectable)](#implicit_return)
* [Implicitly Unwrapped Optional rule](#implicitly_unwrapped_optional)
* [InsetBy rule (autocorrectable)](#inset_by)
* [Internal Access Modifier rule (autocorrectable)](#internal_access_modifier)
* [Keyed converter rule rule](#keyed_converter)
* [Leading Whitespace rule (autocorrectable)](#leading_whitespace)
* [Legacy CGGeometry Functions rule (autocorrectable)](#legacy_cggeometry_functions)
* [Legacy Constant rule (autocorrectable)](#legacy_constant)
* [Legacy Constructor rule (autocorrectable)](#legacy_constructor)
* [Line Length rule](#line_length)
* [Lower ACL than parent rule](#lower_acl_than_parent)
* [Mark rule (autocorrectable)](#mark)
* [Missing spaces after colon rule (autocorrectable)](#missing_spaces_after_colon)
* [Modifier Order rule](#modifier_order)
* [Multiline Arguments rule](#multiline_arguments)
* [Multiline Parameters rule](#multiline_parameters)
* [Multiple Closures with Trailing Closure rule](#multiple_closures_with_trailing_closure)
* [Operator Usage Whitespace rule (autocorrectable)](#operator_usage_whitespace)
* [Overridden methods call super rule](#overridden_super_call)
* [Pattern Matching Keywords rule](#pattern_matching_keywords)
* [Precondition rule](#precondition)
* [Print rule rule (autocorrectable)](#print)
* [Private Outlets rule](#private_outlet)
* [Prohibited calls to super rule](#prohibited_super_call)
* [Protocol Property Accessors Order rule (autocorrectable)](#protocol_property_accessors_order)
* [Redundant Discardable Let rule (autocorrectable)](#redundant_discardable_let)
* [Redundant Nil Coalescing rule (autocorrectable)](#redundant_nil_coalescing)
* [Redundant Optional Initialization rule (autocorrectable)](#redundant_optional_initialization)
* [Redundant Set Access Control Rule rule](#redundant_set_access_control)
* [Redundant spaces before colon rule (autocorrectable)](#redundant_spaces_before_colon)
* [Redundant Void Return rule (autocorrectable)](#redundant_void_return)
* [Returning Whitespace rule (autocorrectable)](#return_arrow_whitespace)
* [Self in backticks rule rule](#self_in_backticks)
* [Setup function name rule (autocorrectable)](#setup_function_name)
* [Statement Position rule (autocorrectable)](#statement_position)
* [String type inference rule](#string_type_inference)
* [Switch and Case Statement Alignment rule](#switch_case_alignment)
* [Switch Case on Newline rule](#switch_case_on_newline)
* [Sync rule rule](#sync)
* [Syntactic Sugar rule](#syntactic_sugar)
* [Tabs rule rule (autocorrectable)](#tabs)
* [Trailing Newline rule (autocorrectable)](#trailing_newline)
* [Trailing Semicolon rule (autocorrectable)](#trailing_semicolon)
* [UIColor rule rule](#uicolor)
* [Unneeded Break in Switch rule](#unneeded_break_in_switch)
* [Unneeded Parentheses in Closure Argument rule (autocorrectable)](#unneeded_parentheses_in_closure_argument)
* [Unused Closure Parameter rule (autocorrectable)](#unused_closure_parameter)
* [Unused Enumerated rule](#unused_enumerated)
* [Unused Optional Binding rule](#unused_optional_binding)
* [Vertical Parameter Alignment rule](#vertical_parameter_alignment)
* [Vertical Parameter Alignment On Call rule](#vertical_parameter_alignment_on_call)
* [Vertical Whitespace rule (autocorrectable)](#vertical_whitespace)
* [Weak Delegate rule](#weak_delegate)



### <a name="accessibility_purpose"/>1/89. AccessibilityPurpose rule
**Rule identifier**: `accessibility_purpose`

**Rule description**: `Choose between production and test accessibility: qaXxx / userXxx`

**Rule kind**: `Idiomatic`

#### Non triggering examples
```
let accessibilityLabelComponents = [
```

```
accessibilityValue_postfix
```

```
prefix_accessibilityValue
```

```
&prefix_accessibilityValue
```

```
&accessibilityValue_postfix
```

```
qaAccessibilityId
```

```
isQaAccessibilityElement
```

```
qaAccessibilityValue
```

```
isUserAccessibilityElement
```

```
userAccessibilityLabel
```

```
userAccessibilityAttributedLabel
```

```
userAccessibilityHint
```

```
userAccessibilityAttributedHint
```

```
userAccessibilityValue
```

```
userAccessibilityAttributedValue
```

```
userAccessibilityTraits
```

```
userAccessibilityFrame
```

```
userAccessibilityPath
```

```
userAccessibilityActivationPoint
```

```
userAccessibilityLanguage
```

```
userAccessibilityElementsHidden
```

```
userAccessibilityViewIsModal
```

```
shouldGroupUserAccessibilityChildren
```

```
userAccessibilityNavigationStyle
```

```
userAccessibilityHeaderElements
```

#### Triggering examples
```
↓accessibilityIdentifier =
```

```
   ↓accessibilityIdentifier =
```

```
&↓accessibilityIdentifier
```

```
(&↓accessibilityIdentifier)
```

```
(&↓accessibilityIdentifier, &↓accessibilityIdentifier)
```

```
↓isAccessibilityElement =
```

```
↓accessibilityLabel =
```

```
↓accessibilityAttributedLabel =
```

```
↓accessibilityHint =
```

```
↓accessibilityAttributedHint =
```

```
↓accessibilityValue =
```

```
↓accessibilityAttributedValue =
```

```
↓accessibilityTraits =
```

```
↓accessibilityFrame =
```

```
↓accessibilityPath =
```

```
↓accessibilityActivationPoint =
```

```
↓accessibilityLanguage =
```

```
↓accessibilityElementsHidden =
```

```
↓accessibilityViewIsModal =
```

```
↓shouldGroupAccessibilityChildren =
```

```
↓accessibilityNavigationStyle =
```

```
↓accessibilityHeaderElements =
```




### <a name="array_init"/>2/89. Array Init rule
**Rule identifier**: `array_init`

**Rule description**: `Prefer using Array(seq) over seq.map { $0 } to convert a sequence into an Array.`

**Rule kind**: `Lint`

#### Non triggering examples
```
Array(foo)
```

```
foo.map { $0.0 }
```

```
foo.map { $1 }
```

```
foo.map { $0() }
```

```
foo.map { ((), $0) }
```

```
foo.map { $0! }
```

```
foo.map { $0! /* force unwrap */ }
```

```
foo.something { RouteMapper.map($0) }
```

#### Triggering examples
```
↓foo.map({ $0 })
```

```
↓foo.map { $0 }
```

```
↓foo.map { return $0 }
```

```
↓foo.map { elem in
   elem
}
```

```
↓foo.map { elem in
   return elem
}
```

```
↓foo.map { (elem: String) in
   elem
}
```

```
↓foo.map { elem -> String in
   elem
}
```

```
↓foo.map { $0 /* a comment */ }
```




### <a name="assertion"/>3/89. Assertion rule
**Rule identifier**: `assertion`

**Rule description**: `Do not use Swift assertions. Use Avito assertions: avitoAssert, avitoAssertionFailure`

**Rule kind**: `Idiomatic`

#### Non triggering examples
```
avitoAssert(false, "bad code!")
```

```
// assert(false, "bad code!")
```

```
/* assert(false, "bad code!") */
```

```
"assert(false, "bad code!")"
```

```
avitoAssert  (true, "bad code!")
```

```
// assert  (true, "bad code!")
```

```
/* assert  (true, "bad code!") */
```

```
"assert  (true, "bad code!")"
```

```
avitoAssertionFailure ("bad code!")
```

```
// assertionFailure ("bad code!")
```

```
/* assertionFailure ("bad code!") */
```

```
"assertionFailure ("bad code!")"
```

#### Triggering examples
```
↓assert(false, "bad code!")
```

```
↓assert  (true, "bad code!")
```

```
↓assertionFailure ("bad code!")
```




### <a name="block_based_kvo"/>4/89. Block Based KVO rule
**Rule identifier**: `block_based_kvo`

**Rule description**: `Prefer the new block based KVO API with keypaths when using Swift 3.2 or later.`

**Rule kind**: `Idiomatic`

#### Non triggering examples
```
let observer = foo.observe(\.value, options: [.new]) { (foo, change) in
   print(change.newValue)
}
```

#### Triggering examples
```
class Foo: NSObject {
   override ↓func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {}
}
```

```
class Foo: NSObject {
   override ↓func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: Dictionary<NSKeyValueChangeKey, Any>?,
                               context: UnsafeMutableRawPointer?) {}
}
```




### <a name="bool_type_inference"/>5/89. Bool type inference rule
**Rule identifier**: `bool_type_inference`

**Rule description**: `Omit Bool type specifier in variable declarations`

**Rule kind**: `Style`

#### Non triggering examples
```
let bool = true
```

```
// let bool:Bool = true
```

```
/* let bool:Bool = true */
```

```
"let bool:Bool = true"
```

```
let bool=false
```

```
// let bool: Bool=false
```

```
/* let bool: Bool=false */
```

```
"let bool: Bool=false"
```

```
var bool = true
```

```
// var bool: Bool = true
```

```
/* var bool: Bool = true */
```

```
"var bool: Bool = true"
```

```
var bool = false
```

```
// var bool: Bool = false
```

```
/* var bool: Bool = false */
```

```
"var bool: Bool = false"
```

```
var int = 2; let bool = false
```

```
// var int = 2; let bool: Bool = false
```

```
/* var int = 2; let bool: Bool = false */
```

```
"var int = 2; let bool: Bool = false"
```

```
func foo(bool: Bool = true) {}
```

```
func foo(bool: Bool = false) {}
```

```
private var elements = [Element]()
func foo(bool: Bool = false) {}
```

#### Triggering examples
```
↓let bool:Bool = true
```

```
↓let bool: Bool=false
```

```
↓var bool: Bool = true
```

```
↓var bool: Bool = false
```

```
var int = 2; ↓let bool: Bool = false
```




### <a name="class_delegate_protocol"/>6/89. Class Delegate Protocol rule
**Rule identifier**: `class_delegate_protocol`

**Rule description**: `Delegate protocols should be class-only so they can be weakly referenced.`

**Rule kind**: `Lint`

#### Non triggering examples
```
protocol FooDelegate: class {}
```

```
protocol FooDelegate: class, BarDelegate {}
```

```
protocol Foo {}
```

```
class FooDelegate {}
```

```
@objc protocol FooDelegate {}
```

```
@objc(MyFooDelegate)
 protocol FooDelegate {}
```

```
protocol FooDelegate: BarDelegate {}
```

```
protocol FooDelegate: AnyObject {}
```

```
protocol FooDelegate: NSObjectProtocol {}
```

#### Triggering examples
```
↓protocol FooDelegate {}
```

```
↓protocol FooDelegate: Bar {}
```




### <a name="closing_brace"/>7/89. Closing Brace Spacing rule (autocorrectable)
**Rule identifier**: `closing_brace`

**Rule description**: `Closing brace with closing parenthesis should not have any whitespaces in the middle.`

**Rule kind**: `Style`

#### Non triggering examples
```
[].map({ })
```

```
[].map(
  { }
)
```

#### Triggering examples
```
[].map({ ↓} )
```

```
[].map({ ↓}	)
```

#### Corrections
```
[].map({ ↓} )
->
[].map({ })
```




### <a name="closure_end_indentation"/>8/89. Closure End Indentation rule (autocorrectable)
**Rule identifier**: `closure_end_indentation`

**Rule description**: `Closure end should have the same indentation as the line that started it.`

**Rule kind**: `Style`

#### Non triggering examples
```
SignalProducer(values: [1, 2, 3])
   .startWithNext { number in
       print(number)
   }
```

```
[1, 2].map { $0 + 1 }
```

```
return match(pattern: pattern, with: [.comment]).flatMap { range in
   return Command(string: contents, range: range)
}.flatMap { command in
   return command.expand()
}
```

```
foo(foo: bar,
    options: baz) { _ in }
```

```
someReallyLongProperty.chainingWithAnotherProperty
   .foo { _ in }
```

```
foo(abc, 123)
{ _ in }
```

```
function(
    closure: { x in
        print(x)
    },
    anotherClosure: { y in
        print(y)
    })
```

```
function(parameter: param,
         closure: { x in
    print(x)
})
```

```
function(parameter: param, closure: { x in
        print(x)
    },
    anotherClosure: { y in
        print(y)
    })
```

#### Triggering examples
```
SignalProducer(values: [1, 2, 3])
   .startWithNext { number in
       print(number)
↓}
```

```
return match(pattern: pattern, with: [.comment]).flatMap { range in
   return Command(string: contents, range: range)
   ↓}.flatMap { command in
   return command.expand()
↓}
```

```
function(
    closure: { x in
        print(x)
↓},
    anotherClosure: { y in
        print(y)
↓})
```

#### Corrections
```
return match(pattern: pattern, with: [.comment]).flatMap { range in
   return Command(string: contents, range: range)
↓   }.flatMap { command in
   return command.expand()
↓}
->
return match(pattern: pattern, with: [.comment]).flatMap { range in
   return Command(string: contents, range: range)
}.flatMap { command in
   return command.expand()
}
```

```
function(
    closure: { x in
↓        print(x) })
->
function(
    closure: { x in
        print(x) 
    })
```

```
function(
    closure: { x in
        print(x)
↓ab},
    anotherClosure: { y in
        print(y)
    })
->
function(
    closure: { x in
        print(x)
ab
    },
    anotherClosure: { y in
        print(y)
    })
```

```
SignalProducer(values: [1, 2, 3])
   .startWithNext { number in
       print(number)
↓}.another { x in
       print(x)
↓}.yetAnother { y in
       print(y)
↓})
->
SignalProducer(values: [1, 2, 3])
   .startWithNext { number in
       print(number)
   }.another { x in
       print(x)
   }.yetAnother { y in
       print(y)
   })
```

```
function(
    closure: { x in
↓ab})
->
function(
    closure: { x in
ab
    })
```

```
function(
    closure: { x in
↓        print(x) },
    anotherClosure: { y in
        print(y)
    })
->
function(
    closure: { x in
        print(x) 
    },
    anotherClosure: { y in
        print(y)
    })
```

```
function(
    closure: { x in
        print(x)
↓},
    anotherClosure: { y in
        print(y)
    })
->
function(
    closure: { x in
        print(x)
    },
    anotherClosure: { y in
        print(y)
    })
```

```
function(
    closure: { x in
        print(x)
↓}, anotherClosure: { y in
    print(y)
↓})
->
function(
    closure: { x in
        print(x)
    }, anotherClosure: { y in
    print(y)
    })
```

```
SignalProducer(values: [1, 2, 3])
   .startWithNext { number in
       print(number)
↓}
->
SignalProducer(values: [1, 2, 3])
   .startWithNext { number in
       print(number)
   }
```

```
function(
    closure: { x in
        print(x)
↓       },
    anotherClosure: { y in
        print(y)
    })
->
function(
    closure: { x in
        print(x)
    },
    anotherClosure: { y in
        print(y)
    })
```

```
function(
    closure: { x in
        print(x)
↓})
->
function(
    closure: { x in
        print(x)
    })
```




### <a name="closure_spacing"/>9/89. Closure Spacing rule (autocorrectable)
**Rule identifier**: `closure_spacing`

**Rule description**: `Closure expressions should have a single space inside each brace.`

**Rule kind**: `Style`

#### Non triggering examples
```
[].map ({ $0.description })
```

```
[].filter { $0.contains(location) }
```

```
extension UITableViewCell: ReusableView { }
```

```
extension UITableViewCell: ReusableView {}
```

#### Triggering examples
```
[].filter(↓{$0.contains(location)})
```

```
[].map(↓{$0})
```

```
(↓{each in return result.contains(where: ↓{e in return e}) }).count
```

```
filter ↓{ sorted ↓{ $0 < $1}}
```

#### Corrections
```
({ each in return result.contains(where: ↓{e in return 0}) }).count
->
({ each in return result.contains(where: { e in return 0 }) }).count
```

```
filter ↓{sorted { $0 < $1}}
->
filter { sorted { $0 < $1} }
```

```
[].filter(↓{$0.contains(location)})
->
[].filter({ $0.contains(location) })
```

```
[].map(↓{$0})
->
[].map({ $0 })
```

```
filter { sorted ↓{ $0 < $1} }
->
filter { sorted { $0 < $1 } }
```

```
(↓{each in return result.contains(where: {e in return 0})}).count
->
({ each in return result.contains(where: {e in return 0}) }).count
```




### <a name="comma"/>10/89. Comma Spacing rule (autocorrectable)
**Rule identifier**: `comma`

**Rule description**: `There should be no space before and one after any comma.`

**Rule kind**: `Style`

#### Non triggering examples
```
func abc(a: String, b: String) { }
```

```
abc(a: "string", b: "string"
```

```
enum a { case a, b, c }
```

```
func abc(
  a: String,  // comment
  bcd: String // comment
) {
}
```

```
func abc(
  a: String,
  bcd: String
) {
}
```

#### Triggering examples
```
func abc(a: String↓ ,b: String) { }
```

```
func abc(a: String↓ ,b: String↓ ,c: String↓ ,d: String) { }
```

```
abc(a: "string"↓,b: "string"
```

```
enum a { case a↓ ,b }
```

```
let result = plus(
    first: 3↓ , // #683
    second: 4
)
```

#### Corrections
```
abc(a: "string"↓,b: "string"
->
abc(a: "string", b: "string"
```

```
abc(a: "string"↓  ,  b: "string"
->
abc(a: "string", b: "string"
```

```
enum a { case a↓  ,b }
->
enum a { case a, b }
```

```
let a = [1↓,1]
let b = 1
f(1, b)
->
let a = [1, 1]
let b = 1
f(1, b)
```

```
let a = [1↓,1↓,1↓,1]
->
let a = [1, 1, 1, 1]
```

```
func abc(a: String↓,b: String) {}
->
func abc(a: String, b: String) {}
```




### <a name="compiler_protocol_init"/>11/89. Compiler Protocol Init rule
**Rule identifier**: `compiler_protocol_init`

**Rule description**: `The initializers declared in compiler protocols such as ExpressibleByArrayLiteral shouldn't be called directly.`

**Rule kind**: `Lint`

#### Non triggering examples
```
let set: Set<Int> = [1, 2]
```

```
let set = Set(array)
```

#### Triggering examples
```
let set = ↓Set(arrayLiteral: 1, 2)
```

```
let set = ↓Set.init(arrayLiteral: 1, 2)
```




### <a name="contains_over_first_not_nil"/>12/89. Contains over first not nil rule
**Rule identifier**: `contains_over_first_not_nil`

**Rule description**: `Prefer contains over first(where:) != nil`

**Rule kind**: `Performance`

#### Non triggering examples
```
let first = myList.first(where: { $0 % 2 == 0 })
```

```
let first = myList.first { $0 % 2 == 0 }
```

#### Triggering examples
```
↓myList.first { $0 % 2 == 0 } != nil
```

```
↓myList.first(where: { $0 % 2 == 0 }) != nil
```

```
↓myList.map { $0 + 1 }.first(where: { $0 % 2 == 0 }) != nil
```

```
↓myList.first(where: someFunction) != nil
```

```
↓myList.map { $0 + 1 }.first { $0 % 2 == 0 } != nil
```

```
(↓myList.first { $0 % 2 == 0 }) != nil
```




### <a name="control_statement"/>13/89. Control Statement rule
**Rule identifier**: `control_statement`

**Rule description**: `if,for,while,do,catch statements shouldn't wrap their conditionals or arguments in parentheses.`

**Rule kind**: `Style`

#### Non triggering examples
```
if condition {
```

```
if (a, b) == (0, 1) {
```

```
if (a || b) && (c || d) {
```

```
if (min...max).contains(value) {
```

```
if renderGif(data) {
```

```
renderGif(data)
```

```
for item in collection {
```

```
for (key, value) in dictionary {
```

```
for (index, value) in enumerate(array) {
```

```
for var index = 0; index < 42; index++ {
```

```
guard condition else {
```

```
while condition {
```

```
} while condition {
```

```
do { ; } while condition {
```

```
switch foo {
```

```
do {
} catch let error as NSError {
}
```

```
foo().catch(all: true) {}
```

#### Triggering examples
```
↓if (condition) {
```

```
↓if(condition) {
```

```
↓if ((a || b) && (c || d)) {
```

```
↓if ((min...max).contains(value)) {
```

```
↓for (item in collection) {
```

```
↓for (var index = 0; index < 42; index++) {
```

```
↓for(item in collection) {
```

```
↓for(var index = 0; index < 42; index++) {
```

```
↓guard (condition) else {
```

```
↓while (condition) {
```

```
↓while(condition) {
```

```
} ↓while (condition) {
```

```
} ↓while(condition) {
```

```
do { ; } ↓while(condition) {
```

```
do { ; } ↓while (condition) {
```

```
↓switch (foo) {
```

```
do {
} ↓catch(let error as NSError) {
}
```




### <a name="cyrillic_avito"/>14/89. CyrillicAvito rule
**Rule identifier**: `cyrillic_avito`

**Rule description**: `Вместо Avito пишем Авито`

**Rule kind**: `Idiomatic`

#### Non triggering examples
```
Авито
```

```
"На Авито"
```

```
let string = "Авито"
```

```
"let string = "На Авито""
```

```
AvitoDeepLinksSpecification().registerDeepLinks()
```

```
import AvitoDesignKit
```

```
#if ExportForAvito
```

```
"one unused string literal"

let _ = AvitoNumberFormatter.grouppedNumber()

"second unused  string literal"
```

#### Triggering examples
```
"↓Avito"
```

```
"На ↓Avito"
```

```
let string = "↓Avito"
```

```
"let string = "На ↓Avito""
```




### <a name="cyrillic_letters"/>15/89. Cyrillic Letters rule
**Rule identifier**: `cyrillic_letters`

**Rule description**: `Do not use Cyrillic letters anywhere except strings and comments`

**Rule kind**: `Idiomatic`

#### Non triggering examples
```
final class MyClass {}
```

```
public enum MyEnum {}
```

```
private protocol AProtocol {}
```

```
struct StructExample {}
```

```
typealias oMyAliasable = Double
```

```
var example: String
```

```
var parentTarget: Int {
   get { return 1 }
   set { }
}
```

```
var operatorXor = self.operator
```

```
var someMember = Member()
```

```
let constant = 0
```

```
let constanHeight = -3.0
```

```
let someKind = 11
```

```
let someBasket = Basket()
```

```
enum Enum {
    case OMyCasable
}
```

```
enum Enum {
    case caseName(PeekAndPop)
}
```

```
enum Enum {
    case peekAndPop
}
```

```
let string = "абвгдееёжзиӣклмнопрстуфхцчшщъыйэюяАБВГДЕЁЖЗИӢКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ"
```

```
let string = "абвгдееёжзиӣклмнопрстуфхцчшщъыйэюяАБВГДЕЁЖЗИӢКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ"
"съешь же ещё этих мягких французских булочек, да выпей чаю"
"СЪЕШЬ ЖЕ ЕЩЁ ЭТИХ МЯГКИХ ФРАНЦУЗСКИХ БУЛОЧЕК, ДА ВЫПЕЙ ЧАЮ"
```

```
let int = 1 // абвгдееёжзиӣклмнопрстуфхцчшщъыйэюяАБВГДЕЁЖЗИӢКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ
```

```
/*
 * абвгдееёжзиӣклмнопрстуфхцчшщъыйэюяАБВГДЕЁЖЗИӢКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ
 */
let int = 2
```

#### Triggering examples
```
final class My↓Сlass {}
```

```
public enum My↓Еnum {}
```

```
private protocol ↓АProtocol {}
```

```
struct StructEx↓аmple {}
```

```
typealias ↓оMyAliasable = Double
```

```
var ↓еxample: String
```

```
var parent↓Тarget: Int {
   get { return 1 }
   set { }
}
```

```
var operator↓Хor = self.operator
```

```
var some↓Мember = Member()
```

```
let ↓сonstant = 0
```

```
let constant↓Нeight = -3.0
```

```
let some↓Кind = 11
```

```
let some↓Вasket = Basket()
```

```
enum Enum {
    case ↓ОMyCasable
}
```

```
enum Enum {
    case caseName(↓РeekAndPop)
}
```

```
enum Enum {
    case ↓рeekAndPop
}
```




### <a name="di_resolve"/>16/89. DI resolve rule rule
**Rule identifier**: `di_resolve`

**Rule description**: `Resolve definitions only in Factories and Assemblies.`

**Rule kind**: `Idiomatic`




### <a name="discarded_notification_center_observer"/>17/89. Discarded Notification Center Observer rule
**Rule identifier**: `discarded_notification_center_observer`

**Rule description**: `When registering for a notification using a block, the opaque observer that is returned should be stored so it can be removed later.`

**Rule kind**: `Lint`

#### Non triggering examples
```
let foo = nc.addObserver(forName: .NSSystemTimeZoneDidChange, object: nil, queue: nil) { }
```

```
let foo = nc.addObserver(forName: .NSSystemTimeZoneDidChange, object: nil, queue: nil, using: { })
```

```
func foo() -> Any {
   return nc.addObserver(forName: .NSSystemTimeZoneDidChange, object: nil, queue: nil, using: { })
}
```

#### Triggering examples
```
↓nc.addObserver(forName: .NSSystemTimeZoneDidChange, object: nil, queue: nil) { }
```

```
↓nc.addObserver(forName: .NSSystemTimeZoneDidChange, object: nil, queue: nil, using: { })
```

```
@discardableResult func foo() -> Any {
   return ↓nc.addObserver(forName: .NSSystemTimeZoneDidChange, object: nil, queue: nil, using: { })
}
```




### <a name="discouraged_direct_init"/>18/89. Discouraged Direct Initialization rule
**Rule identifier**: `discouraged_direct_init`

**Rule description**: `Discouraged direct initialization of types that can be harmful.`

**Rule kind**: `Lint`

#### Non triggering examples
```
let foo = UIDevice.current
```

```
let foo = Bundle.main
```

```
let foo = Bundle(path: "bar")
```

```
let foo = Bundle(identifier: "bar")
```

```
let foo = Bundle.init(path: "bar")
```

```
let foo = Bundle.init(identifier: "bar")
```

#### Triggering examples
```
↓UIDevice()
```

```
↓Bundle()
```

```
let foo = ↓UIDevice()
```

```
let foo = ↓Bundle()
```

```
let foo = bar(bundle: ↓Bundle(), device: ↓UIDevice())
```

```
↓UIDevice.init()
```

```
↓Bundle.init()
```

```
let foo = ↓UIDevice.init()
```

```
let foo = ↓Bundle.init()
```

```
let foo = bar(bundle: ↓Bundle.init(), device: ↓UIDevice.init())
```




### <a name="discouraged_object_literal"/>19/89. Discouraged Object Literal rule
**Rule identifier**: `discouraged_object_literal`

**Rule description**: `Prefer initializers over object literals.`

**Rule kind**: `Idiomatic`

#### Non triggering examples
```
let image = UIImage(named: aVariable)
```

```
let image = UIImage(named: "interpolated \(variable)")
```

```
let color = UIColor(red: value, green: value, blue: value, alpha: 1)
```

```
let image = NSImage(named: aVariable)
```

```
let image = NSImage(named: "interpolated \(variable)")
```

```
let color = NSColor(red: value, green: value, blue: value, alpha: 1)
```

#### Triggering examples
```
let image = ↓#imageLiteral(resourceName: "image.jpg")
```

```
let color = ↓#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
```




### <a name="empty_count"/>20/89. Empty Count rule
**Rule identifier**: `empty_count`

**Rule description**: `Prefer checking isEmpty over comparing count to zero.`

**Rule kind**: `Performance`

#### Non triggering examples
```
var count = 0
```

```
[Int]().isEmpty
```

```
[Int]().count > 1
```

```
[Int]().count == 1
```

```
discount == 0
```

```
order.discount == 0
```

#### Triggering examples
```
[Int]().↓count == 0
```

```
[Int]().↓count > 0
```

```
[Int]().↓count != 0
```

```
↓count == 0
```




### <a name="empty_enum_arguments"/>21/89. Empty Enum Arguments rule (autocorrectable)
**Rule identifier**: `empty_enum_arguments`

**Rule description**: `Arguments can be omitted when matching enums with associated types if they are not used.`

**Rule kind**: `Style`

#### Non triggering examples
```
switch foo {
    case .bar: break
}
```

```
switch foo {
    case .bar(let x): break
}
```

```
switch foo {
    case let .bar(x): break
}
```

```
switch (foo, bar) {
    case (_, _): break
}
```

```
switch foo {
    case "bar".uppercased(): break
}
```

```
switch (foo, bar) {
    case (_, _) where !something: break
}
```

```
switch foo {
    case (let f as () -> String)?: break
}
```

```
switch foo {
    default: break
}
```

#### Triggering examples
```
switch foo {
    case .bar↓(_): break
}
```

```
switch foo {
    case .bar↓(): break
}
```

```
switch foo {
    case .bar↓(_), .bar2↓(_): break
}
```

```
switch foo {
    case .bar↓() where method() > 2: break
}
```

```
func example(foo: Foo) {
    switch foo {
    case case .bar↓(_):
        break
    }
}
```

#### Corrections
```
switch foo {
    case .bar↓() where method() > 2: break
}
->
switch foo {
    case .bar where method() > 2: break
}
```

```
func example(foo: Foo) {
    switch foo {
    case case .bar↓(_):
        break
    }
}
->
func example(foo: Foo) {
    switch foo {
    case case .bar:
        break
    }
}
```

```
switch foo {
    case .bar↓(_): break
}
->
switch foo {
    case .bar: break
}
```

```
switch foo {
    case .bar↓(_), .bar2↓(_): break
}
->
switch foo {
    case .bar, .bar2: break
}
```

```
switch foo {
    case .bar↓(): break
}
->
switch foo {
    case .bar: break
}
```




### <a name="empty_parameters"/>22/89. Empty Parameters rule (autocorrectable)
**Rule identifier**: `empty_parameters`

**Rule description**: `Prefer () ->  over Void -> .`

**Rule kind**: `Style`

#### Non triggering examples
```
let abc: () -> Void = {}
```

```
func foo(completion: () -> Void)
```

```
func foo(completion: () thows -> Void)
```

```
let foo: (ConfigurationTests) -> Void throws -> Void)
```

```
let foo: (ConfigurationTests) ->   Void throws -> Void)
```

```
let foo: (ConfigurationTests) ->Void throws -> Void)
```

#### Triggering examples
```
let abc: ↓(Void) -> Void = {}
```

```
func foo(completion: ↓(Void) -> Void)
```

```
func foo(completion: ↓(Void) throws -> Void)
```

```
let foo: ↓(Void) -> () throws -> Void)
```

#### Corrections
```
let foo: ↓(Void) -> () throws -> Void)
->
let foo: () -> () throws -> Void)
```

```
func foo(completion: ↓(Void) -> Void)
->
func foo(completion: () -> Void)
```

```
let abc: ↓(Void) -> Void = {}
->
let abc: () -> Void = {}
```

```
func foo(completion: ↓(Void) throws -> Void)
->
func foo(completion: () throws -> Void)
```




### <a name="empty_parentheses_with_trailing_closure"/>23/89. Empty Parentheses with Trailing Closure rule (autocorrectable)
**Rule identifier**: `empty_parentheses_with_trailing_closure`

**Rule description**: `When using trailing closures, empty parentheses should be avoided after the method call.`

**Rule kind**: `Style`

#### Non triggering examples
```
[1, 2].map { $0 + 1 }
```

```
[1, 2].map({ $0 + 1 })
```

```
[1, 2].reduce(0) { $0 + $1 }
```

```
[1, 2].map { number in
 number + 1 
}
```

```
let isEmpty = [1, 2].isEmpty()
```

```
UIView.animateWithDuration(0.3, animations: {
   self.disableInteractionRightView.alpha = 0
}, completion: { _ in
   ()
})
```

#### Triggering examples
```
[1, 2].map↓() { $0 + 1 }
```

```
[1, 2].map↓( ) { $0 + 1 }
```

```
[1, 2].map↓() { number in
 number + 1 
}
```

```
[1, 2].map↓(  ) { number in
 number + 1 
}
```

```
func foo() -> [Int] {
    return [1, 2].map↓() { $0 + 1 }
}
```

#### Corrections
```
[1, 2].map↓() { $0 + 1 }
->
[1, 2].map { $0 + 1 }
```

```
[1, 2].map↓() { number in
 number + 1 
}
->
[1, 2].map { number in
 number + 1 
}
```

```
func foo() -> [Int] {
    return [1, 2].map↓() { $0 + 1 }
}
->
func foo() -> [Int] {
    return [1, 2].map { $0 + 1 }
}
```

```
class C {
#if true
func f() {
[1, 2].map↓() { $0 + 1 }
}
#endif
}
->
class C {
#if true
func f() {
[1, 2].map { $0 + 1 }
}
#endif
}
```

```
[1, 2].map↓( ) { $0 + 1 }
->
[1, 2].map { $0 + 1 }
```

```
[1, 2].map↓(  ) { number in
 number + 1 
}
->
[1, 2].map { number in
 number + 1 
}
```




### <a name="empty_string"/>24/89. Empty String rule
**Rule identifier**: `empty_string`

**Rule description**: `Prefer checking isEmpty over comparing string to an empty string literal.`

**Rule kind**: `Performance`

#### Non triggering examples
```
myString.isEmpty
```

```
!myString.isEmpy
```

#### Triggering examples
```
myString↓ == ""
```

```
myString↓ != ""
```




### <a name="empty_tuple_return"/>25/89. Empty Tuple Return rule (autocorrectable)
**Rule identifier**: `empty_tuple_return`

**Rule description**: `Prefer -> () over -> Void.`

**Rule kind**: `Style`

#### Non triggering examples
```
let abc: () -> () = {}
```

```
func foo(completion: () -> ())
```

```
func foo(completion: () -> (   ))
```

```
let foo: (ConfigurationTests) -> () throws -> ())
```

#### Triggering examples
```
let abc: () -> ↓Void = {}
```

```
func foo(completion: () -> ↓Void)
```

```
let foo: (ConfigurationTests) -> () throws -> ↓Void)
```

```
let foo: (ConfigurationTests) ->   () throws -> ↓Void)
```

```
let foo: (ConfigurationTests) ->() throws -> ↓Void)
```

```
let foo: (ConfigurationTests) -> () -> ↓Void)
```

#### Corrections
```
let abc: () -> ↓Void = {}
->
let abc: () -> () = {}
```

```
func foo(completion: () -> ↓Void)
->
func foo(completion: () -> ())
```

```
let foo: (ConfigurationTests) -> () throws -> ↓Void)
->
let foo: (ConfigurationTests) -> () throws -> ())
```




### <a name="empty_xctest_method"/>26/89. Empty XCTest Method rule
**Rule identifier**: `empty_xctest_method`

**Rule description**: `Empty XCTest method should be avoided.`

**Rule kind**: `Lint`

#### Non triggering examples
```
class TotoTests: XCTestCase {
    var foobar: Foobar?

    override func setUp() {
        super.setUp()
        foobar = Foobar()
    }

    override func tearDown() {
        foobar = nil
        super.tearDown()
    }

    func testFoo() {
        XCTAssertTrue(foobar?.foo)
    }

    func testBar() {
        // comment...

        XCTAssertFalse(foobar?.bar)

        // comment...
    }
}
```

```
class Foobar {
    func setUp() {}

    func tearDown() {}

    func testFoo() {}
}
```

```
class TotoTests: XCTestCase {
    func setUp(with object: Foobar) {}

    func tearDown(object: Foobar) {}

    func testFoo(_ foo: Foobar) {}

    func testBar(bar: (String) -> Int) {}
}
```

```
class TotoTests: XCTestCase {
    func testFoo() { XCTAssertTrue(foobar?.foo) }

    func testBar() { XCTAssertFalse(foobar?.bar) }
}
```

#### Triggering examples
```
class TotoTests: XCTestCase {
    override ↓func setUp() {
    }

    override ↓func tearDown() {

    }

    ↓func testFoo() {


    }

    ↓func testBar() {



    }

    func helperFunction() {
    }
}
```

```
class TotoTests: XCTestCase {
    override ↓func setUp() {}

    override ↓func tearDown() {}

    ↓func testFoo() {}

    func helperFunction() {}
}
```

```
class TotoTests: XCTestCase {
    override ↓func setUp() {
        // comment...
    }

    override ↓func tearDown() {
        // comment...
        // comment...
    }

    ↓func testFoo() {
        // comment...

        // comment...

        // comment...
    }

    ↓func testBar() {
        /*
         * comment...
         *
         * comment...
         *
         * comment...
         */
    }

    func helperFunction() {
    }
}
```

```
class FooTests: XCTestCase {
    override ↓func setUp() {}
}

class BarTests: XCTestCase {
    ↓func testFoo() {}
}
```




### <a name="excessive_spaces_after_colon"/>27/89. Excessive spaces after colon rule (autocorrectable)
**Rule identifier**: `excessive_spaces_after_colon`

**Rule description**: `There must be no more then 1 space or tab after colon`

**Rule kind**: `Style`

#### Non triggering examples
```
static let bool: Bool
```

```
// static let bool:  Bool
```

```
/* static let bool:  Bool */
```

```
"static let bool:  Bool"
```

```
private let dictionary: [String: Bool]
```

```
// private let dictionary: [String:  Bool]
```

```
/* private let dictionary: [String:  Bool] */
```

```
"private let dictionary: [String:  Bool]"
```

```
static var bool: Bool
```

```
// static var bool:  Bool
```

```
/* static var bool:  Bool */
```

```
"static var bool:  Bool"
```

```
private var dictionary: [String: Bool]
```

```
// private var dictionary: [String:  Bool]
```

```
/* private var dictionary: [String:  Bool] */
```

```
"private var dictionary: [String:  Bool]"
```

```
let onFoo: ((_ bool: Bool) -> ())
```

```
// let onFoo:  ((_ bool: Bool) -> ())
```

```
/* let onFoo:  ((_ bool: Bool) -> ()) */
```

```
"let onFoo:  ((_ bool: Bool) -> ())"
```

```
let onFoo: ((_ dictionary: [String: Bool]) -> ())
```

```
// let onFoo: ((_ dictionary: [String:  Bool]) -> ())
```

```
/* let onFoo: ((_ dictionary: [String:  Bool]) -> ()) */
```

```
"let onFoo: ((_ dictionary: [String:  Bool]) -> ())"
```

```
var onFoo: ((_ bool: Bool) -> ())
```

```
// var onFoo:  ((_ bool: Bool) -> ())
```

```
/* var onFoo:  ((_ bool: Bool) -> ()) */
```

```
"var onFoo:  ((_ bool: Bool) -> ())"
```

```
var onFoo: ((_ dictionary: [String: Bool]) -> ())
```

```
// var onFoo: ((_ dictionary: [String:  Bool]) -> ())
```

```
/* var onFoo: ((_ dictionary: [String:  Bool]) -> ()) */
```

```
"var onFoo: ((_ dictionary: [String:  Bool]) -> ())"
```

```
func foo(bool: Bool) {}
```

```
// func foo(bool:  Bool) {}
```

```
/* func foo(bool:  Bool) {} */
```

```
"func foo(bool:  Bool) {}"
```

```
func foo(_ bool: Bool, int: Int) {}
```

```
// func foo(_ bool: Bool, int:  Int) {}
```

```
/* func foo(_ bool: Bool, int:  Int) {} */
```

```
"func foo(_ bool: Bool, int:  Int) {}"
```

```
func foo(completion: ((_ dictionary: [String: Bool]) -> ())) {}
```

```
// func foo(completion: ((_ dictionary: [String:   Bool]) -> ())) {}
```

```
/* func foo(completion: ((_ dictionary: [String:   Bool]) -> ())) {} */
```

```
"func foo(completion: ((_ dictionary: [String:   Bool]) -> ())) {}"
```

```
switch value { case 1: return; case 2...4: return; default: return }
```

```
// switch value { case 1:  return; case 2...4: return; default: return }
```

```
/* switch value { case 1:  return; case 2...4: return; default: return } */
```

```
"switch value { case 1:  return; case 2...4: return; default: return }"
```

```
switch value { case 1: return; case 2...4: return; default: return }
```

```
// switch value { case 1: return; case 2...4:  return; default: return }
```

```
/* switch value { case 1: return; case 2...4:  return; default: return } */
```

```
"switch value { case 1: return; case 2...4:  return; default: return }"
```

```
switch value { case 1: return; case 2...4: return; default: return }
```

```
// switch value { case 1: return; case 2...4: return; default:  return }
```

```
/* switch value { case 1: return; case 2...4: return; default:  return } */
```

```
"switch value { case 1: return; case 2...4: return; default:  return }"
```

```
let size = CGSize(width: 1, height: 2)
```

```
// let size = CGSize(width:  1, height: 2)
```

```
/* let size = CGSize(width:  1, height: 2) */
```

```
"let size = CGSize(width:  1, height: 2)"
```

```
let size = CGSize(width: 1, height: 2)
```

```
// let size = CGSize(width: 1, height:  2)
```

```
/* let size = CGSize(width: 1, height:  2) */
```

```
"let size = CGSize(width: 1, height:  2)"
```

```
let filtered = array.filter { (item: Any?) in return item }
```

```
// let filtered = array.filter { (item:  Any?) in return item }
```

```
/* let filtered = array.filter { (item:  Any?) in return item } */
```

```
"let filtered = array.filter { (item:  Any?) in return item }"
```

```
let filtered = array.enumetated.filter { ((offset: Int, element: String)) -> Bool in true }
```

```
// let filtered = array.enumetated.filter { ((offset:  Int, element: String)) -> Bool in true }
```

```
/* let filtered = array.enumetated.filter { ((offset:  Int, element: String)) -> Bool in true } */
```

```
"let filtered = array.enumetated.filter { ((offset:  Int, element: String)) -> Bool in true }"
```

```
let filtered = array.enumetated.filter { ((offset: Int, element: String)) -> Bool in true }
```

```
// let filtered = array.enumetated.filter { ((offset: Int, element:    String)) -> Bool in true }
```

```
/* let filtered = array.enumetated.filter { ((offset: Int, element:    String)) -> Bool in true } */
```

```
"let filtered = array.enumetated.filter { ((offset: Int, element:    String)) -> Bool in true }"
```

```
return true ? 1 : 0
```

```
// return true ? 1 :    0
```

```
/* return true ? 1 :    0 */
```

```
"return true ? 1 :    0"
```

#### Triggering examples
```
static let bool↓:  Bool
```

```
private let dictionary: [String↓:  Bool]
```

```
static var bool↓:  Bool
```

```
private var dictionary: [String↓:  Bool]
```

```
let onFoo↓:  ((_ bool: Bool) -> ())
```

```
let onFoo: ((_ dictionary: [String↓:  Bool]) -> ())
```

```
var onFoo↓:  ((_ bool: Bool) -> ())
```

```
var onFoo: ((_ dictionary: [String↓:  Bool]) -> ())
```

```
func foo(bool↓:  Bool) {}
```

```
func foo(_ bool: Bool, int↓:  Int) {}
```

```
func foo(completion: ((_ dictionary: [String↓:   Bool]) -> ())) {}
```

```
switch value { case 1↓:  return; case 2...4: return; default: return }
```

```
switch value { case 1: return; case 2...4↓:  return; default: return }
```

```
switch value { case 1: return; case 2...4: return; default↓:  return }
```

```
let size = CGSize(width↓:  1, height: 2)
```

```
let size = CGSize(width: 1, height↓:  2)
```

```
let filtered = array.filter { (item↓:  Any?) in return item }
```

```
let filtered = array.enumetated.filter { ((offset↓:  Int, element: String)) -> Bool in true }
```

```
let filtered = array.enumetated.filter { ((offset: Int, element↓:    String)) -> Bool in true }
```

```
return true ? 1 ↓:    0
```

#### Corrections
```
func foo(_ bool: Bool, int↓:  Int) {}
->
func foo(_ bool: Bool, int: Int) {}
```

```
let filtered = array.enumetated.filter { ((offset↓:  Int, element: String)) -> Bool in true }
->
let filtered = array.enumetated.filter { ((offset: Int, element: String)) -> Bool in true }
```

```
static let bool↓:  Bool
->
static let bool: Bool
```

```
let onFoo: ((_ dictionary: [String↓:  Bool]) -> ())
->
let onFoo: ((_ dictionary: [String: Bool]) -> ())
```

```
var onFoo: ((_ dictionary: [String↓:  Bool]) -> ())
->
var onFoo: ((_ dictionary: [String: Bool]) -> ())
```

```
var onFoo↓:  ((_ bool: Bool) -> ())
->
var onFoo: ((_ bool: Bool) -> ())
```

```
func foo(bool↓:  Bool) {}
->
func foo(bool: Bool) {}
```

```
let filtered = array.filter { (item↓:  Any?) in return item }
->
let filtered = array.filter { (item: Any?) in return item }
```

```
switch value { case 1↓:  return; case 2...4: return; default: return }
->
switch value { case 1: return; case 2...4: return; default: return }
```

```
let onFoo↓:  ((_ bool: Bool) -> ())
->
let onFoo: ((_ bool: Bool) -> ())
```

```
private let dictionary: [String↓:  Bool]
->
private let dictionary: [String: Bool]
```

```
switch value { case 1: return; case 2...4↓:  return; default: return }
->
switch value { case 1: return; case 2...4: return; default: return }
```

```
let filtered = array.enumetated.filter { ((offset: Int, element↓:    String)) -> Bool in true }
->
let filtered = array.enumetated.filter { ((offset: Int, element: String)) -> Bool in true }
```

```
return true ? 1 ↓:    0
->
return true ? 1 : 0
```

```
let size = CGSize(width↓:  1, height: 2)
->
let size = CGSize(width: 1, height: 2)
```

```
private var dictionary: [String↓:  Bool]
->
private var dictionary: [String: Bool]
```

```
func foo(completion: ((_ dictionary: [String↓:   Bool]) -> ())) {}
->
func foo(completion: ((_ dictionary: [String: Bool]) -> ())) {}
```

```
static var bool↓:  Bool
->
static var bool: Bool
```

```
let size = CGSize(width: 1, height↓:  2)
->
let size = CGSize(width: 1, height: 2)
```

```
switch value { case 1: return; case 2...4: return; default↓:  return }
->
switch value { case 1: return; case 2...4: return; default: return }
```




### <a name="explicit_init"/>28/89. Explicit Init rule (autocorrectable)
**Rule identifier**: `explicit_init`

**Rule description**: `Explicitly calling .init() should be avoided.`

**Rule kind**: `Idiomatic`

#### Non triggering examples
```
import Foundation; class C: NSObject { override init() { super.init() }}
```

```
struct S { let n: Int }; extension S { init() { self.init(n: 1) } }
```

```
[1].flatMap(String.init)
```

```
[String.self].map { $0.init(1) }
```

```
[String.self].map { type in type.init(1) }
```

#### Triggering examples
```
[1].flatMap{String↓.init($0)}
```

```
[String.self].map { Type in Type↓.init(1) }
```

```
func foo() -> [String] {
    return [1].flatMap { String↓.init($0) }
}
```

#### Corrections
```
[1].flatMap{String↓.init($0)}
->
[1].flatMap{String($0)}
```

```
func foo() -> [String] {
    return [1].flatMap { String↓.init($0) }
}
->
func foo() -> [String] {
    return [1].flatMap { String($0) }
}
```

```
class C {
#if true
func f() {
[1].flatMap{String.init($0)}
}
#endif
}
->
class C {
#if true
func f() {
[1].flatMap{String($0)}
}
#endif
}
```




### <a name="fatal_error_message"/>29/89. Fatal Error Message rule
**Rule identifier**: `fatal_error_message`

**Rule description**: `A fatalError call should have a message.`

**Rule kind**: `Idiomatic`

#### Non triggering examples
```
func foo() {
  fatalError("Foo")
}
```

```
func foo() {
  fatalError(x)
}
```

#### Triggering examples
```
func foo() {
  ↓fatalError("")
}
```

```
func foo() {
  ↓fatalError()
}
```




### <a name="feature_toggle_import"/>30/89. Feature toggle import rule rule
**Rule identifier**: `feature_toggle_import`

**Rule description**: `Delete unused import of FeatureToggle`

**Rule kind**: `Idiomatic`

#### Non triggering examples
```
import FeatureToggle
if FeatureToggle.features.SmalsFuryEnabled {
    print("FUS RO DAH")
}
```

#### Triggering examples
```
↓import FeatureToggle
```




### <a name="first_where"/>31/89. First Where rule
**Rule identifier**: `first_where`

**Rule description**: `Prefer using .first(where:) over .filter { }.first in collections.`

**Rule kind**: `Performance`

#### Non triggering examples
```
kinds.filter(excludingKinds.contains).isEmpty && kinds.first == .identifier
```

```
myList.first(where: { $0 % 2 == 0 })
```

```
match(pattern: pattern).filter { $0.first == .identifier }
```

```
(myList.filter { $0 == 1 }.suffix(2)).first
```

#### Triggering examples
```
↓myList.filter { $0 % 2 == 0 }.first
```

```
↓myList.filter({ $0 % 2 == 0 }).first
```

```
↓myList.map { $0 + 1 }.filter({ $0 % 2 == 0 }).first
```

```
↓myList.map { $0 + 1 }.filter({ $0 % 2 == 0 }).first?.something()
```

```
↓myList.filter(someFunction).first
```

```
↓myList.filter({ $0 % 2 == 0 })
.first
```

```
(↓myList.filter { $0 == 1 }).first
```




### <a name="force_cast"/>32/89. Force Cast rule
**Rule identifier**: `force_cast`

**Rule description**: `Force casts should be avoided.`

**Rule kind**: `Idiomatic`

#### Non triggering examples
```
NSNumber() as? Int
```

#### Triggering examples
```
NSNumber() ↓as! Int
```




### <a name="force_try"/>33/89. Force Try rule
**Rule identifier**: `force_try`

**Rule description**: `Force tries should be avoided.`

**Rule kind**: `Idiomatic`

#### Non triggering examples
```
func a() throws {}; do { try a() } catch {}
```

#### Triggering examples
```
func a() throws {}; ↓try! a()
```




### <a name="force_unwrapping"/>34/89. Force Unwrapping rule
**Rule identifier**: `force_unwrapping`

**Rule description**: `Force unwrapping should be avoided.`

**Rule kind**: `Idiomatic`

#### Non triggering examples
```
if let url = NSURL(string: query)
```

```
navigationController?.pushViewController(viewController, animated: true)
```

```
let s as! Test
```

```
try! canThrowErrors()
```

```
let object: Any!
```

```
@IBOutlet var constraints: [NSLayoutConstraint]!
```

```
setEditing(!editing, animated: true)
```

```
navigationController.setNavigationBarHidden(!navigationController.navigationBarHidden, animated: true)
```

```
if addedToPlaylist && (!self.selectedFilters.isEmpty || self.searchBar?.text?.isEmpty == false) {}
```

```
print("\(xVar)!")
```

```
var test = (!bar)
```

```
var a: [Int]!
```

```
private var myProperty: (Void -> Void)!
```

```
func foo(_ options: [AnyHashable: Any]!) {
```

```
func foo() -> [Int]!
```

```
func foo() -> [AnyHashable: Any]!
```

```
func foo() -> [Int]! { return [] }
```

#### Triggering examples
```
let url = NSURL(string: query)↓!
```

```
navigationController↓!.pushViewController(viewController, animated: true)
```

```
let unwrapped = optional↓!
```

```
return cell↓!
```

```
let url = NSURL(string: "http://www.google.com")↓!
```

```
let dict = ["Boooo": "👻"]func bla() -> String { return dict["Boooo"]↓! }
```

```
let dict = ["Boooo": "👻"]func bla() -> String { return dict["Boooo"]↓!.contains("B") }
```

```
let a = dict["abc"]↓!.contains("B")
```

```
dict["abc"]↓!.bar("B")
```

```
if dict["a"]↓!!!! {
```

```
var foo: [Bool]! = dict["abc"]↓!
```

```
context("abc") {
  var foo: [Bool]! = dict["abc"]↓!
}
```

```
open var computed: String { return foo.bar↓! }
```




### <a name="generic_type_name"/>35/89. Generic Type Name rule
**Rule identifier**: `generic_type_name`

**Rule description**: `Generic type name should only contain alphanumeric characters, start with an uppercase character and span between 1 and 20 characters in length.`

**Rule kind**: `Idiomatic`

#### Non triggering examples
```
func foo<T>() {}
```

```
func foo<T>() -> T {}
```

```
func foo<T, U>(param: U) -> T {}
```

```
func foo<T: Hashable, U: Rule>(param: U) -> T {}
```

```
struct Foo<T> {}
```

```
class Foo<T> {}
```

```
enum Foo<T> {}
```

```
func run(_ options: NoOptions<CommandantError<()>>) {}
```

```
func foo(_ options: Set<type>) {}
```

```
func < <T: Comparable>(lhs: T?, rhs: T?) -> Bool
```

```
func configureWith(data: Either<MessageThread, (project: Project, backing: Backing)>)
```

```
typealias StringDictionary<T> = Dictionary<String, T>
```

```
typealias BackwardTriple<T1, T2, T3> = (T3, T2, T1)
```

```
typealias DictionaryOfStrings<T : Hashable> = Dictionary<T, String>
```

#### Triggering examples
```
func foo<↓T_Foo>() {}
```

```
func foo<T, ↓U_Foo>(param: U_Foo) -> T {}
```

```
func foo<↓TTTTTTTTTTTTTTTTTTTTT>() {}
```

```
func foo<↓type>() {}
```

```
typealias StringDictionary<↓T_Foo> = Dictionary<String, T_Foo>
```

```
typealias BackwardTriple<T1, ↓T2_Bar, T3> = (T3, T2_Bar, T1)
```

```
typealias DictionaryOfStrings<↓T_Foo: Hashable> = Dictionary<T, String>
```

```
class Foo<↓T_Foo> {}
```

```
class Foo<T, ↓U_Foo> {}
```

```
class Foo<↓T_Foo, ↓U_Foo> {}
```

```
class Foo<↓TTTTTTTTTTTTTTTTTTTTT> {}
```

```
class Foo<↓type> {}
```

```
struct Foo<↓T_Foo> {}
```

```
struct Foo<T, ↓U_Foo> {}
```

```
struct Foo<↓T_Foo, ↓U_Foo> {}
```

```
struct Foo<↓TTTTTTTTTTTTTTTTTTTTT> {}
```

```
struct Foo<↓type> {}
```

```
enum Foo<↓T_Foo> {}
```

```
enum Foo<T, ↓U_Foo> {}
```

```
enum Foo<↓T_Foo, ↓U_Foo> {}
```

```
enum Foo<↓TTTTTTTTTTTTTTTTTTTTT> {}
```

```
enum Foo<↓type> {}
```




### <a name="implicit_getter"/>36/89. Implicit Getter rule
**Rule identifier**: `implicit_getter`

**Rule description**: `Computed read-only properties and subscripts should avoid using the get keyword.`

**Rule kind**: `Style`

#### Non triggering examples
```
class Foo {
    var foo: Int {
        get { return 3 }
        set { _abc = newValue }
    }
}
```

```
class Foo {
    var foo: Int {
        return 20
    }
}
```

```
class Foo {
    static var foo: Int {
        return 20
    }
}
```

```
class Foo {
    static var foo: Int {
        get { return 3 }
        set { _abc = newValue }
    }
}
```

```
class Foo {
    var foo: Int
}
```

```
class Foo {
    var foo: Int {
        return getValueFromDisk()
    }
}
```

```
class Foo {
    var foo: String {
        return "get"
    }
}
```

```
protocol Foo {
    var foo: Int { get }
```

```
protocol Foo {
    var foo: Int { get set }
```

```
class Foo {
    var foo: Int {
        struct Bar {
            var bar: Int {
                get { return 1 }
                set { _ = newValue }
            }
        }

        return Bar().bar
    }
}
```

```
var _objCTaggedPointerBits: UInt {
    @inline(__always) get { return 0 }
}
```

```
var next: Int? {
    mutating get {
        defer { self.count += 1 }
        return self.count
    }
}
```

```
class Foo {
    subscript(i: Int) -> Int {
        return 20
    }
}
```

```
class Foo {
    subscript(i: Int) -> Int {
        get { return 3 }
        set { _abc = newValue }
    }
}
```

```
protocol Foo {
    subscript(i: Int) -> Int { get }
}
```

```
protocol Foo {
    subscript(i: Int) -> Int { get set }
}
```

#### Triggering examples
```
class Foo {
    var foo: Int {
        ↓get {
            return 20
        }
    }
}
```

```
class Foo {
    var foo: Int {
        ↓get{ return 20 }
    }
}
```

```
class Foo {
    static var foo: Int {
        ↓get {
            return 20
        }
    }
}
```

```
var foo: Int {
    ↓get { return 20 }
}
```

```
class Foo {
    @objc func bar() {}
    var foo: Int {
        ↓get {
            return 20
        }
    }
}
```

```
class Foo {
    subscript(i: Int) -> Int {
        ↓get {
            return 20
        }
    }
}
```




### <a name="implicit_return"/>37/89. Implicit Return rule (autocorrectable)
**Rule identifier**: `implicit_return`

**Rule description**: `Prefer implicit returns in closures.`

**Rule kind**: `Style`

#### Non triggering examples
```
foo.map { $0 + 1 }
```

```
foo.map({ $0 + 1 })
```

```
foo.map { value in value + 1 }
```

```
func foo() -> Int {
  return 0
}
```

```
if foo {
  return 0
}
```

```
var foo: Bool { return true }
```

#### Triggering examples
```
foo.map { value in
  ↓return value + 1
}
```

```
foo.map {
  ↓return $0 + 1
}
```

```
foo.map({ ↓return $0 + 1})
```

```
[1, 2].first(where: {
    ↓return true
})
```

#### Corrections
```
[1, 2].first(where: {
    ↓return true
})
->
[1, 2].first(where: {
    true
})
```

```
foo.map { value in
  ↓return value + 1
}
->
foo.map { value in
  value + 1
}
```

```
foo.map {
  ↓return $0 + 1
}
->
foo.map {
  $0 + 1
}
```

```
foo.map({ ↓return $0 + 1})
->
foo.map({ $0 + 1})
```




### <a name="implicitly_unwrapped_optional"/>38/89. Implicitly Unwrapped Optional rule
**Rule identifier**: `implicitly_unwrapped_optional`

**Rule description**: `Implicitly unwrapped optionals should be avoided when possible.`

**Rule kind**: `Idiomatic`

#### Non triggering examples
```
@IBOutlet private var label: UILabel!
```

```
@IBOutlet var label: UILabel!
```

```
@IBOutlet var label: [UILabel!]
```

```
if !boolean {}
```

```
let int: Int? = 42
```

```
let int: Int? = nil
```

#### Triggering examples
```
let label: UILabel!
```

```
let IBOutlet: UILabel!
```

```
let labels: [UILabel!]
```

```
var ints: [Int!] = [42, nil, 42]
```

```
let label: IBOutlet!
```

```
let int: Int! = 42
```

```
let int: Int! = nil
```

```
var int: Int! = 42
```

```
let int: ImplicitlyUnwrappedOptional<Int>
```

```
let collection: AnyCollection<Int!>
```

```
func foo(int: Int!) {}
```




### <a name="inset_by"/>39/89. InsetBy rule (autocorrectable)
**Rule identifier**: `inset_by`

**Rule description**: `Do not use crashy insetBy(dx:dy:). Use avitoInsetBy(dx:dy:)`

**Rule kind**: `Idiomatic`

#### Non triggering examples
```
rect.avitoInsetBy(dx: 8, dy: 8)
```

```
rect.avitoInsetBy(
    dx: 8,
    dy: 8
)
```

```
avitoInsetBy(dx: 8, dy: 8)
```

```
avitoInsetBy(
    dx: 8,
    dy: 8
)
```

#### Triggering examples
```
rect.↓insetBy(dx: 8, dy: 8)
```

```
rect.↓insetBy(
    dx: 8,
    dy: 8
)
```

```
↓insetBy(dx: 8, dy: 8)
```

```
↓insetBy(
    dx: 8,
    dy: 8
)
```

#### Corrections
```
rect.↓insetBy(
    dx: 8,
    dy: 8
)
->
rect.avitoInsetBy(
    dx: 8,
    dy: 8
)
```

```
↓insetBy(dx: 8, dy: 8)
->
avitoInsetBy(dx: 8, dy: 8)
```

```
rect.↓insetBy(dx: 8, dy: 8)
->
rect.avitoInsetBy(dx: 8, dy: 8)
```

```
↓insetBy(
    dx: 8,
    dy: 8
)
->
avitoInsetBy(
    dx: 8,
    dy: 8
)
```




### <a name="internal_access_modifier"/>40/89. Internal Access Modifier rule (autocorrectable)
**Rule identifier**: `internal_access_modifier`

**Rule description**: `Do not use an internal access modifier as being a default one`

**Rule kind**: `Style`

#### Non triggering examples
```
protocol MyProtocol {}
```

```
final class MyClass {}
```

```
class MyClass {
    let counter = 0
}
```

```
class MyClass {
    var counter { return 0 }
}
```

```
class MyClass {
    func foo() {}
}
```

```
enum MyEnumTriggering: Int {}
```

```
enum MyEnumTriggering: String {
    var counter { return 0 }
}
```

```
enum MyEnumTriggering {
    func foo() {}
}
```

```
struct MyStruct {}
```

```
struct MyStruct { 
    let counter = 0
}
```

```
struct MyStruct {
    var counter { return 0 }
}
```

```
struct MyStruct {
    func foo() {}
}
```

```
struct MyStruct {
    class InternalClass() {}
}
```

```
var counter { return 0 }
```

```
func foo() {}
```

```
static let value = MyClass()
```

#### Triggering examples
```
↓internal protocol MyProtocol {}
```

```
final ↓internal class MyClass {}
```

```
class MyClass {
    ↓internal let counter = 0
}
```

```
class MyClass {
    ↓internal var counter { return 0 }
}
```

```
class MyClass {
    ↓internal func foo() {}
}
```

```
↓internal enum MyEnumTriggering: Int {}
```

```
enum MyEnumTriggering: String {
    ↓internal var counter { return 0 }
}
```

```
enum MyEnumTriggering {
    ↓internal func foo() {}
}
```

```
↓internal struct MyStruct {}
```

```
struct MyStruct { 
    ↓internal let counter = 0
}
```

```
struct MyStruct {
    ↓internal var counter { return 0 }
}
```

```
struct MyStruct {
    ↓internal func foo() {}
}
```

```
struct MyStruct {
    ↓internal class InternalClass() {}
}
```

```
↓internal var counter { return 0 }
```

```
↓internal func foo() {}
```

```
↓internal static let value = MyClass()
```

#### Corrections
```
↓internal protocol MyProtocol {}
->
protocol MyProtocol {}
```

```
enum MyEnumTriggering {
    ↓internal func foo() {}
}
->
enum MyEnumTriggering {
    func foo() {}
}
```

```
enum MyEnumTriggering: String {
    ↓internal var counter { return 0 }
}
->
enum MyEnumTriggering: String {
    var counter { return 0 }
}
```

```
↓internal static let value = MyClass()
->
static let value = MyClass()
```

```
↓internal enum MyEnumTriggering: Int {}
->
enum MyEnumTriggering: Int {}
```

```
↓internal struct MyStruct {}
->
struct MyStruct {}
```

```
final ↓internal class MyClass {}
->
final class MyClass {}
```

```
↓internal func foo() {}
->
func foo() {}
```

```
class MyClass {
    ↓internal var counter { return 0 }
}
->
class MyClass {
    var counter { return 0 }
}
```

```
class MyClass {
    ↓internal let counter = 0
}
->
class MyClass {
    let counter = 0
}
```

```
struct MyStruct {
    ↓internal func foo() {}
}
->
struct MyStruct {
    func foo() {}
}
```

```
struct MyStruct {
    ↓internal class InternalClass() {}
}
->
struct MyStruct {
    class InternalClass() {}
}
```

```
struct MyStruct { 
    ↓internal let counter = 0
}
->
struct MyStruct { 
    let counter = 0
}
```

```
struct MyStruct {
    ↓internal var counter { return 0 }
}
->
struct MyStruct {
    var counter { return 0 }
}
```

```
↓internal var counter { return 0 }
->
var counter { return 0 }
```

```
class MyClass {
    ↓internal func foo() {}
}
->
class MyClass {
    func foo() {}
}
```




### <a name="keyed_converter"/>41/89. Keyed converter rule rule
**Rule identifier**: `keyed_converter`

**Rule description**: `Do not use NSKeyerArchiver and NSKeyedUnarchiver, use KeyedConverter instead`

**Rule kind**: `Idiomatic`

#### Non triggering examples
```
KeyedConverter.archivedData(withRootObject: rootObject)
```

```
// KeyedArchiver.archivedData(withRootObject: rootObject)
```

```
/* KeyedArchiver.archivedData(withRootObject: rootObject) */
```

```
"KeyedArchiver.archivedData(withRootObject: rootObject)"
```

```
self.favoriteAds = [KeyedConverter unarchiveObjectWith:favoriteAdsData];
```

```
let logActions = KeyedConverter.unarchiveObject(with: data)
```

```
KeyedConverter.setClass(cls, forClassName: codedName)
```

```
// KeyedUnarchiver.setClass(cls, forClassName: codedName)
```

```
/* KeyedUnarchiver.setClass(cls, forClassName: codedName) */
```

```
"KeyedUnarchiver.setClass(cls, forClassName: codedName)"
```

```
self.favoriteAds = [KeyedConverter unarchiveObjectWith:favoriteAdsData];
```

```
let logActions = KeyedConverter.unarchiveObject(with: data)
```

```
let unarchivedData = KeyedConverter.unarchiveObject(with: data)
```

```
// let unarchivedData = KeyedUnarchiver.unarchiveObject(with: data)
```

```
/* let unarchivedData = KeyedUnarchiver.unarchiveObject(with: data) */
```

```
"let unarchivedData = KeyedUnarchiver.unarchiveObject(with: data)"
```

```
self.favoriteAds = [KeyedConverter unarchiveObjectWith:favoriteAdsData];
```

```
let logActions = KeyedConverter.unarchiveObject(with: data)
```

```
NSData *tokenData = [KeyedConverter archivedDataWithRootObject:token];
```

```
// NSData *tokenData = [NSKeyedArchiver archivedDataWithRootObject:token];
```

```
/* NSData *tokenData = [NSKeyedArchiver archivedDataWithRootObject:token]; */
```

```
"NSData *tokenData = [NSKeyedArchiver archivedDataWithRootObject:token];"
```

```
self.favoriteAds = [KeyedConverter unarchiveObjectWith:favoriteAdsData];
```

```
let logActions = KeyedConverter.unarchiveObject(with: data)
```

#### Triggering examples
```
↓KeyedArchiver.archivedData(withRootObject: rootObject)
```

```
↓KeyedUnarchiver.setClass(cls, forClassName: codedName)
```

```
let unarchivedData = ↓KeyedUnarchiver.unarchiveObject(with: data)
```

```
NSData *tokenData = [NS↓KeyedArchiver archivedDataWithRootObject:token];
```




### <a name="leading_whitespace"/>42/89. Leading Whitespace rule (autocorrectable)
**Rule identifier**: `leading_whitespace`

**Rule description**: `Files should not contain leading whitespace.`

**Rule kind**: `Style`

#### Non triggering examples
```
//
```

#### Triggering examples
```

```

```
 //
```

#### Corrections
```

 //
->
//
```




### <a name="legacy_cggeometry_functions"/>43/89. Legacy CGGeometry Functions rule (autocorrectable)
**Rule identifier**: `legacy_cggeometry_functions`

**Rule description**: `Struct extension properties and methods are preferred over legacy functions`

**Rule kind**: `Idiomatic`

#### Non triggering examples
```
rect.width
```

```
rect.height
```

```
rect.minX
```

```
rect.midX
```

```
rect.maxX
```

```
rect.minY
```

```
rect.midY
```

```
rect.maxY
```

```
rect.isNull
```

```
rect.isEmpty
```

```
rect.isInfinite
```

```
rect.standardized
```

```
rect.integral
```

```
rect.insetBy(dx: 5.0, dy: -7.0)
```

```
rect.offsetBy(dx: 5.0, dy: -7.0)
```

```
rect1.union(rect2)
```

```
rect1.intersect(rect2)
```

```
rect1.contains(rect2)
```

```
rect.contains(point)
```

```
rect1.intersects(rect2)
```

#### Triggering examples
```
↓CGRectGetWidth(rect)
```

```
↓CGRectGetHeight(rect)
```

```
↓CGRectGetMinX(rect)
```

```
↓CGRectGetMidX(rect)
```

```
↓CGRectGetMaxX(rect)
```

```
↓CGRectGetMinY(rect)
```

```
↓CGRectGetMidY(rect)
```

```
↓CGRectGetMaxY(rect)
```

```
↓CGRectIsNull(rect)
```

```
↓CGRectIsEmpty(rect)
```

```
↓CGRectIsInfinite(rect)
```

```
↓CGRectStandardize(rect)
```

```
↓CGRectIntegral(rect)
```

```
↓CGRectInset(rect, 10, 5)
```

```
↓CGRectOffset(rect, -2, 8.3)
```

```
↓CGRectUnion(rect1, rect2)
```

```
↓CGRectIntersection(rect1, rect2)
```

```
↓CGRectContainsRect(rect1, rect2)
```

```
↓CGRectContainsPoint(rect, point)
```

```
↓CGRectIntersectsRect(rect1, rect2)
```

#### Corrections
```
↓CGRectGetMaxX( rect)
->
rect.maxX
```

```
↓CGRectGetMaxY( rect     )
->
rect.maxY
```

```
↓CGRectIsNull(  rect    )
->
rect.isNull
```

```
↓CGRectIntegral(rect )
->
rect.integral
```

```
↓CGRectOffset(rect, -2, 8.3)
->
rect.offsetBy(dx: -2, dy: 8.3)
```

```
↓CGRectInset(rect, 5.0, -7.0)
->
rect.insetBy(dx: 5.0, dy: -7.0)
```

```
↓CGRectContainsPoint(rect  ,point)
->
rect.contains(point)
```

```
↓CGRectContainsRect( rect1,rect2     )
->
rect1.contains(rect2)
```

```
↓CGRectUnion(rect1, rect2)
->
rect1.union(rect2)
```

```
↓CGRectGetMidX(  rect)
->
rect.midX
```

```
↓CGRectIntersectsRect(rect1, rect2 )
↓CGRectGetWidth(rect  )
->
rect1.intersects(rect2)
rect.width
```

```
↓CGRectGetHeight(rect )
->
rect.height
```

```
↓CGRectIntersectsRect(  rect1,rect2 )
->
rect1.intersects(rect2)
```

```
↓CGRectStandardize( rect)
->
rect.standardized
```

```
↓CGRectIsEmpty( rect )
->
rect.isEmpty
```

```
↓CGRectGetMidY(rect )
->
rect.midY
```

```
↓CGRectIsInfinite( rect )
->
rect.isInfinite
```

```
↓CGRectIntersection( rect1 ,rect2)
->
rect1.intersect(rect2)
```

```
↓CGRectGetWidth( rect  )
->
rect.width
```

```
↓CGRectGetMinX( rect)
->
rect.minX
```

```
↓CGRectGetMinY(rect   )
->
rect.minY
```




### <a name="legacy_constant"/>44/89. Legacy Constant rule (autocorrectable)
**Rule identifier**: `legacy_constant`

**Rule description**: `Struct-scoped constants are preferred over legacy global constants.`

**Rule kind**: `Idiomatic`

#### Non triggering examples
```
CGRect.infinite
```

```
CGPoint.zero
```

```
CGRect.zero
```

```
CGSize.zero
```

```
NSPoint.zero
```

```
NSRect.zero
```

```
NSSize.zero
```

```
CGRect.null
```

```
CGFloat.pi
```

```
Float.pi
```

#### Triggering examples
```
↓CGRectInfinite
```

```
↓CGPointZero
```

```
↓CGRectZero
```

```
↓CGSizeZero
```

```
↓NSZeroPoint
```

```
↓NSZeroRect
```

```
↓NSZeroSize
```

```
↓CGRectNull
```

```
↓CGFloat(M_PI)
```

```
↓Float(M_PI)
```

#### Corrections
```
↓NSZeroSize
->
NSSize.zero
```

```
↓CGRectInfinite
->
CGRect.infinite
```

```
↓Float(M_PI)
->
Float.pi
```

```
↓CGRectInfinite
↓CGRectNull
->
CGRect.infinite
CGRect.null
```

```
↓CGSizeZero
->
CGSize.zero
```

```
↓CGFloat(M_PI)
↓Float(M_PI)
->
CGFloat.pi
Float.pi
```

```
↓CGRectZero
->
CGRect.zero
```

```
↓NSZeroPoint
->
NSPoint.zero
```

```
↓CGPointZero
->
CGPoint.zero
```

```
↓CGFloat(M_PI)
->
CGFloat.pi
```

```
↓NSZeroRect
->
NSRect.zero
```

```
↓CGRectNull
->
CGRect.null
```




### <a name="legacy_constructor"/>45/89. Legacy Constructor rule (autocorrectable)
**Rule identifier**: `legacy_constructor`

**Rule description**: `Swift constructors are preferred over legacy convenience functions.`

**Rule kind**: `Idiomatic`

#### Non triggering examples
```
CGPoint(x: 10, y: 10)
```

```
CGPoint(x: xValue, y: yValue)
```

```
CGSize(width: 10, height: 10)
```

```
CGSize(width: aWidth, height: aHeight)
```

```
CGRect(x: 0, y: 0, width: 10, height: 10)
```

```
CGRect(x: xVal, y: yVal, width: aWidth, height: aHeight)
```

```
CGVector(dx: 10, dy: 10)
```

```
CGVector(dx: deltaX, dy: deltaY)
```

```
NSPoint(x: 10, y: 10)
```

```
NSPoint(x: xValue, y: yValue)
```

```
NSSize(width: 10, height: 10)
```

```
NSSize(width: aWidth, height: aHeight)
```

```
NSRect(x: 0, y: 0, width: 10, height: 10)
```

```
NSRect(x: xVal, y: yVal, width: aWidth, height: aHeight)
```

```
NSRange(location: 10, length: 1)
```

```
NSRange(location: loc, length: len)
```

```
UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 10)
```

```
UIEdgeInsets(top: aTop, left: aLeft, bottom: aBottom, right: aRight)
```

```
NSEdgeInsets(top: 0, left: 0, bottom: 10, right: 10)
```

```
NSEdgeInsets(top: aTop, left: aLeft, bottom: aBottom, right: aRight)
```

```
UIOffset(horizontal: 0, vertical: 10)
```

```
UIOffset(horizontal: horizontal, vertical: vertical)
```

#### Triggering examples
```
↓CGPointMake(10, 10)
```

```
↓CGPointMake(xVal, yVal)
```

```
↓CGPointMake(calculateX(), 10)
```

```
↓CGSizeMake(10, 10)
```

```
↓CGSizeMake(aWidth, aHeight)
```

```
↓CGRectMake(0, 0, 10, 10)
```

```
↓CGRectMake(xVal, yVal, width, height)
```

```
↓CGVectorMake(10, 10)
```

```
↓CGVectorMake(deltaX, deltaY)
```

```
↓NSMakePoint(10, 10)
```

```
↓NSMakePoint(xVal, yVal)
```

```
↓NSMakeSize(10, 10)
```

```
↓NSMakeSize(aWidth, aHeight)
```

```
↓NSMakeRect(0, 0, 10, 10)
```

```
↓NSMakeRect(xVal, yVal, width, height)
```

```
↓NSMakeRange(10, 1)
```

```
↓NSMakeRange(loc, len)
```

```
↓UIEdgeInsetsMake(0, 0, 10, 10)
```

```
↓UIEdgeInsetsMake(top, left, bottom, right)
```

```
↓NSEdgeInsetsMake(0, 0, 10, 10)
```

```
↓NSEdgeInsetsMake(top, left, bottom, right)
```

```
↓CGVectorMake(10, 10)
↓NSMakeRange(10, 1)
```

```
↓UIOffsetMake(0, 10)
```

```
↓UIOffsetMake(horizontal, vertical)
```

#### Corrections
```
↓NSMakeRange(10, 1)
->
NSRange(location: 10, length: 1)
```

```
↓UIOffsetMake(0, 10)
->
UIOffset(horizontal: 0, vertical: 10)
```

```
↓NSMakeSize(10, 10)
->
NSSize(width: 10, height: 10)
```

```
↓CGVectorMake(deltaX, deltaY)
->
CGVector(dx: deltaX, dy: deltaY)
```

```
↓CGPointMake(10,  10   )
->
CGPoint(x: 10, y: 10)
```

```
↓NSMakePoint(10,  10   )
->
NSPoint(x: 10, y: 10)
```

```
↓UIEdgeInsetsMake(top, left, bottom, right)
->
UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
```

```
↓NSMakePoint(xPos,  yPos   )
->
NSPoint(x: xPos, y: yPos)
```

```
↓CGPointMake(xPos,  yPos   )
->
CGPoint(x: xPos, y: yPos)
```

```
↓CGVectorMake(dx, dy)
↓NSMakeRange(loc, len)
->
CGVector(dx: dx, dy: dy)
NSRange(location: loc, length: len)
```

```
↓CGVectorMake(10, 10)
↓NSMakeRange(10, 1)
->
CGVector(dx: 10, dy: 10)
NSRange(location: 10, length: 1)
```

```
↓NSEdgeInsetsMake(top, left, bottom, right)
->
NSEdgeInsets(top: top, left: left, bottom: bottom, right: right)
```

```
↓NSMakeRect(0, 0, 10, 10)
->
NSRect(x: 0, y: 0, width: 10, height: 10)
```

```
↓CGSizeMake(10, 10)
->
CGSize(width: 10, height: 10)
```

```
↓NSEdgeInsetsMake(0, 0, 10, 10)
->
NSEdgeInsets(top: 0, left: 0, bottom: 10, right: 10)
```

```
↓CGVectorMake(10, 10)
->
CGVector(dx: 10, dy: 10)
```

```
↓CGPointMake(calculateX(), 10)
->
CGPoint(x: calculateX(), y: 10)
```

```
↓CGRectMake(0, 0, 10, 10)
->
CGRect(x: 0, y: 0, width: 10, height: 10)
```

```
↓NSMakeSize( aWidth, aHeight )
->
NSSize(width: aWidth, height: aHeight)
```

```
↓NSMakeRect(xPos, yPos , width, height)
->
NSRect(x: xPos, y: yPos, width: width, height: height)
```

```
↓NSMakeRange(loc, len)
->
NSRange(location: loc, length: len)
```

```
↓UIEdgeInsetsMake(0, 0, 10, 10)
->
UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 10)
```

```
↓NSMakeRange(0, attributedString.length)
->
NSRange(location: 0, length: attributedString.length)
```

```
↓UIOffsetMake(horizontal, vertical)
->
UIOffset(horizontal: horizontal, vertical: vertical)
```

```
↓CGRectMake(xPos, yPos , width, height)
->
CGRect(x: xPos, y: yPos, width: width, height: height)
```

```
↓CGSizeMake( aWidth, aHeight )
->
CGSize(width: aWidth, height: aHeight)
```




### <a name="line_length"/>46/89. Line Length rule
**Rule identifier**: `line_length`

**Rule description**: `Lines should not span too many characters.`

**Rule kind**: `Metrics`

#### Non triggering examples
```
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
```

```
#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
```

```
#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")
```

#### Triggering examples
```
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
```

```
#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
```

```
#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")#imageLiteral(resourceName: "image.jpg")
```




### <a name="lower_acl_than_parent"/>47/89. Lower ACL than parent rule
**Rule identifier**: `lower_acl_than_parent`

**Rule description**: `Ensure definitions have a lower access control level than their enclosing parent`

**Rule kind**: `Lint`

#### Non triggering examples
```
public struct Foo { public func bar() {} }
```

```
internal struct Foo { func bar() {} }
```

```
struct Foo { func bar() {} }
```

```
open class Foo { public func bar() {} }
```

```
open class Foo { open func bar() {} }
```

```
fileprivate struct Foo { private func bar() {} }
```

```
private struct Foo { private func bar(id: String) }
```

```
extension Foo { public func bar() {} }
```

```
private struct Foo { fileprivate func bar() {} }
```

```
private func foo(id: String) {}
```

#### Triggering examples
```
struct Foo { public func bar() {} }
```

```
enum Foo { public func bar() {} }
```

```
public class Foo { open func bar() }
```

```
class Foo { public private(set) var bar: String? }
```




### <a name="mark"/>48/89. Mark rule (autocorrectable)
**Rule identifier**: `mark`

**Rule description**: `MARK comment should be in valid format. e.g. '// MARK: ...' or '// MARK: - ...'`

**Rule kind**: `Lint`

#### Non triggering examples
```
// MARK: good
```

```
// MARK: - good
```

```
// MARK: -
```

```
// BOOKMARK
```

```
//BOOKMARK
```

```
// BOOKMARKS
```

#### Triggering examples
```
↓//MARK: bad
```

```
↓// MARK:bad
```

```
↓//MARK:bad
```

```
↓//  MARK: bad
```

```
↓// MARK:  bad
```

```
↓// MARK: -bad
```

```
↓// MARK:- bad
```

```
↓// MARK:-bad
```

```
↓//MARK: - bad
```

```
↓//MARK:- bad
```

```
↓//MARK: -bad
```

```
↓//MARK:-bad
```

```
↓//Mark: bad
```

```
↓// Mark: bad
```

```
↓// MARK bad
```

```
↓//MARK bad
```

```
↓// MARK - bad
```

```
↓//MARK : bad
```

```
↓// MARKL:
```

```
↓// MARKR 
```

```
↓// MARKK -
```

```
↓//MARK:- Top-Level bad mark
↓//MARK:- Another bad mark
struct MarkTest {}
↓// MARK:- Bad mark
extension MarkTest {}
```

#### Corrections
```
↓// MARK:comment
->
// MARK: comment
```

```
↓// Mark: - comment
->
// MARK: - comment
```

```
↓// MARKK -
->
// MARK: -
```

```
↓// MARK: -comment
->
// MARK: - comment
```

```
↓// MARK - comment
->
// MARK: - comment
```

```
↓// MARKL: -
->
// MARK: -
```

```
↓//MARK:- Top-Level bad mark
↓//MARK:- Another bad mark
struct MarkTest {}
↓// MARK:- Bad mark
extension MarkTest {}
->
// MARK: - Top-Level bad mark
// MARK: - Another bad mark
struct MarkTest {}
// MARK: - Bad mark
extension MarkTest {}
```

```
↓// MARKL:
->
// MARK:
```

```
↓// MARKK 
->
// MARK: 
```

```
↓// MARK: -  comment
->
// MARK: - comment
```

```
↓//MARK: - comment
->
// MARK: - comment
```

```
↓//  MARK: comment
->
// MARK: comment
```

```
↓//MARK: comment
->
// MARK: comment
```

```
↓// MARK:- comment
->
// MARK: - comment
```

```
↓// Mark: comment
->
// MARK: comment
```

```
↓// MARK : comment
->
// MARK: comment
```

```
↓// MARK:  comment
->
// MARK: comment
```




### <a name="missing_spaces_after_colon"/>49/89. Missing spaces after colon rule (autocorrectable)
**Rule identifier**: `missing_spaces_after_colon`

**Rule description**: `There must be at least 1 space after colon`

**Rule kind**: `Style`

#### Non triggering examples
```
static let bool: Bool
```

```
// static let bool:Bool
```

```
/* static let bool:Bool */
```

```
"static let bool:Bool"
```

```
private let dictionary: [String: Bool]
```

```
// private let dictionary: [String:Bool]
```

```
/* private let dictionary: [String:Bool] */
```

```
"private let dictionary: [String:Bool]"
```

```
static var bool: Bool
```

```
// static var bool:Bool
```

```
/* static var bool:Bool */
```

```
"static var bool:Bool"
```

```
private var dictionary: [String: Bool]
```

```
// private var dictionary: [String:Bool]
```

```
/* private var dictionary: [String:Bool] */
```

```
"private var dictionary: [String:Bool]"
```

```
let onFoo: ((_ bool: Bool) -> ())
```

```
// let onFoo:((_ bool: Bool) -> ())
```

```
/* let onFoo:((_ bool: Bool) -> ()) */
```

```
"let onFoo:((_ bool: Bool) -> ())"
```

```
let onFoo: ((_ dictionary: [String: Bool]) -> ())
```

```
// let onFoo: ((_ dictionary: [String:Bool]) -> ())
```

```
/* let onFoo: ((_ dictionary: [String:Bool]) -> ()) */
```

```
"let onFoo: ((_ dictionary: [String:Bool]) -> ())"
```

```
var onFoo: ((_ bool: Bool) -> ())
```

```
// var onFoo:((_ bool: Bool) -> ())
```

```
/* var onFoo:((_ bool: Bool) -> ()) */
```

```
"var onFoo:((_ bool: Bool) -> ())"
```

```
var onFoo: ((_ dictionary: [String: Bool]) -> ())
```

```
// var onFoo: ((_ dictionary: [String:Bool]) -> ())
```

```
/* var onFoo: ((_ dictionary: [String:Bool]) -> ()) */
```

```
"var onFoo: ((_ dictionary: [String:Bool]) -> ())"
```

```
func foo(bool: Bool) {}
```

```
// func foo(bool:Bool) {}
```

```
/* func foo(bool:Bool) {} */
```

```
"func foo(bool:Bool) {}"
```

```
func foo(_ bool: Bool, int: Int) {}
```

```
// func foo(_ bool: Bool, int:Int) {}
```

```
/* func foo(_ bool: Bool, int:Int) {} */
```

```
"func foo(_ bool: Bool, int:Int) {}"
```

```
func foo(completion: ((_ dictionary: [String: Bool]) -> ())) {}
```

```
// func foo(completion: ((_ dictionary: [String:Bool]) -> ())) {}
```

```
/* func foo(completion: ((_ dictionary: [String:Bool]) -> ())) {} */
```

```
"func foo(completion: ((_ dictionary: [String:Bool]) -> ())) {}"
```

```
switch value { case 1: return; case 2...4: return; default: return }
```

```
// switch value { case 1:return; case 2...4: return; default: return }
```

```
/* switch value { case 1:return; case 2...4: return; default: return } */
```

```
"switch value { case 1:return; case 2...4: return; default: return }"
```

```
switch value { case 1: return; case 2...4: return; default: return }
```

```
// switch value { case 1: return; case 2...4:return; default: return }
```

```
/* switch value { case 1: return; case 2...4:return; default: return } */
```

```
"switch value { case 1: return; case 2...4:return; default: return }"
```

```
switch value { case 1: return; case 2...4: return; default: return }
```

```
// switch value { case 1: return; case 2...4: return; default:return }
```

```
/* switch value { case 1: return; case 2...4: return; default:return } */
```

```
"switch value { case 1: return; case 2...4: return; default:return }"
```

```
let size = CGSize(width: 1, height: 2)
```

```
// let size = CGSize(width:1, height: 2)
```

```
/* let size = CGSize(width:1, height: 2) */
```

```
"let size = CGSize(width:1, height: 2)"
```

```
let size = CGSize(width: 1, height: 2)
```

```
// let size = CGSize(width: 1, height:2)
```

```
/* let size = CGSize(width: 1, height:2) */
```

```
"let size = CGSize(width: 1, height:2)"
```

```
let filtered = array.filter { (item: Any?) in return item }
```

```
// let filtered = array.filter { (item:Any?) in return item }
```

```
/* let filtered = array.filter { (item:Any?) in return item } */
```

```
"let filtered = array.filter { (item:Any?) in return item }"
```

```
let filtered = array.enumetated.filter { ((offset: Int, element: String)) -> Bool in true }
```

```
// let filtered = array.enumetated.filter { ((offset:Int, element: String)) -> Bool in true }
```

```
/* let filtered = array.enumetated.filter { ((offset:Int, element: String)) -> Bool in true } */
```

```
"let filtered = array.enumetated.filter { ((offset:Int, element: String)) -> Bool in true }"
```

```
let filtered = array.enumetated.filter { ((offset: Int, element: String)) -> Bool in true }
```

```
// let filtered = array.enumetated.filter { ((offset: Int, element:String)) -> Bool in true }
```

```
/* let filtered = array.enumetated.filter { ((offset: Int, element:String)) -> Bool in true } */
```

```
"let filtered = array.enumetated.filter { ((offset: Int, element:String)) -> Bool in true }"
```

```
return true ? 1 : 0
```

```
// return true ? 1 :0
```

```
/* return true ? 1 :0 */
```

```
"return true ? 1 :0"
```

```
let params: [String: Any] = [:]
```

```
button.addTarget(self, action: #selector(onTap(_:)))
```

```
NSObject.perform(#selector(gogogo(x:y:)), with: 1, with: 2)
```

```
public let EditMenuCopySelector = #selector(UIResponderStandardEditActions.copy(_:))
```

```
@objc(showModuleWithParam:completion:)
func showModule(param: Int, completion: (() -> ())) {}
```

#### Triggering examples
```
static let bool↓:Bool
```

```
private let dictionary: [String↓:Bool]
```

```
static var bool↓:Bool
```

```
private var dictionary: [String↓:Bool]
```

```
let onFoo↓:((_ bool: Bool) -> ())
```

```
let onFoo: ((_ dictionary: [String↓:Bool]) -> ())
```

```
var onFoo↓:((_ bool: Bool) -> ())
```

```
var onFoo: ((_ dictionary: [String↓:Bool]) -> ())
```

```
func foo(bool↓:Bool) {}
```

```
func foo(_ bool: Bool, int↓:Int) {}
```

```
func foo(completion: ((_ dictionary: [String↓:Bool]) -> ())) {}
```

```
switch value { case 1↓:return; case 2...4: return; default: return }
```

```
switch value { case 1: return; case 2...4↓:return; default: return }
```

```
switch value { case 1: return; case 2...4: return; default↓:return }
```

```
let size = CGSize(width↓:1, height: 2)
```

```
let size = CGSize(width: 1, height↓:2)
```

```
let filtered = array.filter { (item↓:Any?) in return item }
```

```
let filtered = array.enumetated.filter { ((offset↓:Int, element: String)) -> Bool in true }
```

```
let filtered = array.enumetated.filter { ((offset: Int, element↓:String)) -> Bool in true }
```

```
return true ? 1 ↓:0
```

#### Corrections
```
let size = CGSize(width: 1, height↓:2)
->
let size = CGSize(width: 1, height: 2)
```

```
var onFoo: ((_ dictionary: [String↓:Bool]) -> ())
->
var onFoo: ((_ dictionary: [String: Bool]) -> ())
```

```
static var bool↓:Bool
->
static var bool: Bool
```

```
func foo(_ bool: Bool, int↓:Int) {}
->
func foo(_ bool: Bool, int: Int) {}
```

```
private let dictionary: [String↓:Bool]
->
private let dictionary: [String: Bool]
```

```
private var dictionary: [String↓:Bool]
->
private var dictionary: [String: Bool]
```

```
func foo(bool↓:Bool) {}
->
func foo(bool: Bool) {}
```

```
let filtered = array.enumetated.filter { ((offset: Int, element↓:String)) -> Bool in true }
->
let filtered = array.enumetated.filter { ((offset: Int, element: String)) -> Bool in true }
```

```
let onFoo↓:((_ bool: Bool) -> ())
->
let onFoo: ((_ bool: Bool) -> ())
```

```
return true ? 1 ↓:0
->
return true ? 1 : 0
```

```
switch value { case 1↓:return; case 2...4: return; default: return }
->
switch value { case 1: return; case 2...4: return; default: return }
```

```
func foo(completion: ((_ dictionary: [String↓:Bool]) -> ())) {}
->
func foo(completion: ((_ dictionary: [String: Bool]) -> ())) {}
```

```
let onFoo: ((_ dictionary: [String↓:Bool]) -> ())
->
let onFoo: ((_ dictionary: [String: Bool]) -> ())
```

```
switch value { case 1: return; case 2...4: return; default↓:return }
->
switch value { case 1: return; case 2...4: return; default: return }
```

```
let filtered = array.filter { (item↓:Any?) in return item }
->
let filtered = array.filter { (item: Any?) in return item }
```

```
let size = CGSize(width↓:1, height: 2)
->
let size = CGSize(width: 1, height: 2)
```

```
var onFoo↓:((_ bool: Bool) -> ())
->
var onFoo: ((_ bool: Bool) -> ())
```

```
switch value { case 1: return; case 2...4↓:return; default: return }
->
switch value { case 1: return; case 2...4: return; default: return }
```

```
let filtered = array.enumetated.filter { ((offset↓:Int, element: String)) -> Bool in true }
->
let filtered = array.enumetated.filter { ((offset: Int, element: String)) -> Bool in true }
```

```
static let bool↓:Bool
->
static let bool: Bool
```




### <a name="modifier_order"/>50/89. Modifier Order rule
**Rule identifier**: `modifier_order`

**Rule description**: `Modifier order should be consistent.`

**Rule kind**: `Style`

#### Non triggering examples
```
public class Foo { 
   public convenience required init() {} 
}
```

```
public class Foo { 
   public static let bar = 42 
}
```

```
public class Foo { 
   public static var bar: Int { 
       return 42   }}
```

```
public class Foo { 
   public class var bar: Int { 
       return 42 
   } 
}
```

```
public class Bar { 
   public class var foo: String { 
       return "foo" 
   } 
} 
public class Foo: Bar { 
   override public final class var foo: String { 
       return "bar" 
   } 
}
```

```
open class Bar { 
   public var foo: Int? { 
       return 42 
   } 
} 
open class Foo: Bar { 
   override public var foo: Int? { 
       return 43 
   } 
}
```

```
open class Bar { 
   open class func foo() -> Int { 
       return 42 
   } 
} 
class Foo: Bar { 
   override open class func foo() -> Int { 
       return 43 
   } 
}
```

```
protocol Foo: class {} 
class Bar { 
    public private(set) weak var foo: Foo? 
} 
```

```
@objc 
public final class Foo: NSObject {} 
```

```
@objcMembers 
public final class Foo: NSObject {} 
```

```
@objc 
override public private(set) weak var foo: Bar? 
```

```
@objc 
public final class Foo: NSObject {} 
```

```
@objc 
open final class Foo: NSObject { 
   open weak var weakBar: NSString? = nil 
}
```

```
public final class Foo {}
```

```
class Bar { 
   func bar() {} 
}
```

```
internal class Foo: Bar { 
   override internal func bar() {} 
}
```

```
public struct Foo { 
   internal weak var weakBar: NSObject? = nil 
}
```

```
class Foo { 
   internal lazy var bar: String = "foo" 
}
```

#### Triggering examples
```
class Foo { 
   convenience required public init() {} 
}
```

```
public class Foo { 
   static public let bar = 42 
}
```

```
public class Foo { 
   static public var bar: Int { 
       return 42 
   } 
} 
```

```
public class Foo { 
   class public var bar: Int { 
       return 42 
   } 
}
```

```
public class RootFoo { 
   class public var foo: String { 
       return "foo" 
   } 
} 
public class Foo: RootFoo { 
   override final class public var foo: String { 
       return "bar" 
   } 
}
```

```
open class Bar { 
   public var foo: Int? { 
       return 42 
   } 
} 
open class Foo: Bar { 
    public override var foo: Int? { 
       return 43 
   } 
}
```

```
protocol Foo: class {} 
class Bar { 
    private(set) public weak var foo: Foo? 
} 
```

```
open class Bar { 
   open class func foo() -> Int { 
       return 42 
   } 
} 
class Foo: Bar { 
   class open override func foo() -> Int { 
       return 43 
   } 
}
```

```
open class Bar { 
   open class func foo() -> Int { 
       return 42 
   } 
} 
class Foo: Bar { 
   open override class func foo() -> Int { 
       return 43 
   } 
}
```

```
@objc 
final public class Foo: NSObject {}
```

```
@objcMembers 
final public class Foo: NSObject {}
```

```
@objc 
final open class Foo: NSObject { 
   weak open var weakBar: NSString? = nil 
}
```

```
final public class Foo {} 
```

```
internal class Foo: Bar { 
   internal override func bar() {} 
}
```

```
public struct Foo { 
   weak internal var weakBar: NSObjetc? = nil 
}
```

```
class Foo { 
   lazy internal var bar: String = "foo" 
}
```




### <a name="multiline_arguments"/>51/89. Multiline Arguments rule
**Rule identifier**: `multiline_arguments`

**Rule description**: `Arguments should be either on the same line, or one per line.`

**Rule kind**: `Style`

#### Non triggering examples
```
foo()
```

```
foo(
    
)
```

```
foo { }
```

```
foo {
    
}
```

```
foo(0)
```

```
foo(0, 1)
```

```
foo(0, 1) { }
```

```
foo(0, param1: 1)
```

```
foo(0, param1: 1) { }
```

```
foo(param1: 1)
```

```
foo(param1: 1) { }
```

```
foo(param1: 1, param2: true) { }
```

```
foo(param1: 1, param2: true, param3: [3]) { }
```

```
foo(param1: 1, param2: true, param3: [3]) {
    bar()
}
```

```
foo(param1: 1,
    param2: true,
    param3: [3])
```

```
foo(
    param1: 1, param2: true, param3: [3]
)
```

```
foo(
    param1: 1,
    param2: true,
    param3: [3]
)
```

#### Triggering examples
```
foo(0,
    param1: 1, ↓param2: true, ↓param3: [3])
```

```
foo(0, ↓param1: 1,
    param2: true, ↓param3: [3])
```

```
foo(0, ↓param1: 1, ↓param2: true,
    param3: [3])
```

```
foo(
    0, ↓param1: 1,
    param2: true, ↓param3: [3]
)
```




### <a name="multiline_parameters"/>52/89. Multiline Parameters rule
**Rule identifier**: `multiline_parameters`

**Rule description**: `Functions and methods parameters should be either on the same line, or one per line.`

**Rule kind**: `Style`

#### Non triggering examples
```
func foo() { }
```

```
func foo(param1: Int) { }
```

```
func foo(param1: Int, param2: Bool) { }
```

```
func foo(param1: Int, param2: Bool, param3: [String]) { }
```

```
func foo(param1: Int,
         param2: Bool,
         param3: [String]) { }
```

```
func foo(_ param1: Int, param2: Int, param3: Int) -> (Int) -> Int {
   return { x in x + param1 + param2 + param3 }
}
```

```
static func foo() { }
```

```
static func foo(param1: Int) { }
```

```
static func foo(param1: Int, param2: Bool) { }
```

```
static func foo(param1: Int, param2: Bool, param3: [String]) { }
```

```
static func foo(param1: Int,
                param2: Bool,
                param3: [String]) { }
```

```
protocol Foo {
	func foo() { }
}
```

```
protocol Foo {
	func foo(param1: Int) { }
}
```

```
protocol Foo {
	func foo(param1: Int, param2: Bool) { }
}
```

```
protocol Foo {
	func foo(param1: Int, param2: Bool, param3: [String]) { }
}
```

```
protocol Foo {
   func foo(param1: Int,
            param2: Bool,
            param3: [String]) { }
}
```

```
protocol Foo {
	static func foo(param1: Int, param2: Bool, param3: [String]) { }
}
```

```
protocol Foo {
   static func foo(param1: Int,
                   param2: Bool,
                   param3: [String]) { }
}
```

```
protocol Foo {
	class func foo(param1: Int, param2: Bool, param3: [String]) { }
}
```

```
protocol Foo {
   class func foo(param1: Int,
                  param2: Bool,
                  param3: [String]) { }
}
```

```
enum Foo {
	func foo() { }
}
```

```
enum Foo {
	func foo(param1: Int) { }
}
```

```
enum Foo {
	func foo(param1: Int, param2: Bool) { }
}
```

```
enum Foo {
	func foo(param1: Int, param2: Bool, param3: [String]) { }
}
```

```
enum Foo {
   func foo(param1: Int,
            param2: Bool,
            param3: [String]) { }
}
```

```
enum Foo {
	static func foo(param1: Int, param2: Bool, param3: [String]) { }
}
```

```
enum Foo {
   static func foo(param1: Int,
                   param2: Bool,
                   param3: [String]) { }
}
```

```
struct Foo {
	func foo() { }
}
```

```
struct Foo {
	func foo(param1: Int) { }
}
```

```
struct Foo {
	func foo(param1: Int, param2: Bool) { }
}
```

```
struct Foo {
	func foo(param1: Int, param2: Bool, param3: [String]) { }
}
```

```
struct Foo {
   func foo(param1: Int,
            param2: Bool,
            param3: [String]) { }
}
```

```
struct Foo {
	static func foo(param1: Int, param2: Bool, param3: [String]) { }
}
```

```
struct Foo {
   static func foo(param1: Int,
                   param2: Bool,
                   param3: [String]) { }
}
```

```
class Foo {
	func foo() { }
}
```

```
class Foo {
	func foo(param1: Int) { }
}
```

```
class Foo {
	func foo(param1: Int, param2: Bool) { }
}
```

```
class Foo {
	func foo(param1: Int, param2: Bool, param3: [String]) { }
	}
```

```
class Foo {
   func foo(param1: Int,
            param2: Bool,
            param3: [String]) { }
}
```

```
class Foo {
	class func foo(param1: Int, param2: Bool, param3: [String]) { }
}
```

```
class Foo {
   class func foo(param1: Int,
                  param2: Bool,
                  param3: [String]) { }
}
```

```
class Foo {
   class func foo(param1: Int,
                  param2: Bool,
                  param3: @escaping (Int, Int) -> Void = { _, _ in }) { }
}
```

```
class Foo {
   class func foo(param1: Int,
                  param2: Bool,
                  param3: @escaping (Int) -> Void = { _ in }) { }
}
```

```
class Foo {
   class func foo(param1: Int,
                  param2: Bool,
                  param3: @escaping ((Int) -> Void)? = nil) { }
}
```

```
class Foo {
   class func foo(param1: Int,
                  param2: Bool,
                  param3: @escaping ((Int) -> Void)? = { _ in }) { }
}
```

```
class Foo {
   class func foo(param1: Int,
                  param2: @escaping ((Int) -> Void)? = { _ in },
                  param3: Bool) { }
}
```

```
class Foo {
   class func foo(param1: Int,
                  param2: @escaping ((Int) -> Void)? = { _ in },
                  param3: @escaping (Int, Int) -> Void = { _, _ in }) { }
}
```

```
class Foo {
   class func foo(param1: Int,
                  param2: Bool,
                  param3: @escaping (Int) -> Void = { (x: Int) in }) { }
}
```

```
class Foo {
   class func foo(param1: Int,
                  param2: Bool,
                  param3: @escaping (Int, (Int) -> Void) -> Void = { (x: Int, f: (Int) -> Void) in }) { }
}
```

#### Triggering examples
```
func ↓foo(_ param1: Int,
          param2: Int, param3: Int) -> (Int) -> Int {
   return { x in x + param1 + param2 + param3 }
}
```

```
protocol Foo {
   func ↓foo(param1: Int,
             param2: Bool, param3: [String]) { }
}
```

```
protocol Foo {
   func ↓foo(param1: Int, param2: Bool,
             param3: [String]) { }
}
```

```
protocol Foo {
   static func ↓foo(param1: Int,
                    param2: Bool, param3: [String]) { }
}
```

```
protocol Foo {
   static func ↓foo(param1: Int, param2: Bool,
                    param3: [String]) { }
}
```

```
protocol Foo {
   class func ↓foo(param1: Int,
                   param2: Bool, param3: [String]) { }
}
```

```
protocol Foo {
   class func ↓foo(param1: Int, param2: Bool,
                   param3: [String]) { }
}
```

```
enum Foo {
   func ↓foo(param1: Int,
             param2: Bool, param3: [String]) { }
}
```

```
enum Foo {
   func ↓foo(param1: Int, param2: Bool,
             param3: [String]) { }
}
```

```
enum Foo {
   static func ↓foo(param1: Int,
                    param2: Bool, param3: [String]) { }
}
```

```
enum Foo {
   static func ↓foo(param1: Int, param2: Bool,
                    param3: [String]) { }
}
```

```
struct Foo {
   func ↓foo(param1: Int,
             param2: Bool, param3: [String]) { }
}
```

```
struct Foo {
   func ↓foo(param1: Int, param2: Bool,
             param3: [String]) { }
}
```

```
struct Foo {
   static func ↓foo(param1: Int,
                    param2: Bool, param3: [String]) { }
}
```

```
struct Foo {
   static func ↓foo(param1: Int, param2: Bool,
                    param3: [String]) { }
}
```

```
class Foo {
   func ↓foo(param1: Int,
             param2: Bool, param3: [String]) { }
}
```

```
class Foo {
   func ↓foo(param1: Int, param2: Bool,
             param3: [String]) { }
}
```

```
class Foo {
   class func ↓foo(param1: Int,
                   param2: Bool, param3: [String]) { }
}
```

```
class Foo {
   class func ↓foo(param1: Int, param2: Bool,
                   param3: [String]) { }
}
```

```
class Foo {
   class func ↓foo(param1: Int,
                  param2: Bool, param3: @escaping (Int, Int) -> Void = { _, _ in }) { }
}
```

```
class Foo {
   class func ↓foo(param1: Int,
                  param2: Bool, param3: @escaping (Int) -> Void = { (x: Int) in }) { }
}
```




### <a name="multiple_closures_with_trailing_closure"/>53/89. Multiple Closures with Trailing Closure rule
**Rule identifier**: `multiple_closures_with_trailing_closure`

**Rule description**: `Trailing closure syntax should not be used when passing more than one closure argument.`

**Rule kind**: `Style`

#### Non triggering examples
```
foo.map { $0 + 1 }
```

```
foo.reduce(0) { $0 + $1 }
```

```
if let foo = bar.map({ $0 + 1 }) {

}
```

```
foo.something(param1: { $0 }, param2: { $0 + 1 })
```

```
UIView.animate(withDuration: 1.0) {
    someView.alpha = 0.0
}
```

#### Triggering examples
```
foo.something(param1: { $0 }) ↓{ $0 + 1 }
```

```
UIView.animate(withDuration: 1.0, animations: {
    someView.alpha = 0.0
}) ↓{ _ in
    someView.removeFromSuperview()
}
```




### <a name="operator_usage_whitespace"/>54/89. Operator Usage Whitespace rule (autocorrectable)
**Rule identifier**: `operator_usage_whitespace`

**Rule description**: `Operators should be surrounded by a single whitespace when they are being used.`

**Rule kind**: `Style`

#### Non triggering examples
```
let foo = 1 + 2
```

```
let foo = 1 > 2
```

```
let foo = !false
```

```
let foo: Int?
```

```
let foo: Array<String>
```

```
let model = CustomView<Container<Button>, NSAttributedString>()
```

```
let foo: [String]
```

```
let foo = 1 + 
  2
```

```
let range = 1...3
```

```
let range = 1 ... 3
```

```
let range = 1..<3
```

```
#if swift(>=3.0)
    foo()
#endif
```

```
array.removeAtIndex(-200)
```

```
let name = "image-1"
```

```
button.setImage(#imageLiteral(resourceName: "image-1"), for: .normal)
```

```
let doubleValue = -9e-11
```

```
let foo = GenericType<(UIViewController) -> Void>()
```

```
let foo = Foo<Bar<T>, Baz>()
```

```
let foo = SignalProducer<Signal<Value, Error>, Error>([ self.signal, next ]).flatten(.concat)
```

#### Triggering examples
```
let foo = 1↓+2
```

```
let foo = 1↓   + 2
```

```
let foo = 1↓   +    2
```

```
let foo = 1↓ +    2
```

```
let foo↓=1↓+2
```

```
let foo↓=1 + 2
```

```
let foo↓=bar
```

```
let range = 1↓ ..<  3
```

```
let foo = bar↓   ?? 0
```

```
let foo = bar↓??0
```

```
let foo = bar↓ !=  0
```

```
let foo = bar↓ !==  bar2
```

```
let v8 = Int8(1)↓  << 6
```

```
let v8 = 1↓ <<  (6)
```

```
let v8 = 1↓ <<  (6)
 let foo = 1 > 2
```

#### Corrections
```
let foo↓=bar
->
let foo = bar
```

```
let foo = 1↓ +    2
->
let foo = 1 + 2
```

```
let range = 1↓ ..<  3
->
let range = 1..<3
```

```
let foo = bar↓ !==  bar2
->
let foo = bar !== bar2
```

```
let v8 = 1↓ <<  (6)
->
let v8 = 1 << (6)
```

```
let v8 = 1↓ <<  (6)
 let foo = 1 > 2
->
let v8 = 1 << (6)
 let foo = 1 > 2
```

```
let foo = 1↓   + 2
->
let foo = 1 + 2
```

```
let foo = bar↓??0
->
let foo = bar ?? 0
```

```
let v8 = Int8(1)↓  << 6
->
let v8 = Int8(1) << 6
```

```
let foo = 1↓+2
->
let foo = 1 + 2
```

```
let foo↓=1↓+2
->
let foo = 1 + 2
```

```
let foo↓=1 + 2
->
let foo = 1 + 2
```

```
let foo = bar↓ !=  0
->
let foo = bar != 0
```

```
let foo = bar↓   ?? 0
->
let foo = bar ?? 0
```

```
let foo = 1↓   +    2
->
let foo = 1 + 2
```




### <a name="overridden_super_call"/>55/89. Overridden methods call super rule
**Rule identifier**: `overridden_super_call`

**Rule description**: `Some overridden methods should always call super`

**Rule kind**: `Lint`

#### Non triggering examples
```
class VC: UIViewController {
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
}
```

```
class VC: UIViewController {
	override func viewWillAppear(_ animated: Bool) {
		self.method1()
		super.viewWillAppear(animated)
		self.method2()
	}
}
```

```
class VC: UIViewController {
	override func loadView() {
	}
}
```

```
class Some {
	func viewWillAppear(_ animated: Bool) {
	}
}
```

```
class VC: UIViewController {
	override func viewDidLoad() {
		defer {
			super.viewDidLoad()
		}
	}
}
```

#### Triggering examples
```
class VC: UIViewController {
	override func viewWillAppear(_ animated: Bool) {↓
		//Not calling to super
		self.method()
	}
}
```

```
class VC: UIViewController {
	override func viewWillAppear(_ animated: Bool) {↓
		super.viewWillAppear(animated)
		//Other code
		super.viewWillAppear(animated)
	}
}
```

```
class VC: UIViewController {
	override func didReceiveMemoryWarning() {↓
	}
}
```




### <a name="pattern_matching_keywords"/>56/89. Pattern Matching Keywords rule
**Rule identifier**: `pattern_matching_keywords`

**Rule description**: `Combine multiple pattern matching bindings by moving keywords out of tuples.`

**Rule kind**: `Idiomatic`

#### Non triggering examples
```
switch foo {
    default: break
}
```

```
switch foo {
    case 1: break
}
```

```
switch foo {
    case bar: break
}
```

```
switch foo {
    case let (x, y): break
}
```

```
switch foo {
    case .foo(let x): break
}
```

```
switch foo {
    case let .foo(x, y): break
}
```

```
switch foo {
    case .foo(let x), .bar(let x): break
}
```

```
switch foo {
    case .foo(let x, var y): break
}
```

```
switch foo {
    case var (x, y): break
}
```

```
switch foo {
    case .foo(var x): break
}
```

```
switch foo {
    case var .foo(x, y): break
}
```

#### Triggering examples
```
switch foo {
    case (↓let x,  ↓let y): break
}
```

```
switch foo {
    case .foo(↓let x, ↓let y): break
}
```

```
switch foo {
    case (.yamlParsing(↓let x), .yamlParsing(↓let y)): break
}
```

```
switch foo {
    case (↓var x,  ↓var y): break
}
```

```
switch foo {
    case .foo(↓var x, ↓var y): break
}
```

```
switch foo {
    case (.yamlParsing(↓var x), .yamlParsing(↓var y)): break
}
```




### <a name="precondition"/>57/89. Precondition rule
**Rule identifier**: `precondition`

**Rule description**: `Do not use preconditions`

**Rule kind**: `Idiomatic`

#### Non triggering examples
```
preCondition(false, "bad code!")
```

```
// precondition(false, "bad code!")
```

```
/* precondition(false, "bad code!") */
```

```
"precondition(false, "bad code!")"
```

```
preCondition  (true, "bad code!")
```

```
// precondition  (true, "bad code!")
```

```
/* precondition  (true, "bad code!") */
```

```
"precondition  (true, "bad code!")"
```

```
preConditionFailure ("bad code!")
```

```
// preconditionFailure ("bad code!")
```

```
/* preconditionFailure ("bad code!") */
```

```
"preconditionFailure ("bad code!")"
```

```
dispatchPreCondition(condition: .onQueue(.main))
```

```
// dispatchPrecondition(condition: .onQueue(.main))
```

```
/* dispatchPrecondition(condition: .onQueue(.main)) */
```

```
"dispatchPrecondition(condition: .onQueue(.main))"
```

```
dispatchPreCondition(condition: .notOnQueue(.global))
```

```
// dispatchPrecondition(condition: .notOnQueue(.global))
```

```
/* dispatchPrecondition(condition: .notOnQueue(.global)) */
```

```
"dispatchPrecondition(condition: .notOnQueue(.global))"
```

```
dispatchPreCondition(condition: .onQueueAsBarrier(syncQueue))
```

```
// dispatchPrecondition(condition: .onQueueAsBarrier(syncQueue))
```

```
/* dispatchPrecondition(condition: .onQueueAsBarrier(syncQueue)) */
```

```
"dispatchPrecondition(condition: .onQueueAsBarrier(syncQueue))"
```

#### Triggering examples
```
↓precondition(false, "bad code!")
```

```
↓precondition  (true, "bad code!")
```

```
↓preconditionFailure ("bad code!")
```

```
↓dispatchPrecondition(condition: .onQueue(.main))
```

```
↓dispatchPrecondition(condition: .notOnQueue(.global))
```

```
↓dispatchPrecondition(condition: .onQueueAsBarrier(syncQueue))
```




### <a name="print"/>58/89. Print rule rule (autocorrectable)
**Rule identifier**: `print`

**Rule description**: `Do not use Swift print functions. Use Avito print: avitoPrint and avitoDebugPrint`

**Rule kind**: `Idiomatic`

#### Non triggering examples
```
avitoPrint("My spoon is too big")
```

```
// print("My spoon is too big")
```

```
/* print("My spoon is too big") */
```

```
"print("My spoon is too big")"
```

```
avitoDebugPrint("hell yeah!")
```

```
avitoPrint("hell yeah!")
```

```
avitoPrint  ("I love swift")
```

```
// debugPrint  ("I love swift")
```

```
/* debugPrint  ("I love swift") */
```

```
"debugPrint  ("I love swift")"
```

```
avitoDebugPrint("hell yeah!")
```

```
avitoPrint("hell yeah!")
```

```
avitoPrint ("bad code!")
```

```
// println ("bad code!")
```

```
/* println ("bad code!") */
```

```
"println ("bad code!")"
```

```
avitoDebugPrint("hell yeah!")
```

```
avitoPrint("hell yeah!")
```

#### Triggering examples
```
↓print("My spoon is too big")
```

```
↓debugPrint  ("I love swift")
```

```
↓println ("bad code!")
```




### <a name="private_outlet"/>59/89. Private Outlets rule
**Rule identifier**: `private_outlet`

**Rule description**: `IBOutlets should be private to avoid leaking UIKit to higher layers.`

**Rule kind**: `Lint`

#### Non triggering examples
```
class Foo {
  @IBOutlet private var label: UILabel?
}
```

```
class Foo {
  @IBOutlet private var label: UILabel!
}
```

```
class Foo {
  var notAnOutlet: UILabel
}
```

```
class Foo {
  @IBOutlet weak private var label: UILabel?
}
```

```
class Foo {
  @IBOutlet private weak var label: UILabel?
}
```

#### Triggering examples
```
class Foo {
  @IBOutlet ↓var label: UILabel?
}
```

```
class Foo {
  @IBOutlet ↓var label: UILabel!
}
```




### <a name="prohibited_super_call"/>60/89. Prohibited calls to super rule
**Rule identifier**: `prohibited_super_call`

**Rule description**: `Some methods should not call super`

**Rule kind**: `Lint`

#### Non triggering examples
```
class VC: UIViewController {
    override func loadView() {
    }
}
```

```
class NSView {
    func updateLayer() {
        self.method1()
    }
}
```

```
public class FileProviderExtension: NSFileProviderExtension {
    override func providePlaceholder(at url: URL, completionHandler: @escaping (Error?) -> Void) {
        guard let identifier = persistentIdentifierForItem(at: url) else {
            completionHandler(NSFileProviderError(.noSuchItem))
            return
        }
    }
}
```

#### Triggering examples
```
class VC: UIViewController {
    override func loadView() {↓
        super.loadView()
    }
}
```

```
class VC: NSFileProviderExtension {
    override func providePlaceholder(at url: URL, completionHandler: @escaping (Error?) -> Void) {↓
        self.method1()
        super.providePlaceholder(at:url, completionHandler: completionHandler)
    }
}
```

```
class VC: NSView {
    override func updateLayer() {↓
        self.method1()
        super.updateLayer()
        self.method2()
    }
}
```

```
class VC: NSView {
    override func updateLayer() {↓
        defer {
            super.updateLayer()
        }
    }
}
```




### <a name="protocol_property_accessors_order"/>61/89. Protocol Property Accessors Order rule (autocorrectable)
**Rule identifier**: `protocol_property_accessors_order`

**Rule description**: `When declaring properties in protocols, the order of accessors should be get set.`

**Rule kind**: `Style`

#### Non triggering examples
```
protocol Foo {
 var bar: String { get set }
 }
```

```
protocol Foo {
 var bar: String { get }
 }
```

```
protocol Foo {
 var bar: String { set }
 }
```

#### Triggering examples
```
protocol Foo {
 var bar: String { ↓set get }
 }
```

#### Corrections
```
protocol Foo {
 var bar: String { ↓set get }
 }
->
protocol Foo {
 var bar: String { get set }
 }
```




### <a name="redundant_discardable_let"/>62/89. Redundant Discardable Let rule (autocorrectable)
**Rule identifier**: `redundant_discardable_let`

**Rule description**: `Prefer _ = foo() over let _ = foo() when discarding a result from a function.`

**Rule kind**: `Style`

#### Non triggering examples
```
_ = foo()
```

```
if let _ = foo() { }
```

```
guard let _ = foo() else { return }
```

```
let _: ExplicitType = foo()
```

```
while let _ = SplashStyle(rawValue: maxValue) { maxValue += 1 }
```

#### Triggering examples
```
↓let _ = foo()
```

```
if _ = foo() { ↓let _ = bar() }
```

#### Corrections
```
↓let _ = foo()
->
_ = foo()
```

```
if _ = foo() { ↓let _ = bar() }
->
if _ = foo() { _ = bar() }
```




### <a name="redundant_nil_coalescing"/>63/89. Redundant Nil Coalescing rule (autocorrectable)
**Rule identifier**: `redundant_nil_coalescing`

**Rule description**: `nil coalescing operator is only evaluated if the lhs is nil, coalescing operator with nil as rhs is redundant`

**Rule kind**: `Idiomatic`

#### Non triggering examples
```
var myVar: Int?; myVar ?? 0
```

#### Triggering examples
```
var myVar: Int? = nil; myVar↓ ?? nil
```

```
var myVar: Int? = nil; myVar↓??nil
```

#### Corrections
```
var myVar: Int? = nil; let foo = myVar↓??nil
->
var myVar: Int? = nil; let foo = myVar
```

```
var myVar: Int? = nil; let foo = myVar↓ ?? nil
->
var myVar: Int? = nil; let foo = myVar
```




### <a name="redundant_optional_initialization"/>64/89. Redundant Optional Initialization rule (autocorrectable)
**Rule identifier**: `redundant_optional_initialization`

**Rule description**: `Initializing an optional variable with nil is redundant.`

**Rule kind**: `Idiomatic`

#### Non triggering examples
```
var myVar: Int?
```

```
let myVar: Int? = nil
```

```
var myVar: Int? = 0
```

```
func foo(bar: Int? = 0) { }
```

```
var myVar: Optional<Int>
```

```
let myVar: Optional<Int> = nil
```

```
var myVar: Optional<Int> = 0
```

```
var foo: Int? {
   if bar != nil { }
   return 0
}
```

```
var foo: Int? = {
   if bar != nil { }
   return 0
}()
```

```
lazy var test: Int? = nil
```

#### Triggering examples
```
var myVar: Int?↓ = nil
```

```
var myVar: Optional<Int>↓ = nil
```

```
var myVar: Int?↓=nil
```

```
var myVar: Optional<Int>↓=nil
```

#### Corrections
```
var myVar: Int?↓=nil
->
var myVar: Int?
```

```
var myVar: Optional<Int>↓ = nil
->
var myVar: Optional<Int>
```

```
var myVar: Optional<Int>↓=nil
->
var myVar: Optional<Int>
```

```
var myVar: Int?↓ = nil
->
var myVar: Int?
```

```
class C {
#if true
var myVar: Int?↓ = nil
#endif
}
->
class C {
#if true
var myVar: Int?
#endif
}
```




### <a name="redundant_set_access_control"/>65/89. Redundant Set Access Control Rule rule
**Rule identifier**: `redundant_set_access_control`

**Rule description**: `Property setter access level shouldn't be explicit if it's the same as the variable access level.`

**Rule kind**: `Idiomatic`

#### Non triggering examples
```
private(set) public var foo: Int
```

```
public let foo: Int
```

```
public var foo: Int
```

```
var foo: Int
```

```
private final class A {
    private(set) var value: Int
}
```

#### Triggering examples
```
↓private(set) private var foo: Int
```

```
↓fileprivate(set) fileprivate var foo: Int
```

```
↓internal(set) internal var foo: Int
```

```
↓public(set) public var foo: Int
```

```
open class Foo {
    ↓open(set) open var bar: Int
}
```

```
class A {
    ↓internal(set) var value: Int
}
```

```
fileprivate class A {
    ↓fileprivate(set) var value: Int
}
```




### <a name="redundant_spaces_before_colon"/>66/89. Redundant spaces before colon rule (autocorrectable)
**Rule identifier**: `redundant_spaces_before_colon`

**Rule description**: `There must be 0 spaces before colon`

**Rule kind**: `Style`

#### Non triggering examples
```
static let bool: Bool
```

```
// static let bool : Bool
```

```
/* static let bool : Bool */
```

```
"static let bool : Bool"
```

```
private let dictionary: [String: Bool]
```

```
// private let dictionary: [String   : Bool]
```

```
/* private let dictionary: [String   : Bool] */
```

```
"private let dictionary: [String   : Bool]"
```

```
static var bool: Bool
```

```
// static var bool : Bool
```

```
/* static var bool : Bool */
```

```
"static var bool : Bool"
```

```
private var dictionary: [String: Bool]
```

```
// private var dictionary: [String   : Bool]
```

```
/* private var dictionary: [String   : Bool] */
```

```
"private var dictionary: [String   : Bool]"
```

```
let onFoo: ((_ bool: Bool) -> ())
```

```
// let onFoo : ((_ bool: Bool) -> ())
```

```
/* let onFoo : ((_ bool: Bool) -> ()) */
```

```
"let onFoo : ((_ bool: Bool) -> ())"
```

```
let onFoo: ((_ dictionary: [String: Bool]) -> ())
```

```
// let onFoo: ((_ dictionary: [String : Bool]) -> ())
```

```
/* let onFoo: ((_ dictionary: [String : Bool]) -> ()) */
```

```
"let onFoo: ((_ dictionary: [String : Bool]) -> ())"
```

```
var onFoo: ((_ bool: Bool) -> ())
```

```
// var onFoo : ((_ bool: Bool) -> ())
```

```
/* var onFoo : ((_ bool: Bool) -> ()) */
```

```
"var onFoo : ((_ bool: Bool) -> ())"
```

```
var onFoo: ((_ dictionary: [String: Bool]) -> ())
```

```
// var onFoo: ((_ dictionary: [String    : Bool]) -> ())
```

```
/* var onFoo: ((_ dictionary: [String    : Bool]) -> ()) */
```

```
"var onFoo: ((_ dictionary: [String    : Bool]) -> ())"
```

```
func foo(bool: Bool) {}
```

```
// func foo(bool : Bool) {}
```

```
/* func foo(bool : Bool) {} */
```

```
"func foo(bool : Bool) {}"
```

```
func foo(_ bool: Bool, int: Int) {}
```

```
// func foo(_ bool: Bool, int : Int) {}
```

```
/* func foo(_ bool: Bool, int : Int) {} */
```

```
"func foo(_ bool: Bool, int : Int) {}"
```

```
func foo(completion: ((_ dictionary: [String:  Bool]) -> ())) {}
```

```
// func foo(completion: ((_ dictionary: [String :  Bool]) -> ())) {}
```

```
/* func foo(completion: ((_ dictionary: [String :  Bool]) -> ())) {} */
```

```
"func foo(completion: ((_ dictionary: [String :  Bool]) -> ())) {}"
```

```
switch value { case 1: return; case 2...4: return; default: return }
```

```
// switch value { case 1 : return; case 2...4: return; default: return }
```

```
/* switch value { case 1 : return; case 2...4: return; default: return } */
```

```
"switch value { case 1 : return; case 2...4: return; default: return }"
```

```
switch value { case 1: return; case 2...4: return; default: return }
```

```
// switch value { case 1: return; case 2...4 : return; default: return }
```

```
/* switch value { case 1: return; case 2...4 : return; default: return } */
```

```
"switch value { case 1: return; case 2...4 : return; default: return }"
```

```
switch value { case 1: return; case 2...4: return; default: return }
```

```
// switch value { case 1: return; case 2...4: return; default : return }
```

```
/* switch value { case 1: return; case 2...4: return; default : return } */
```

```
"switch value { case 1: return; case 2...4: return; default : return }"
```

```
let size = CGSize(width: 1, height: 2)
```

```
// let size = CGSize(width : 1, height: 2)
```

```
/* let size = CGSize(width : 1, height: 2) */
```

```
"let size = CGSize(width : 1, height: 2)"
```

```
let size = CGSize(width: 1, height: 2)
```

```
// let size = CGSize(width: 1, height : 2)
```

```
/* let size = CGSize(width: 1, height : 2) */
```

```
"let size = CGSize(width: 1, height : 2)"
```

```
let filtered = array.filter { (item: Any?) in return item }
```

```
// let filtered = array.filter { (item : Any?) in return item }
```

```
/* let filtered = array.filter { (item : Any?) in return item } */
```

```
"let filtered = array.filter { (item : Any?) in return item }"
```

```
let filtered = array.enumetated.filter { ((offset: Int, element: String)) -> Bool in true }
```

```
// let filtered = array.enumetated.filter { ((offset : Int, element: String)) -> Bool in true }
```

```
/* let filtered = array.enumetated.filter { ((offset : Int, element: String)) -> Bool in true } */
```

```
"let filtered = array.enumetated.filter { ((offset : Int, element: String)) -> Bool in true }"
```

```
let filtered = array?.enumetated.filter { ((offset: Int, element: String)) -> Bool in true }
```

```
// let filtered = array?.enumetated.filter { ((offset: Int, element : String)) -> Bool in true }
```

```
/* let filtered = array?.enumetated.filter { ((offset: Int, element : String)) -> Bool in true } */
```

```
"let filtered = array?.enumetated.filter { ((offset: Int, element : String)) -> Bool in true }"
```

```
let double: Double = isOk
    ? 3.14
    : 2.71
```

```
return isOk ? 3.14 : 2.71
```

```
foo(value: isOk ? 3.14 : 2.71)
```

#### Triggering examples
```
static let bool↓ : Bool
```

```
private let dictionary: [String↓   : Bool]
```

```
static var bool↓ : Bool
```

```
private var dictionary: [String↓   : Bool]
```

```
let onFoo↓ : ((_ bool: Bool) -> ())
```

```
let onFoo: ((_ dictionary: [String↓ : Bool]) -> ())
```

```
var onFoo↓ : ((_ bool: Bool) -> ())
```

```
var onFoo: ((_ dictionary: [String↓    : Bool]) -> ())
```

```
func foo(bool↓ : Bool) {}
```

```
func foo(_ bool: Bool, int↓ : Int) {}
```

```
func foo(completion: ((_ dictionary: [String↓ :  Bool]) -> ())) {}
```

```
switch value { case 1↓ : return; case 2...4: return; default: return }
```

```
switch value { case 1: return; case 2...4↓ : return; default: return }
```

```
switch value { case 1: return; case 2...4: return; default↓ : return }
```

```
let size = CGSize(width↓ : 1, height: 2)
```

```
let size = CGSize(width: 1, height↓ : 2)
```

```
let filtered = array.filter { (item↓ : Any?) in return item }
```

```
let filtered = array.enumetated.filter { ((offset↓ : Int, element: String)) -> Bool in true }
```

```
let filtered = array?.enumetated.filter { ((offset: Int, element↓ : String)) -> Bool in true }
```

#### Corrections
```
var onFoo↓ : ((_ bool: Bool) -> ())
->
var onFoo: ((_ bool: Bool) -> ())
```

```
private let dictionary: [String↓   : Bool]
->
private let dictionary: [String: Bool]
```

```
func foo(bool↓ : Bool) {}
->
func foo(bool: Bool) {}
```

```
static let bool↓ : Bool
->
static let bool: Bool
```

```
switch value { case 1↓ : return; case 2...4: return; default: return }
->
switch value { case 1: return; case 2...4: return; default: return }
```

```
private var dictionary: [String↓   : Bool]
->
private var dictionary: [String: Bool]
```

```
func foo(completion: ((_ dictionary: [String↓ :  Bool]) -> ())) {}
->
func foo(completion: ((_ dictionary: [String:  Bool]) -> ())) {}
```

```
let filtered = array?.enumetated.filter { ((offset: Int, element↓ : String)) -> Bool in true }
->
let filtered = array?.enumetated.filter { ((offset: Int, element: String)) -> Bool in true }
```

```
let filtered = array.filter { (item↓ : Any?) in return item }
->
let filtered = array.filter { (item: Any?) in return item }
```

```
let filtered = array.enumetated.filter { ((offset↓ : Int, element: String)) -> Bool in true }
->
let filtered = array.enumetated.filter { ((offset: Int, element: String)) -> Bool in true }
```

```
static var bool↓ : Bool
->
static var bool: Bool
```

```
let onFoo↓ : ((_ bool: Bool) -> ())
->
let onFoo: ((_ bool: Bool) -> ())
```

```
switch value { case 1: return; case 2...4↓ : return; default: return }
->
switch value { case 1: return; case 2...4: return; default: return }
```

```
var onFoo: ((_ dictionary: [String↓    : Bool]) -> ())
->
var onFoo: ((_ dictionary: [String: Bool]) -> ())
```

```
switch value { case 1: return; case 2...4: return; default↓ : return }
->
switch value { case 1: return; case 2...4: return; default: return }
```

```
let size = CGSize(width↓ : 1, height: 2)
->
let size = CGSize(width: 1, height: 2)
```

```
let size = CGSize(width: 1, height↓ : 2)
->
let size = CGSize(width: 1, height: 2)
```

```
func foo(_ bool: Bool, int↓ : Int) {}
->
func foo(_ bool: Bool, int: Int) {}
```

```
let onFoo: ((_ dictionary: [String↓ : Bool]) -> ())
->
let onFoo: ((_ dictionary: [String: Bool]) -> ())
```




### <a name="redundant_void_return"/>67/89. Redundant Void Return rule (autocorrectable)
**Rule identifier**: `redundant_void_return`

**Rule description**: `Returning Void in a function declaration is redundant.`

**Rule kind**: `Idiomatic`

#### Non triggering examples
```
func foo() {}
```

```
func foo() -> Int {}
```

```
func foo() -> Int -> Void {}
```

```
func foo() -> VoidResponse
```

```
let foo: Int -> Void
```

```
func foo() -> Int -> () {}
```

```
let foo: Int -> ()
```

```
func foo() -> ()?
```

```
func foo() -> ()!
```

```
func foo() -> Void?
```

```
func foo() -> Void!
```

#### Triggering examples
```
func foo()↓ -> Void {}
```

```
protocol Foo {
 func foo()↓ -> Void
}
```

```
func foo()↓ -> () {}
```

```
protocol Foo {
 func foo()↓ -> ()
}
```

#### Corrections
```
func foo()↓ -> Void {}
->
func foo() {}
```

```
protocol Foo {
 func foo()↓ -> ()
}
->
protocol Foo {
 func foo()
}
```

```
protocol Foo {
    #if true
    func foo()↓ -> Void
    #endif
}
->
protocol Foo {
    #if true
    func foo()
    #endif
}
```

```
protocol Foo {
 func foo()↓ -> Void
}
->
protocol Foo {
 func foo()
}
```

```
func foo()↓ -> () {}
->
func foo() {}
```




### <a name="return_arrow_whitespace"/>68/89. Returning Whitespace rule (autocorrectable)
**Rule identifier**: `return_arrow_whitespace`

**Rule description**: `Return arrow and return type should be separated by a single space or on a separate line.`

**Rule kind**: `Style`

#### Non triggering examples
```
func abc() -> Int {}
```

```
func abc() -> [Int] {}
```

```
func abc() -> (Int, Int) {}
```

```
var abc = {(param: Int) -> Void in }
```

```
func abc() ->
    Int {}
```

```
func abc()
    -> Int {}
```

#### Triggering examples
```
func abc()↓->Int {}
```

```
func abc()↓->[Int] {}
```

```
func abc()↓->(Int, Int) {}
```

```
func abc()↓-> Int {}
```

```
func abc()↓ ->Int {}
```

```
func abc()↓  ->  Int {}
```

```
var abc = {(param: Int)↓ ->Bool in }
```

```
var abc = {(param: Int)↓->Bool in }
```

#### Corrections
```
func abc()↓
->  Int {}
->
func abc()
-> Int {}
```

```
func abc()↓ ->Int {}
->
func abc() -> Int {}
```

```
func abc()↓-> Int {}
->
func abc() -> Int {}
```

```
func abc()↓  ->
Int {}
->
func abc() ->
Int {}
```

```
func abc()↓  ->  Int {}
->
func abc() -> Int {}
```

```
func abc()↓
  ->  Int {}
->
func abc()
  -> Int {}
```

```
func abc()↓  ->
  Int {}
->
func abc() ->
  Int {}
```

```
func abc()↓->Int {}
->
func abc() -> Int {}
```




### <a name="self_in_backticks"/>69/89. Self in backticks rule rule
**Rule identifier**: `self_in_backticks`

**Rule description**: `Do not use self in backticks`

**Rule kind**: `Idiomatic`

#### Non triggering examples
```
guard let self = self else { return }
```

```
weak var self = self
```

```
if let self = self {}
```

#### Triggering examples
```
guard let ↓`self` = self else { return }
```

```
weak var ↓`self` = self
```

```
if let ↓`self` = self {}
```




### <a name="setup_function_name"/>70/89. Setup function name rule (autocorrectable)
**Rule identifier**: `setup_function_name`

**Rule description**: `Prefer verb setUp to a noun setup if a function sets something up`

**Rule kind**: `Style`

#### Non triggering examples
```
func setup() {}
```

```
private let setup: (() -> ())?
```

```
private let fullSetup: (() -> ())?
```

```
func setUpModule(_ module: Module) {}
```

```
func setUpStateObservable() {}
```

```
private func      setUpView() {}
```

```
setUpModule(_ module: Module)
```

```
interactor.setUpStateObservable(synchronously: false) { _ in }
```

#### Triggering examples
```
func set↓upModule(_ module: Module) {}
```

```
func set↓upStateObservable() {}
```

```
private func      set↓upView() {}
```

```
set↓upModule(_ module: Module)
```

```
interactor.set↓upStateObservable(synchronously: false) { _ in }
```

#### Corrections
```
interactor.set↓upStateObservable(synchronously: false) { _ in }
->
interactor.setUpStateObservable(synchronously: false) { _ in }
```

```
func set↓upStateObservable() {}
->
func setUpStateObservable() {}
```

```
private func      set↓upView() {}
->
private func      setUpView() {}
```

```
set↓upModule(_ module: Module)
->
setUpModule(_ module: Module)
```

```
func set↓upModule(_ module: Module) {}
->
func setUpModule(_ module: Module) {}
```




### <a name="statement_position"/>71/89. Statement Position rule (autocorrectable)
**Rule identifier**: `statement_position`

**Rule description**: `Else and catch should be on the same line, one space after the previous declaration.`

**Rule kind**: `Style`

#### Non triggering examples
```
} else if {
```

```
} else {
```

```
} catch {
```

```
"}else{"
```

```
struct A { let catchphrase: Int }
let a = A(
 catchphrase: 0
)
```

```
struct A { let `catch`: Int }
let a = A(
 `catch`: 0
)
```

#### Triggering examples
```
↓}else if {
```

```
↓}  else {
```

```
↓}
catch {
```

```
↓}
	  catch {
```

#### Corrections
```
↓}
 else {
->
} else {
```

```
↓}
   else if {
->
} else if {
```

```
↓}
 catch {
->
} catch {
```




### <a name="string_type_inference"/>72/89. String type inference rule
**Rule identifier**: `string_type_inference`

**Rule description**: `Omit String type specifier in variable declarations`

**Rule kind**: `Style`

#### Non triggering examples
```
let string = ""
```

```
// let string:String = ""
```

```
/* let string:String = "" */
```

```
let string=""
```

```
// let string: String=""
```

```
/* let string: String="" */
```

```
var string = ""
```

```
// var string: String = ""
```

```
/* var string: String = "" */
```

```
var string = ""
```

```
// var string: String = ""
```

```
/* var string: String = "" */
```

```
var int = 2; let string = ""
```

```
// var int = 2; let string: String = ""
```

```
/* var int = 2; let string: String = "" */
```

```
func foo(string: String = "") {}
```

```
func foo(string: String = "") {}
```

```
private var elements = [Element]()
func foo(string: String = "") {}
```

#### Triggering examples
```
↓let string:String = ""
```

```
↓let string: String=""
```

```
↓var string: String = ""
```

```
↓var string: String = ""
```

```
var int = 2; ↓let string: String = ""
```




### <a name="switch_case_alignment"/>73/89. Switch and Case Statement Alignment rule
**Rule identifier**: `switch_case_alignment`

**Rule description**: `Case statements should vertically align with their enclosing switch statement, or indented if configured otherwise.`

**Rule kind**: `Style`

#### Non triggering examples
```
switch someBool {
case true: // case 1
    print('red')
case false:
    /*
    case 2
    */
    if case let .someEnum(val) = someFunc() {
        print('blue')
    }
}
enum SomeEnum {
    case innocent
}
```

```
if aBool {
    switch someBool {
    case true:
        print('red')
    case false:
        print('blue')
    }
}
```

```
switch someInt {
// comments ignored
case 0:
    // zero case
    print('Zero')
case 1:
    print('One')
default:
    print('Some other number')
}
```

#### Triggering examples
```
switch someBool {
    ↓case true:
        print("red")
    ↓case false:
        print("blue")
}
```

```
if aBool {
    switch someBool {
        ↓case true:
            print('red')
        ↓case false:
            print('blue')
    }
}
```

```
switch someInt {
    ↓case 0:
        print('Zero')
    ↓case 1:
        print('One')
    ↓default:
        print('Some other number')
}
```

```
switch someBool {
case true:
    print('red')
    ↓case false:
        print('blue')
}
```

```
if aBool {
    switch someBool {
        ↓case true:
        print('red')
    case false:
    print('blue')
    }
}
```




### <a name="switch_case_on_newline"/>74/89. Switch Case on Newline rule
**Rule identifier**: `switch_case_on_newline`

**Rule description**: `Cases inside a switch should always be on a newline`

**Rule kind**: `Style`

#### Non triggering examples
```
/*case 1: */return true
```

```
//case 1:
 return true
```

```
let x = [caseKey: value]
```

```
let x = [key: .default]
```

```
if case let .someEnum(value) = aFunction([key: 2]) { }
```

```
guard case let .someEnum(value) = aFunction([key: 2]) { }
```

```
for case let .someEnum(value) = aFunction([key: 2]) { }
```

```
enum Environment {
 case development
}
```

```
enum Environment {
 case development(url: URL)
}
```

```
enum Environment {
 case development(url: URL) // staging
}
```

```
switch foo {
  case 1:
 return true
}
```

```
switch foo {
  default:
 return true
}
```

```
switch foo {
  case let value:
 return true
}
```

```
switch foo {
  case .myCase: // error from network
 return true
}
```

```
switch foo {
  case let .myCase(value) where value > 10:
 return false
}
```

```
switch foo {
  case let .myCase(value)
 where value > 10:
 return false
}
```

```
switch foo {
  case let .myCase(code: lhsErrorCode, description: _)
 where lhsErrorCode > 10:
 return false
}
```

```
switch foo {
  case #selector(aFunction(_:)):
 return false

}
```

#### Triggering examples
```
switch foo {
  ↓case 1: return true
}
```

```
switch foo {
  ↓case let value: return true
}
```

```
switch foo {
  ↓default: return true
}
```

```
switch foo {
  ↓case "a string": return false
}
```

```
switch foo {
  ↓case .myCase: return false // error from network
}
```

```
switch foo {
  ↓case let .myCase(value) where value > 10: return false
}
```

```
switch foo {
  ↓case #selector(aFunction(_:)): return false

}
```

```
switch foo {
  ↓case let .myCase(value)
 where value > 10: return false
}
```

```
switch foo {
  ↓case .first,
 .second: return false
}
```




### <a name="sync"/>75/89. Sync rule rule
**Rule identifier**: `sync`

**Rule description**: `Do not use Swift sync function. Use Avito sync: avitoSync`

**Rule kind**: `Idiomatic`

#### Non triggering examples
```
avitoSyncQueue.
    avitoSync
{
    _tickets = newValue
}
```

```
SyncQueue.
    Sync
{
    _tickets = newValue
}
```

```
// syncQueue.
    sync
{
    _tickets = newValue
}
```

```
/* syncQueue.
    sync
{
    _tickets = newValue
} */
```

```
"syncQueue.
    sync
{
    _tickets = newValue
}"
```

```
let sync = НЕЛЛ УЕАН
```

```
let foo = bar.sync
```

```
avitoSyncQueue.
    avitoSync
    (
        completion
    )
```

```
SyncQueue.
    Sync
    (
        completion
    )
```

```
// syncQueue.
    sync
    (
        completion
    )
```

```
/* syncQueue.
    sync
    (
        completion
    ) */
```

```
"syncQueue.
    sync
    (
        completion
    )"
```

```
let sync = НЕЛЛ УЕАН
```

```
let foo = bar.sync
```

#### Triggering examples
```
syncQueue↓.
    sync
{
    _tickets = newValue
}
```

```
syncQueue↓.
    sync
    (
        completion
    )
```




### <a name="syntactic_sugar"/>76/89. Syntactic Sugar rule
**Rule identifier**: `syntactic_sugar`

**Rule description**: `Shorthand syntactic sugar should be used, i.e. [Int] instead of Array<Int>.`

**Rule kind**: `Idiomatic`

#### Non triggering examples
```
let x: [Int]
```

```
let x: [Int: String]
```

```
let x: Int?
```

```
func x(a: [Int], b: Int) -> [Int: Any]
```

```
let x: Int!
```

```
extension Array { 
 func x() { } 
 }
```

```
extension Dictionary { 
 func x() { } 
 }
```

```
let x: CustomArray<String>
```

```
var currentIndex: Array<OnboardingPage>.Index?
```

```
func x(a: [Int], b: Int) -> Array<Int>.Index
```

```
unsafeBitCast(nonOptionalT, to: Optional<T>.self)
```

```
type is Optional<String>.Type
```

```
let x: Foo.Optional<String>
```

#### Triggering examples
```
let x: ↓Array<String>
```

```
let x: ↓Dictionary<Int, String>
```

```
let x: ↓Optional<Int>
```

```
let x: ↓ImplicitlyUnwrappedOptional<Int>
```

```
func x(a: ↓Array<Int>, b: Int) -> [Int: Any]
```

```
func x(a: [Int], b: Int) -> ↓Dictionary<Int, String>
```

```
func x(a: ↓Array<Int>, b: Int) -> ↓Dictionary<Int, String>
```

```
let x = ↓Array<String>.array(of: object)
```

```
let x: ↓Swift.Optional<String>
```




### <a name="tabs"/>77/89. Tabs rule rule (autocorrectable)
**Rule identifier**: `tabs`

**Rule description**: `Prefer whitespaces to tabs`

**Rule kind**: `Style`

#### Non triggering examples
```
    let int = 1
```

```
"        this is string"
```

```
//            this is comment
```

```
/*                this is comment*/
```

#### Triggering examples
```
↓	let int = 1
```

```
"↓		this is string"
```

```
//↓			this is comment
```

```
/*↓				this is comment*/
```

#### Corrections
```
/*↓				this is comment*/
->
/*                this is comment*/
```

```
//↓			this is comment
->
//            this is comment
```

```
"↓		this is string"
->
"        this is string"
```

```
↓	let int = 1
->
    let int = 1
```




### <a name="trailing_newline"/>78/89. Trailing Newline rule (autocorrectable)
**Rule identifier**: `trailing_newline`

**Rule description**: `Files should have a single trailing newline.`

**Rule kind**: `Style`

#### Non triggering examples
```
let a = 0
```

#### Triggering examples
```
let a = 0
```

```
let a = 0

```

#### Corrections
```
let a = 0
->
let a = 0
```

```
let b = 0

->
let b = 0
```

```
let c = 0



->
let c = 0
```




### <a name="trailing_semicolon"/>79/89. Trailing Semicolon rule (autocorrectable)
**Rule identifier**: `trailing_semicolon`

**Rule description**: `Lines should not have trailing semicolons.`

**Rule kind**: `Idiomatic`

#### Non triggering examples
```
let a = 0
```

#### Triggering examples
```
let a = 0↓;
```

```
let a = 0↓;
let b = 1
```

```
let a = 0↓;;
```

```
let a = 0↓;    ;;
```

```
let a = 0↓; ; ;
```

#### Corrections
```
let a = 0↓;
->
let a = 0
```

```
let a = 0↓;    ;;
->
let a = 0
```

```
let a = 0↓;
let b = 1
->
let a = 0
let b = 1
```

```
let a = 0↓;;
->
let a = 0
```

```
let a = 0↓; ; ;
->
let a = 0
```




### <a name="uicolor"/>80/89. UIColor rule rule
**Rule identifier**: `uicolor`

**Rule description**: `Do not use UIColor. Use colors from SpecColors`

**Rule kind**: `Idiomatic`

#### Non triggering examples
```
SpecColors.background
```

```
private let color: UIColor
```

```
activityIndicatorStyle = .red
```

```
activityIndicatorViewStyle = .red
```

#### Triggering examples
```
↓UIColor.red
```

```
↓UIColor.white(322)
```

```
↓UIColor.init(hex:"xFF00FF"
```

```
UIButton.appearance().setTitleColor(↓UIColor.magenta, for: .normal)
```

```
color = .red
```

```
color=.red
```

```
color  =  .red
```

```
if !drawingInfo.pathsWithoutSuggestions.isEmpty { color = .green }
```




### <a name="unneeded_break_in_switch"/>81/89. Unneeded Break in Switch rule
**Rule identifier**: `unneeded_break_in_switch`

**Rule description**: `Avoid using unneeded break statements.`

**Rule kind**: `Idiomatic`

#### Non triggering examples
```
switch foo {
case .bar:
    break
}
```

```
switch foo {
default:
    break
}
```

```
switch foo {
case .bar:
    for i in [0, 1, 2] { break }
}
```

```
switch foo {
case .bar:
    if true { break }
}
```

```
switch foo {
case .bar:
    something()
}
```

#### Triggering examples
```
switch foo {
case .bar:
    something()
    ↓break
}
```

```
switch foo {
case .bar:
    something()
    ↓break // comment
}
```

```
switch foo {
default:
    something()
    ↓break
}
```

```
switch foo {
case .foo, .foo2 where condition:
    something()
    ↓break
}
```




### <a name="unneeded_parentheses_in_closure_argument"/>82/89. Unneeded Parentheses in Closure Argument rule (autocorrectable)
**Rule identifier**: `unneeded_parentheses_in_closure_argument`

**Rule description**: `Parentheses are not needed when declaring closure arguments.`

**Rule kind**: `Style`

#### Non triggering examples
```
let foo = { (bar: Int) in }
```

```
let foo = { bar, _  in }
```

```
let foo = { bar in }
```

```
let foo = { bar -> Bool in return true }
```

#### Triggering examples
```
call(arg: { ↓(bar) in })
```

```
call(arg: { ↓(bar, _) in })
```

```
let foo = { ↓(bar) -> Bool in return true }
```

```
foo.map { ($0, $0) }.forEach { ↓(x, y) in }
```

```
foo.bar { [weak self] ↓(x, y) in }
```

```
[].first { ↓(temp) in
    [].first { ↓(temp) in
        [].first { ↓(temp) in
            _ = temp
            return false
        }
        return false
    }
    return false
}
```

```
[].first { temp in
    [].first { ↓(temp) in
        [].first { ↓(temp) in
            _ = temp
            return false
        }
        return false
    }
    return false
}
```

#### Corrections
```
foo.map { ($0, $0) }.forEach { ↓(x, y) in }
->
foo.map { ($0, $0) }.forEach { x, y in }
```

```
foo.bar { [weak self] ↓(x, y) in }
->
foo.bar { [weak self] x, y in }
```

```
let foo = { ↓(bar) -> Bool in return true }
->
let foo = { bar -> Bool in return true }
```

```
method { ↓(foo, bar) in }
->
method { foo, bar in }
```

```
call(arg: { ↓(bar) in })
->
call(arg: { bar in })
```

```
call(arg: { ↓(bar, _) in })
->
call(arg: { bar, _ in })
```




### <a name="unused_closure_parameter"/>83/89. Unused Closure Parameter rule (autocorrectable)
**Rule identifier**: `unused_closure_parameter`

**Rule description**: `Unused parameter in a closure should be replaced with _.`

**Rule kind**: `Lint`

#### Non triggering examples
```
[1, 2].map { $0 + 1 }
```

```
[1, 2].map({ $0 + 1 })
```

```
[1, 2].map { number in
 number + 1 
}
```

```
[1, 2].map { _ in
 3 
}
```

```
[1, 2].something { number, idx in
 return number * idx
}
```

```
let isEmpty = [1, 2].isEmpty()
```

```
violations.sorted(by: { lhs, rhs in 
 return lhs.location > rhs.location
})
```

```
rlmConfiguration.migrationBlock.map { rlmMigration in
return { migration, schemaVersion in
rlmMigration(migration.rlmMigration, schemaVersion)
}
}
```

```
genericsFunc { (a: Type, b) in
a + b
}
```

```
var label: UILabel = { (lbl: UILabel) -> UILabel in
   lbl.backgroundColor = .red
   return lbl
}(UILabel())
```

```
hoge(arg: num) { num in
  return num
}
```

```
({ (manager: FileManager) in
  print(manager)
})(FileManager.default)
```

#### Triggering examples
```
[1, 2].map { ↓number in
 return 3
}
```

```
[1, 2].map { ↓number in
 return numberWithSuffix
}
```

```
[1, 2].map { ↓number in
 return 3 // number
}
```

```
[1, 2].map { ↓number in
 return 3 "number"
}
```

```
[1, 2].something { number, ↓idx in
 return number
}
```

```
genericsFunc { (↓number: TypeA, idx: TypeB) in return idx
}
```

```
hoge(arg: num) { ↓num in
}
```

```
fooFunc { ↓아 in
 }
```

```
func foo () {
 bar { ↓number in
 return 3
}
```

#### Corrections
```
[1, 2].something { number, ↓idx in
 return number
}
->
[1, 2].something { number, _ in
 return number
}
```

```
genericsFunc { (↓a: Type, ↓b: Type) -> Void in
}
->
genericsFunc { (_: Type, _: Type) -> Void in
}
```

```
genericsFunc { (↓a, ↓b: Type) -> Void in
}
->
genericsFunc { (_, _: Type) -> Void in
}
```

```
genericsFunc(closure: { (↓int: Int) -> Void in // do something
}
->
genericsFunc(closure: { (_: Int) -> Void in // do something
}
```

```
genericsFunc { (↓a: Type, ↓b) -> Void in
}
->
genericsFunc { (_: Type, _) -> Void in
}
```

```
[1, 2].map { ↓number in
 return numberWithSuffix
}
->
[1, 2].map { _ in
 return numberWithSuffix
}
```

```
[1, 2].map { ↓number in
 return 3 // number
}
->
[1, 2].map { _ in
 return 3 // number
}
```

```
genericsFunc { (a: Type, ↓b) -> Void in
return a
}
->
genericsFunc { (a: Type, _) -> Void in
return a
}
```

```
class C {
 #if true
 func f() {
 [1, 2].map { ↓number in
 return 3
 }
 }
 #endif
}
->
class C {
 #if true
 func f() {
 [1, 2].map { _ in
 return 3
 }
 }
 #endif
}
```

```
[1, 2].map { ↓number in
 return 3
}
->
[1, 2].map { _ in
 return 3
}
```

```
[1, 2].map { ↓number in
 return 3 "number"
}
->
[1, 2].map { _ in
 return 3 "number"
}
```

```
func foo () {
 bar { ↓number in
 return 3
}
->
func foo () {
 bar { _ in
 return 3
}
```

```
hoge(arg: num) { ↓num in
}
->
hoge(arg: num) { _ in
}
```




### <a name="unused_enumerated"/>84/89. Unused Enumerated rule
**Rule identifier**: `unused_enumerated`

**Rule description**: `When the index or the item is not used, .enumerated() can be removed.`

**Rule kind**: `Idiomatic`

#### Non triggering examples
```
for (idx, foo) in bar.enumerated() { }
```

```
for (_, foo) in bar.enumerated().something() { }
```

```
for (_, foo) in bar.something() { }
```

```
for foo in bar.enumerated() { }
```

```
for foo in bar { }
```

```
for (idx, _) in bar.enumerated().something() { }
```

```
for (idx, _) in bar.something() { }
```

```
for idx in bar.indices { }
```

```
for (section, (event, _)) in data.enumerated() {}
```

#### Triggering examples
```
for (↓_, foo) in bar.enumerated() { }
```

```
for (↓_, foo) in abc.bar.enumerated() { }
```

```
for (↓_, foo) in abc.something().enumerated() { }
```

```
for (idx, ↓_) in bar.enumerated() { }
```




### <a name="unused_optional_binding"/>85/89. Unused Optional Binding rule
**Rule identifier**: `unused_optional_binding`

**Rule description**: `Prefer != nil over let _ =`

**Rule kind**: `Style`

#### Non triggering examples
```
if let bar = Foo.optionalValue {
}
```

```
if let (_, second) = getOptionalTuple() {
}
```

```
if let (_, asd, _) = getOptionalTuple(), let bar = Foo.optionalValue {
}
```

```
if foo() { let _ = bar() }
```

```
if foo() { _ = bar() }
```

```
if case .some(_) = self {}
```

```
if let point = state.find({ _ in true }) {}
```

#### Triggering examples
```
if let ↓_ = Foo.optionalValue {
}
```

```
if let a = Foo.optionalValue, let ↓_ = Foo.optionalValue2 {
}
```

```
guard let a = Foo.optionalValue, let ↓_ = Foo.optionalValue2 {
}
```

```
if let (first, second) = getOptionalTuple(), let ↓_ = Foo.optionalValue {
}
```

```
if let (first, _) = getOptionalTuple(), let ↓_ = Foo.optionalValue {
}
```

```
if let (_, second) = getOptionalTuple(), let ↓_ = Foo.optionalValue {
}
```

```
if let ↓(_, _, _) = getOptionalTuple(), let bar = Foo.optionalValue {
}
```

```
func foo() {
if let ↓_ = bar {
}
```

```
if case .some(let ↓_) = self {}
```




### <a name="vertical_parameter_alignment"/>86/89. Vertical Parameter Alignment rule
**Rule identifier**: `vertical_parameter_alignment`

**Rule description**: `Function parameters should be aligned vertically if they're in multiple lines in a declaration.`

**Rule kind**: `Style`

#### Non triggering examples
```
func validateFunction(_ file: File, kind: SwiftDeclarationKind,
                      dictionary: [String: SourceKitRepresentable]) { }
```

```
func validateFunction(_ file: File, kind: SwiftDeclarationKind,
                      dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
```

```
func foo(bar: Int)
```

```
func foo(bar: Int) -> String 
```

```
func validateFunction(_ file: File, kind: SwiftDeclarationKind,
                      dictionary: [String: SourceKitRepresentable])
                      -> [StyleViolation]
```

```
func validateFunction(
   _ file: File, kind: SwiftDeclarationKind,
   dictionary: [String: SourceKitRepresentable]) -> [StyleViolation]
```

```
func validateFunction(
   _ file: File, kind: SwiftDeclarationKind,
   dictionary: [String: SourceKitRepresentable]
) -> [StyleViolation]
```

```
func regex(_ pattern: String,
           options: NSRegularExpression.Options = [.anchorsMatchLines,
                                                   .dotMatchesLineSeparators]) -> NSRegularExpression
```

```
func foo(a: Void,
         b: [String: String] =
           [:]) {
}
```

```
func foo(data: (size: CGSize,
                identifier: String)) {}
```

#### Triggering examples
```
func validateFunction(_ file: File, kind: SwiftDeclarationKind,
                  ↓dictionary: [String: SourceKitRepresentable]) { }
```

```
func validateFunction(_ file: File, kind: SwiftDeclarationKind,
                       ↓dictionary: [String: SourceKitRepresentable]) { }
```

```
func validateFunction(_ file: File,
                  ↓kind: SwiftDeclarationKind,
                  ↓dictionary: [String: SourceKitRepresentable]) { }
```




### <a name="vertical_parameter_alignment_on_call"/>87/89. Vertical Parameter Alignment On Call rule
**Rule identifier**: `vertical_parameter_alignment_on_call`

**Rule description**: `Function parameters should be aligned vertically if they're in multiple lines in a method call.`

**Rule kind**: `Style`

#### Non triggering examples
```
foo(param1: 1, param2: bar
    param3: false, param4: true)
```

```
foo(param1: 1, param2: bar)
```

```
foo(param1: 1, param2: bar
    param3: false,
    param4: true)
```

```
foo(
   param1: 1
) { _ in }
```

```
UIView.animate(withDuration: 0.4, animations: {
    blurredImageView.alpha = 1
}, completion: { _ in
    self.hideLoading()
})
```

```
UIView.animate(withDuration: 0.4, animations: {
    blurredImageView.alpha = 1
},
completion: { _ in
    self.hideLoading()
})
```

```
foo(param1: 1, param2: { _ in },
    param3: false, param4: true)
```

```
foo({ _ in
       bar()
   },
   completion: { _ in
       baz()
   }
)
```

```
foo(param1: 1, param2: [
   0,
   1
], param3: 0)
```

#### Triggering examples
```
foo(param1: 1, param2: bar
                ↓param3: false, param4: true)
```

```
foo(param1: 1, param2: bar
 ↓param3: false, param4: true)
```

```
foo(param1: 1, param2: bar
       ↓param3: false,
       ↓param4: true)
```

```
foo(param1: 1,
       ↓param2: { _ in })
```

```
foo(param1: 1,
    param2: { _ in
}, param3: 2,
 ↓param4: 0)
```

```
foo(param1: 1, param2: { _ in },
       ↓param3: false, param4: true)
```




### <a name="vertical_whitespace"/>88/89. Vertical Whitespace rule (autocorrectable)
**Rule identifier**: `vertical_whitespace`

**Rule description**: `Limit vertical whitespace to a single empty line.`

**Rule kind**: `Style`

#### Non triggering examples
```
let abc = 0
```

```
let abc = 0

```

```
/* bcs 



*/
```

```
// bca 

```

#### Triggering examples
```
let aaaa = 0


```

```
struct AAAA {}



```

```
class BBBB {}


```

#### Corrections
```
// bca 


->
// bca 

```

```
let c = 0


let num = 1
->
let c = 0

let num = 1
```

```
let b = 0


class AAA {}
->
let b = 0

class AAA {}
```




### <a name="weak_delegate"/>89/89. Weak Delegate rule
**Rule identifier**: `weak_delegate`

**Rule description**: `Delegates should be weak to avoid reference cycles.`

**Rule kind**: `Lint`

#### Non triggering examples
```
class Foo {
  weak var delegate: SomeProtocol?
}
```

```
class Foo {
  weak var someDelegate: SomeDelegateProtocol?
}
```

```
class Foo {
  weak var delegateScroll: ScrollDelegate?
}
```

```
class Foo {
  var scrollHandler: ScrollDelegate?
}
```

```
func foo() {
  var delegate: SomeDelegate
}
```

```
class Foo {
  var delegateNotified: Bool?
}
```

```
protocol P {
 var delegate: AnyObject? { get set }
}
```

```
class Foo {
 protocol P {
 var delegate: AnyObject? { get set }
}
}
```

```
class Foo {
 var computedDelegate: ComputedDelegate {
 return bar() 
} 
}
```

#### Triggering examples
```
class Foo {
  ↓var delegate: SomeProtocol?
}
```

```
class Foo {
  ↓var scrollDelegate: ScrollDelegate?
}
```

