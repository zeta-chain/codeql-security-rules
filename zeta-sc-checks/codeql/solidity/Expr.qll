/**
 * Provides classes modeling C/C++ expressions.
 */

// import semmle.code.cpp.Element
// private import semmle.code.cpp.Enclosing
// private import semmle.code.cpp.internal.ResolveClass
// private import semmle.code.cpp.internal.AddressConstantExpression
private import codeql.solidity.ast.AST
// import codeql.solidity.Enclosing
// import codeql.solidity.ast.internal.TreeSitter
// import codeql.solidity.ast.Stmt
import codeql.solidity.Enclosing


/**
 * A Solidity expression.
 *
 * This is the root QL class for all expressions.
 */
  class Expression extends AstNode, ControlFlowNode, TExpr {

  /** Gets the number of direct children of this expression. */
  int getNumChild() { result = count(this.getAChild()) }

  /** Holds if e is the nth child of this expression. */
  predicate hasChild(Expression e, int n) { e = this.getChild(n) }

  /** Gets the enclosing function of this expression, if any. */
  Function getEnclosingFunction() { 
    result = exprEnclosingElement(this) or result.getBlock() = exprEnclosingElement(this) }

  /** Gets the nearest enclosing set of curly braces around this expression in the source, if any. */
  BlockStmt getEnclosingBlock() { result = this.getEnclosingStmt().getEnclosingBlock() }

  // override Stmt getEnclosingStmt() {
  override Stmt getEnclosingStmt() {
    result = this.getParent().(Expression).getEnclosingStmt()
    or
    result = this.getParent()
    or
    // exists(Expression other | result = other.getEnclosingStmt() and other.getConversion() = this)
    exists(Expression other | result = other.getEnclosingStmt() and other = this)
    // or
    // exists(DeclStmt d, LocalVariable v |
    //   d.getADeclaration() = v and v.getInitializer().getExpr() = this and result = d
    // )
    // or
    // exists(ConditionDeclExpr cde, LocalVariable v |
    //   cde.getVariable() = v and
    //   v.getInitializer().getExpr() = this and
    //   result = cde.getEnclosingStmt()
    // )
  }

  // /** Gets the enclosing variable of this expression, if any. */
  // Variable getEnclosingVariable() { result = exprEnclosingElement(this) }

  // /** Gets the enclosing variable or function of this expression. */
  // Declaration getEnclosingDeclaration() { result = exprEnclosingElement(this) }

  /** Gets a child of this expression. */
  override Expression getAChild() { result = this.getChild(_) }

  // /** Gets the parent of this expression, if any. */
  // Element getParent() { exprparents(underlyingElement(this), _, unresolveElement(result)) }

  // /**
  //  * Gets the `n`th compiler-generated destructor call that is performed after this expression, in
  //  * order of destruction.
  //  */
  // DestructorCall getImplicitDestructorCall(int n) {
  //   exists(Expr e |
  //     e = this.(TemporaryObjectExpr).getExpr() and
  //     synthetic_destructor_call(e, max(int i | synthetic_destructor_call(e, i, _)) - n, result)
  //   )
  //   or
  //   not this = any(TemporaryObjectExpr temp).getExpr() and
  //   synthetic_destructor_call(this, max(int i | synthetic_destructor_call(this, i, _)) - n, result)
  // }

  // /**
  //  * Gets a compiler-generated destructor call that is performed after this expression.
  //  */
  // DestructorCall getAnImplicitDestructorCall() { synthetic_destructor_call(this, _, result) }

  // /** Gets the location of this expression. */
  // override Location getLocation() {
  //   result = this.getExprLocationOverride()
  //   or
  //   not exists(this.getExprLocationOverride()) and
  //   result = this.getDbLocation()
  // }

  // /**
  //  * Gets a location for this expression that's more accurate than
  //  * `getDbLocation()`, if any.
  //  */
  // private Location getExprLocationOverride() {
  //   // Base case: the parent has a better location than `this`.
  //   this.getDbLocation() instanceof UnknownExprLocation and
  //   result = this.getParent().(Expr).getDbLocation() and
  //   not result instanceof UnknownLocation
  //   or
  //   // Recursive case: the parent has a location override that's better than
  //   // what `this` has.
  //   this.getDbLocation() instanceof UnknownExprLocation and
  //   result = this.getParent().(Expr).getExprLocationOverride() and
  //   not result instanceof UnknownLocation
  // }

  // /** Gets the location of this expressions, raw from the database. */
  // private Location getDbLocation() { exprs(underlyingElement(this), _, result) }

  // /**
  //  * Gets the type of this expression.
  //  *
  //  * As the type of an expression can sometimes be a TypedefType, calling getUnderlyingType()
  //  * is often more useful than calling this predicate.
  //  */
  // pragma[nomagic]
  // cached
  // Type getType() { expr_types(underlyingElement(this), unresolveElement(result), _) }

  // /**
  //  * Gets the type of this expression after typedefs have been resolved.
  //  *
  //  * In most cases, this predicate will be the same as getType().  It will
  //  * only differ when the result of getType() is a TypedefType, in which
  //  * case this predicate will (possibly recursively) resolve the typedef.
  //  */
  // Type getUnderlyingType() { result = this.getType().getUnderlyingType() }

  // /**
  //  * Gets the type of this expression after specifiers have been deeply
  //  * stripped and typedefs have been resolved.
  //  */
  // Type getUnspecifiedType() { result = this.getType().getUnspecifiedType() }

  /** Gets a textual representation of this expression. */
  override string toString() { none() }

  // /** Gets the value of this expression, if it is a constant. */
  // string getValue() {
  //   exists(@value v | values(v, result) and valuebind(v, underlyingElement(this)))
  // }

  // /** Gets the value text of this expression that's in the database. */
  // private string getDbValueText() {
  //   exists(@value v | valuebind(v, underlyingElement(this)) and valuetext(v, result))
  // }

  // /**
  //  * Gets the value text of `this`. If it doesn't have one, then instead
  //  * gets the value text is `this`'s nearest compatible conversion, if any.
  //  */
  // private string getValueTextFollowingConversions() {
  //   if exists(this.getDbValueText())
  //   then result = this.getDbValueText()
  //   else
  //     exists(Expr e |
  //       e = this.getConversion() and
  //       e.getValue() = this.getValue() and
  //       result = e.getValueTextFollowingConversions()
  //     )
  // }

  // /** Gets the source text for the value of this expression, if it is a constant. */
  // string getValueText() {
  //   if exists(this.getValueTextFollowingConversions())
  //   then result = this.getValueTextFollowingConversions()
  //   else result = this.getValue()
  // }

  // /**
  //  * Holds if this expression has a value that can be determined at compile time.
  //  *
  //  * An expression has a value that can be determined at compile time when:
  //  * - it is a compile-time constant, e.g., a literal value or the result of a constexpr
  //  *   compile-time constant;
  //  * - it is an address of a (member) function, an address of a constexpr variable
  //  *   initialized to a constant address, or an address of an lvalue, or any of the
  //  *   previous with a constant value added to or subtracted from the address;
  //  * - it is a reference to a (member) function, a reference to a constexpr variable
  //  *   initialized to a constant address, or a reference to an lvalue;
  //  * - it is a non-template parameter of a uninstantiated template.
  //  */
  // cached
  // predicate isConstant() {
  //   valuebind(_, underlyingElement(this))
  //   or
  //   addressConstantExpression(this)
  //   or
  //   constantTemplateLiteral(this)
  // }

  /**
   * Holds if this expression is side-effect free (conservative
   * approximation). This predicate cannot be overridden;
   * override mayBeImpure() instead.
   *
   * Note that this predicate does not strictly correspond with
   * the usual definition of a 'pure' function because reading
   * from global state is permitted, just not writing / output.
   */
  final predicate isPure() { not this.mayBeImpure() }

  /**
   * Holds if it is possible that the expression may be impure. If we are not
   * sure, then it holds.
   */
  predicate mayBeImpure() { any() }

  /**
   * Holds if it is possible that the expression may be impure. If we are not
   * sure, then it holds. Unlike `mayBeImpure()`, this predicate does not
   * consider modifications to temporary local variables to be impure. If you
   * call a function in which nothing may be globally impure then the function
   * as a whole will have no side-effects, even if it mutates its own fresh
   * stack variables.
   */
  predicate mayBeGloballyImpure() { any() }

  // /**
  //  * Holds if this expression is an _lvalue_. An _lvalue_ is an expression that
  //  * represents a location, rather than a value.
  //  * See [basic.lval] for more about lvalues.
  //  */
  // predicate isLValueCategory() { expr_types(underlyingElement(this), _, 3) }

  // /**
  //  * Holds if this expression is an _xvalue_. An _xvalue_ is a location whose
  //  * lifetime is about to end (e.g. an _rvalue_ reference returned from a function
  //  * call).
  //  * See [basic.lval] for more about xvalues.
  //  */
  // predicate isXValueCategory() { expr_types(underlyingElement(this), _, 2) }

  // /**
  //  * Holds if this expression is a _prvalue_. A _prvalue_ is an expression that
  //  * represents a value, rather than a location.
  //  * See [basic.lval] for more about prvalues.
  //  */
  // predicate isPRValueCategory() { expr_types(underlyingElement(this), _, 1) }

  // /**
  //  * Holds if this expression is a _glvalue_. A _glvalue_ is either an _lvalue_ or an
  //  * _xvalue_.
  //  */
  // predicate isGLValueCategory() { this.isLValueCategory() or this.isXValueCategory() }

  // /**
  //  * Holds if this expression is an _rvalue_. An _rvalue_ is either a _prvalue_ or an
  //  * _xvalue_.
  //  */
  // predicate isRValueCategory() { this.isPRValueCategory() or this.isXValueCategory() }

  // /**
  //  * Gets a string representation of the value category of the expression.
  //  * This is intended only for debugging. The possible values are:
  //  *
  //  * - "lvalue"
  //  * - "xvalue"
  //  * - "prvalue"
  //  * - "prvalue(load)"
  //  *
  //  * The "prvalue(load)" string is used when the expression is a _prvalue_, but
  //  * `hasLValueToRvalueConversion()` holds.
  //  */
  // string getValueCategoryString() {
  //   this.isLValueCategory() and
  //   result = "lvalue"
  //   or
  //   this.isXValueCategory() and
  //   result = "xvalue"
  //   or
  //   (
  //     this.isPRValueCategory() and
  //     if this.hasLValueToRValueConversion() then result = "prvalue(load)" else result = "prvalue"
  //   )
  // }

  // /**
  //  * Gets the parent of this expression, if any, in an alternative syntax tree
  //  * that has `Conversion`s as part of the tree.
  //  */
  // Element getParentWithConversions() { convparents(this, _, result) }

  // /**
  //  * Holds if this expression will not be evaluated because of its context,
  //  * such as an expression inside a sizeof.
  //  */
  // predicate isUnevaluated() {
  //   exists(Element e | e = this.getParentWithConversions+() |
  //     e instanceof SizeofOperator
  //     or
  //     exists(Expr e2 |
  //       e.(TypeidOperator).getExpr() = e2 and
  //       (
  //         not e2.getFullyConverted().getUnspecifiedType().(Class).isPolymorphic() or
  //         not e2.isGLValueCategory()
  //       )
  //     )
  //     or
  //     e instanceof NoExceptExpr
  //     or
  //     e instanceof AlignofOperator
  //   )
  //   or
  //   exists(Decltype d | d.getExpr() = this.getParentWithConversions*())
  // }

  // /**
  //  * Holds if this expression has undergone an _lvalue_-to-_rvalue_ conversion to
  //  * extract its value.
  //  * for example:
  //  * ```
  //  *  y = x;
  //  * ```
  //  * The `VariableAccess` for `x` is a _prvalue_, and `hasLValueToRValueConversion()`
  //  * holds because the value of `x` was loaded from the location of `x`.
  //  * The `VariableAccess` for `y` is an _lvalue_, and `hasLValueToRValueConversion()`
  //  * does not hold because the value of `y` was not extracted.
  //  *
  //  * See [conv.lval] for more about the _lvalue_-to-_rvalue_ conversion
  //  */
  // predicate hasLValueToRValueConversion() { expr_isload(underlyingElement(this)) }

  // /**
  //  * Holds if this expression is an _lvalue_, in the sense of having an address.
  //  *
  //  * Being an _lvalue_ is best approximated as having an address.
  //  * This is a strict superset of modifiable _lvalue_s, which are best approximated by things which could be on the left-hand side of an assignment.
  //  * This is also a strict superset of expressions which provide an _lvalue_, which is best approximated by things whose address is important.
  //  *
  //  * See [basic.lval] in the C++ language specification.
  //  * In C++03, every expression is either an _lvalue_ or an _rvalue_.
  //  * In C++11, every expression is exactly one of an _lvalue_, an _xvalue_, or a _prvalue_ (with _rvalue_s being the union of _xvalue_s and _prvalue_s).
  //  * Using the C++11 terminology, this predicate selects expressions whose value category is _lvalue_.
  //  */
  // predicate isLValue() {
  //   // C++ n3337 - 5.1.1 clause 1
  //   this instanceof StringLiteral
  //   or
  //   // C++ n3337 - 5.1.1 clause 6
  //   this.(ParenthesisExpr).getExpr().isLValue()
  //   or
  //   // C++ n3337 - 5.1.1 clauses 8 and 9, variables and data members
  //   this instanceof VariableAccess and not this instanceof FieldAccess
  //   or
  //   // C++ n3337 - 5.1.1 clauses 8 and 9, functions
  //   exists(FunctionAccess fa | fa = this |
  //     fa.getTarget().isStatic()
  //     or
  //     not fa.getTarget().isMember()
  //   )
  //   or
  //   // C++ n3337 - 5.2.1 clause 1
  //   this instanceof ArrayExpr
  //   or
  //   // C++ n3337 - 5.2.2 clause 10
  //   //             5.2.5 clause 4, no bullet point
  //   //             5.2.7 clauses 2 and 5
  //   //             5.2.9 clause 1
  //   //             5.2.10 clause 1
  //   //             5.2.11 clause 1
  //   //             5.4 clause 1
  //   this.getType() instanceof ReferenceType
  //   or
  //   // C++ n3337 - 5.2.5 clause 4, 2nd bullet point
  //   this.(FieldAccess).getQualifier().isLValue()
  //   or
  //   // C++ n3337 - 5.2.8 clause 1
  //   this instanceof TypeidOperator
  //   or
  //   // C++ n3337 - 5.3.1 clause 1
  //   this instanceof PointerDereferenceExpr
  //   or
  //   // C++ n3337 - 5.3.2 clause 1
  //   this instanceof PrefixIncrExpr
  //   or
  //   // C++ n3337 - 5.3.2 clause 2
  //   this instanceof PrefixDecrExpr
  //   or
  //   // C++ n3337 - 5.16 clause 4
  //   exists(ConditionalExpr ce | ce = this |
  //     ce.getThen().isLValue() and
  //     ce.getElse().isLValue() and
  //     ce.getThen().getType() = ce.getElse().getType()
  //   )
  //   or
  //   // C++ n3337 - 5.17 clause 1
  //   this instanceof Assignment
  //   or
  //   // C++ n3337 - 5.18 clause 1
  //   this.(CommaExpr).getRightOperand().isLValue()
  // }

  /**
   * Gets the precedence of the main operator of this expression;
   * higher precedence binds tighter.
   */
  int getPrecedence() { none() }

  // /**
  //  * Holds if this expression has a conversion.
  //  *
  //  * Type casts and parameterized expressions are not part of the main
  //  * expression tree structure but attached on the nodes they convert,
  //  * for example:
  //  * ```
  //  *  2 + (int)(bool)1
  //  * ```
  //  * has the main tree:
  //  * ```
  //  *  2 + 1
  //  * ```
  //  * and 1 has a bool conversion, while the bool conversion itself has
  //  * an int conversion.
  //  */
  // predicate hasConversion() {
  //   exists(Expr e | exprconv(underlyingElement(this), unresolveElement(e)))
  // }

  // /**
  //  * Holds if this expression has an implicit conversion.
  //  *
  //  * For example in `char *str = 0`, the `0` has an implicit conversion to type `char *`.
  //  */
  // predicate hasImplicitConversion() {
  //   exists(Expr e |
  //     exprconv(underlyingElement(this), unresolveElement(e)) and e.(Conversion).isImplicit()
  //   )
  // }

  // /**
  //  * Holds if this expression has an explicit conversion.
  //  *
  //  * For example in `(MyClass *)ptr`, the `ptr` has an explicit
  //  * conversion to type `MyClass *`.
  //  */
  // predicate hasExplicitConversion() {
  //   exists(Expr e |
  //     exprconv(underlyingElement(this), unresolveElement(e)) and not e.(Conversion).isImplicit()
  //   )
  // }

  // /**
  //  * Gets the conversion associated with this expression, if any.
  //  */
  // Expr getConversion() { exprconv(underlyingElement(this), unresolveElement(result)) }

  // /**
  //  * Gets a string describing the conversion associated with this expression,
  //  * or "" if there is none.
  //  */
  // string getConversionString() {
  //   result = this.getConversion().toString() and this.hasConversion()
  //   or
  //   result = "" and not this.hasConversion()
  // }

  // /** Gets the fully converted form of this expression, including all type casts and other conversions. */
  // cached
  // Expr getFullyConverted() {
  //   hasNoConversions(this) and
  //   result = this
  //   or
  //   result = this.getConversion().getFullyConverted()
  // }

  // /**
  //  * Gets this expression with all of its explicit casts, but none of its
  //  * implicit casts. More precisely this takes conversions up to the last
  //  * explicit cast (there may be implicit conversions along the way), but does
  //  * not include conversions after the last explicit cast.
  //  *
  //  * C++ example: `C c = (B)d` might have three casts: (1) an implicit cast
  //  * from A to some D, (2) an explicit cast from D to B, and (3) an implicit
  //  * cast from B to C. Only (1) and (2) would be included.
  //  */
  // Expr getExplicitlyConverted() {
  //   // For performance, we avoid a full transitive closure over `getConversion`.
  //   // Since there can be several implicit conversions before and after an
  //   // explicit conversion, use `getImplicitlyConverted` to step over them
  //   // cheaply. Then, if there is an explicit conversion following the implicit
  //   // conversion sequence, recurse to handle multiple explicit conversions.
  //   if this.getImplicitlyConverted().hasExplicitConversion()
  //   then result = this.getImplicitlyConverted().getConversion().getExplicitlyConverted()
  //   else result = this
  // }

  // /**
  //  * Gets this expression with all of its initial implicit casts, but none of
  //  * its explicit casts. More precisely, this takes all implicit conversions
  //  * up to (but not including) the first explicit cast (if any).
  //  */
  // Expr getImplicitlyConverted() {
  //   if this.hasImplicitConversion()
  //   then result = this.getConversion().getImplicitlyConverted()
  //   else result = this
  // }

  // /**
  //  * Gets the unique non-`Conversion` expression `e` for which
  //  * `this = e.getConversion*()`.
  //  *
  //  * For example, if called on the expression `(int)(char)x`, this predicate
  //  * gets the expression `x`.
  //  */
  // Expr getUnconverted() {
  //   not this instanceof Conversion and
  //   result = this
  //   or
  //   result = this.(Conversion).getExpr().getUnconverted()
  // }

  // /**
  //  * Gets the type of this expression, after any implicit conversions and explicit casts, and after resolving typedefs.
  //  *
  //  * As an example, consider the AST fragment `(i64)(void*)0` in the context of `typedef long long i64;`. The fragment
  //  * contains three expressions: two CStyleCasts and one literal Zero. For all three expressions, the result of this
  //  * predicate will be `long long`.
  //  */
  // Type getActualType() { result = this.getFullyConverted().getType().getUnderlyingType() }

  // /** Holds if this expression is parenthesised. */
  // predicate isParenthesised() { this.getConversion() instanceof ParenthesisExpr }

  /** Gets the function containing this control-flow node. */
  override Function getControlFlowScope() { result = this.getEnclosingFunction() }
}

// /**
//  * A C/C++ operation.
//  *
//  * This is the QL root class for all operations.
//  */
// class Operation extends Expr, @op_expr {
//   /** Gets the operator of this operation. */
//   string getOperator() { none() }

//   /** Gets an operand of this operation. */
//   Expr getAnOperand() { result = this.getAChild() }
// }

/**
 * A Solidity unary operation.
 */
class UnaryExpression extends Expression, TUnaryExpression {
  private Solidity::UnaryExpression node;

  UnaryExpression(){node = toTreeSitter(this)}

  string getOperator(){result = node.getOperator()}

  /** Gets the operand of this unary operation. */
  Expression getOperand() { this.hasChild(result, 0) }

  override string toString() { result = this.getOperator() + " ..." }

  override predicate mayBeImpure() { this.getOperand().mayBeImpure() }

  override predicate mayBeGloballyImpure() { this.getOperand().mayBeGloballyImpure() }
}

/**
 * A Solidity binary operation.
 */
class BinaryExpression extends Expression, TBinaryExpression {
  private Solidity::BinaryExpression node;

  BinaryExpression(){node = toTreeSitter(this)}

  /** Gets the left operand of this binary operation. */
  Expression getLeftOperand() { toTreeSitter(result) = node.getLeft() }

  /** Gets the right operand of this binary operation. */
  Expression getRightOperand() { toTreeSitter(result) = node.getRight() }

  /**
   * Holds if `e1` and `e2` (in either order) are the two operands of this
   * binary operation.
   */
  // predicate hasOperands(Expression e1, Expression e2) {
  //   exists(int i | i in [0, 1] |
  //     this.hasChild(e1, i) and
  //     this.hasChild(e2, 1 - i)
  //   )
  // }
  predicate hasOperands(Expression e1, Expression e2){
    (this.getLeftOperand() = e1 and this.getRightOperand() = e2)
    or
    (this.getLeftOperand() = e2 and this.getRightOperand() = e1)
  }

  string getOperator(){result = node.getOperator()}

  override string toString() { result = "... " + this.getOperator() + " ..." }

  override predicate mayBeImpure() {
    this.getLeftOperand().mayBeImpure() or
    this.getRightOperand().mayBeImpure()
  }

  override predicate mayBeGloballyImpure() {
    this.getLeftOperand().mayBeGloballyImpure() or
    this.getRightOperand().mayBeGloballyImpure()
  }
}

// /**
//  * A C++11 parenthesized braced initializer list within a template.
//  *
//  * This is used to represent particular syntax within templates where the final
//  * form of the expression is not known. In actual instantiations, it will have
//  * been turned into either a constructor call or an aggregate initializer or similar.
//  * ```
//  * template <typename T>
//  * struct S {
//  *   T member;
//  *   S() { member = T({ arg1, arg2 }); }
//  * };
//  * ```
//  */
// class ParenthesizedBracedInitializerList extends Expr, @braced_init_list {
//   override string toString() { result = "({...})" }

//   override string getAPrimaryQlClass() { result = "ParenthesizedBracedInitializerList" }
// }

// /**
//  * A C/C++ parenthesis expression.
//  *
//  * It is typically used to raise the syntactic precedence of the subexpression that
//  * it contains.  For example:
//  * ```
//  * int d = a & ( b | c );
//  * ```
//  */
// class ParenthesisExpr extends Conversion, @parexpr {
//   override string toString() { result = "(...)" }

//   override string getAPrimaryQlClass() { result = "ParenthesisExpr" }
// }

// /**
//  * A C/C++ expression that could not be resolved, or that can no longer be
//  * represented due to a database upgrade or downgrade.
//  *
//  * If the expression could not be resolved, it has type `ErroneousType`. In the
//  * case of a database upgrade or downgrade, the original type from before the
//  * upgrade or downgrade is kept if that type can be represented.
//  */
// class ErrorExpr extends Expr, @errorexpr {
//   override string toString() { result = "<error expr>" }

//   override string getAPrimaryQlClass() { result = "ErrorExpr" }
// }

// /**
//  * A Microsoft C/C++ __assume expression.
//  *
//  * Unlike `assert`, `__assume` is evaluated at compile time and
//  * is treated as a hint to the optimizer
//  * ```
//  * __assume(ptr < end_buf);
//  * ```
//  */
// class AssumeExpr extends Expr, @assume {
//   override string toString() { result = "__assume(...)" }

//   override string getAPrimaryQlClass() { result = "AssumeExpr" }

//   /**
//    * Gets the operand of the `__assume` expressions.
//    */
//   Expr getOperand() { this.hasChild(result, 0) }
// }

// /**
//  * A C/C++ comma expression.
//  * ```
//  * int c = compute1(), compute2(), resulting_value;
//  * ```
//  */
// class CommaExpr extends Expr, @commaexpr {
//   override string getAPrimaryQlClass() { result = "CommaExpr" }

//   /**
//    * Gets the left operand, which is the one whose value is discarded.
//    */
//   Expr getLeftOperand() { this.hasChild(result, 0) }

//   /**
//    * Gets the right operand, which is the one whose value is equal to the value
//    * of the comma expression itself.
//    */
//   Expr getRightOperand() { this.hasChild(result, 1) }

//   override string toString() { result = "... , ..." }

//   override int getPrecedence() { result = 0 }

//   override predicate mayBeImpure() {
//     this.getLeftOperand().mayBeImpure() or
//     this.getRightOperand().mayBeImpure()
//   }

//   override predicate mayBeGloballyImpure() {
//     this.getLeftOperand().mayBeGloballyImpure() or
//     this.getRightOperand().mayBeGloballyImpure()
//   }
// }

// /**
//  * A C/C++ address-of expression.
//  * ```
//  * int *ptr = &var;
//  * ```
//  */
// class AddressOfExpr extends UnaryOperation, @address_of {
//   override string getAPrimaryQlClass() { result = "AddressOfExpr" }

//   /** Gets the function or variable whose address is taken. */
//   Declaration getAddressable() {
//     result = this.getOperand().(Access).getTarget()
//     or
//     // this handles the case where we are taking the address of a reference variable
//     result = this.getOperand().(ReferenceDereferenceExpr).getChild(0).(Access).getTarget()
//   }

//   override string getOperator() { result = "&" }

//   override int getPrecedence() { result = 16 }

//   override predicate mayBeImpure() { this.getOperand().mayBeImpure() }

//   override predicate mayBeGloballyImpure() { this.getOperand().mayBeGloballyImpure() }
// }

// /**
//  * An implicit conversion from type `T` to type `T &`.
//  *
//  * This typically occurs when an expression of type `T` is used to initialize a variable or parameter of
//  * type `T &`, and is to reference types what `AddressOfExpr` is to pointer types, though this class is
//  * considered to be a conversion rather than an operation, and as such doesn't occur in the main AST.
//  * ```
//  * int &var_ref = var;
//  * ```
//  */
// class ReferenceToExpr extends Conversion, @reference_to {
//   override string toString() { result = "(reference to)" }

//   override string getAPrimaryQlClass() { result = "ReferenceToExpr" }

//   override int getPrecedence() { result = 16 }
// }

// /**
//  * An instance of the built-in unary `operator *` applied to a type.
//  *
//  * For user-defined overloads of `operator *`, see `OverloadedPointerDereferenceExpr`.
//  * ```
//  * int var = *varptr;
//  * ```
//  */
// class PointerDereferenceExpr extends UnaryOperation, @indirect {
//   override string getAPrimaryQlClass() { result = "PointerDereferenceExpr" }

//   override string getOperator() { result = "*" }

//   override int getPrecedence() { result = 16 }

//   override predicate mayBeImpure() {
//     this.getChild(0).mayBeImpure() or
//     this.getChild(0).getFullyConverted().getType().(DerivedType).getBaseType().isVolatile()
//   }

//   override predicate mayBeGloballyImpure() {
//     this.getChild(0).mayBeGloballyImpure() or
//     this.getChild(0).getFullyConverted().getType().(DerivedType).getBaseType().isVolatile()
//   }
// }

// /**
//  * An implicit conversion from type `T &` to type `T`.
//  *
//  * This typically occurs when an variable of type `T &` is used in a context which expects type `T`, and
//  * is to reference types what `PointerDereferenceExpr` is to pointer types - though this class is
//  * considered to be a conversion rather than an operation, and as such doesn't occur in the main AST.
//  * ```
//  * float &f_ref = get_ref();
//  * float f = f_ref;
//  * ```
//  */
// class ReferenceDereferenceExpr extends Conversion, @ref_indirect {
//   override string toString() { result = "(reference dereference)" }

//   override string getAPrimaryQlClass() { result = "ReferenceDereferenceExpr" }
// }

// /**
//  * A C++ `new` or `new[]` expression.
//  */
// class NewOrNewArrayExpr extends Expr, @any_new_expr {
//   override int getPrecedence() { result = 16 }

//   /**
//    * Gets the `operator new` or `operator new[]` that allocates storage.
//    */
//   Function getAllocator() { expr_allocator(underlyingElement(this), unresolveElement(result), _) }

//   /**
//    * Holds if the allocation function is the version that expects an alignment
//    * argument of type `std::align_val_t`.
//    */
//   predicate hasAlignedAllocation() { expr_allocator(underlyingElement(this), _, 1) }

//   /**
//    * Gets the alignment argument passed to the allocation function, if any.
//    */
//   Expr getAlignmentArgument() {
//     this.hasAlignedAllocation() and
//     (
//       // If we have an allocator call, the alignment is the second argument to
//       // that call.
//       result = this.getAllocatorCall().getArgument(1)
//       or
//       // Otherwise, the alignment winds up as child number 3 of the `new`
//       // itself.
//       result = this.getChild(3)
//     )
//   }

//   /**
//    * Gets the call to a non-default `operator new` that allocates storage, if any.
//    *
//    * As a rule of thumb, there will be an allocator call precisely when the type
//    * being allocated has a custom `operator new`, or when an argument list appears
//    * after the `new` keyword and before the name of the type being allocated.
//    *
//    * In particular note that uses of placement-new and nothrow-new will have an
//    * allocator call.
//    */
//   FunctionCall getAllocatorCall() { result = this.getChild(0) }

//   /**
//    * Gets the `operator delete` that deallocates storage if the initialization
//    * throws an exception, if any.
//    */
//   Function getDeallocator() {
//     expr_deallocator(underlyingElement(this), unresolveElement(result), _)
//   }

//   /**
//    * Holds if the deallocation function expects a size argument.
//    */
//   predicate hasSizedDeallocation() {
//     exists(int form |
//       expr_deallocator(underlyingElement(this), _, form) and
//       form.bitAnd(1) != 0 // Bit zero is the "size" bit
//     )
//   }

//   /**
//    * Holds if the deallocation function expects an alignment argument.
//    */
//   predicate hasAlignedDeallocation() {
//     exists(int form |
//       expr_deallocator(underlyingElement(this), _, form) and
//       form.bitAnd(2) != 0 // Bit one is the "alignment" bit
//     )
//   }

//   /**
//    * Gets the type that is being allocated.
//    *
//    * For example, for `new int` the result is `int`.
//    * For `new int[5]` the result is `int[5]`.
//    */
//   Type getAllocatedType() { none() } // overridden in subclasses

//   /**
//    * Gets the pointer `p` if this expression is of the form `new(p) T...`.
//    * Invocations of this form are non-allocating `new` expressions that may
//    * call the constructor of `T` but will not allocate memory.
//    */
//   Expr getPlacementPointer() {
//     result =
//       this.getAllocatorCall()
//           .getArgument(this.getAllocator().(OperatorNewAllocationFunction).getPlacementArgument())
//   }

//   /**
//    * For `operator new`, this gets the call or expression that initializes the allocated object, if any.
//    *
//    * As examples, for `new int(4)`, this will be `4`, and for `new std::vector(4)`, this will
//    * be a call to the constructor `std::vector::vector(size_t)` with `4` as an argument.
//    *
//    * For `operator new[]`, this gets the call or expression that initializes the first element of the
//    * array, if any.
//    *
//    * This will either be a call to the default constructor for the array's element type (as
//    * in `new std::string[10]`), or a literal zero for arrays of scalars which are zero-initialized
//    * due to extra parentheses (as in `new int[10]()`).
//    *
//    * At runtime, the constructor will be called once for each element in the array, but the
//    * constructor call only exists once in the AST.
//    */
//   final Expr getInitializer() { result = this.getChild(1) }
// }

// /**
//  * A C++ `new` (non-array) expression.
//  * ```
//  * Foo *ptr = new Foo(3);
//  * ```
//  */
// class NewExpr extends NewOrNewArrayExpr, @new_expr {
//   override string toString() { result = "new" }

//   override string getAPrimaryQlClass() { result = "NewExpr" }

//   /**
//    * Gets the type that is being allocated.
//    *
//    * For example, for `new int` the result is `int`.
//    */
//   override Type getAllocatedType() {
//     new_allocated_type(underlyingElement(this), unresolveElement(result))
//   }
// }

// /**
//  * A C++ `new[]` (array) expression.
//  * ```
//  * Foo *foo = new Foo[]{1, 3, 5};
//  * Bar *bar = new Bar[5];
//  * ```
//  */
// class NewArrayExpr extends NewOrNewArrayExpr, @new_array_expr {
//   override string toString() { result = "new[]" }

//   override string getAPrimaryQlClass() { result = "NewArrayExpr" }

//   /**
//    * Gets the type that is being allocated.
//    *
//    * For example, for `new int[5]` the result is `int[5]`.
//    */
//   override Type getAllocatedType() {
//     new_array_allocated_type(underlyingElement(this), unresolveElement(result))
//   }

//   /**
//    * Gets the element type of the array being allocated.
//    */
//   Type getAllocatedElementType() {
//     result = this.getType().getUnderlyingType().(PointerType).getBaseType()
//   }

//   /**
//    * Gets the extent of the non-constant array dimension, if any.
//    *
//    * As examples, for `new char[n]` and `new char[n][10]`, this gives `n`, but for `new char[10]` this
//    * gives nothing, as the 10 is considered part of the type.
//    */
//   Expr getExtent() { result = this.getChild(2) }

//   /**
//    * Gets the number of elements in the array, if available.
//    *
//    * For example, `new int[]{1,2,3}` has an array size of 3.
//    */
//   int getArraySize() {
//     result = this.getAllocatedType().(ArrayType).getArraySize() or
//     result = this.getInitializer().(ArrayAggregateLiteral).getArraySize()
//   }
// }

// private class TDeleteOrDeleteArrayExpr = @delete_expr or @delete_array_expr;

// /**
//  * A C++ `delete` or `delete[]` expression.
//  */
// class DeleteOrDeleteArrayExpr extends Expr, TDeleteOrDeleteArrayExpr {
//   override int getPrecedence() { result = 16 }

//   /**
//    * Gets the call to a destructor that occurs prior to the object's memory being deallocated, if any.
//    *
//    * In the case of `delete[]` at runtime, the destructor will be called once for each element in the array, but the
//    * destructor call only exists once in the AST.
//    */
//   DestructorCall getDestructorCall() { result = this.getChild(1) }

//   /**
//    * Gets the destructor to be called to destroy the object or array, if any.
//    */
//   Destructor getDestructor() { result = this.getDestructorCall().getTarget() }

//   /**
//    * Gets the `operator delete` or `operator delete[]` that deallocates storage.
//    * Does not hold if the type being destroyed has a virtual destructor. In that case, the
//    * `operator delete` that will be called is determined at runtime based on the
//    * dynamic type of the object.
//    */
//   Function getDeallocator() {
//     expr_deallocator(underlyingElement(this), unresolveElement(result), _)
//   }

//   /**
//    * DEPRECATED: use `getDeallocatorCall` instead.
//    */
//   deprecated FunctionCall getAllocatorCall() { result = this.getChild(0) }

//   /**
//    * Gets the call to a non-default `operator delete`/`delete[]` that deallocates storage, if any.
//    *
//    * This will only be present when the type being deleted has a custom `operator delete` and
//    * does not have a virtual destructor.
//    */
//   FunctionCall getDeallocatorCall() { result = this.getChild(0) }

//   /**
//    * Holds if the deallocation function expects a size argument.
//    */
//   predicate hasSizedDeallocation() {
//     exists(int form |
//       expr_deallocator(underlyingElement(this), _, form) and
//       form.bitAnd(1) != 0 // Bit zero is the "size" bit
//     )
//   }

//   /**
//    * Holds if the deallocation function expects an alignment argument.
//    */
//   predicate hasAlignedDeallocation() {
//     exists(int form |
//       expr_deallocator(underlyingElement(this), _, form) and
//       form.bitAnd(2) != 0 // Bit one is the "alignment" bit
//     )
//   }

//   /**
//    * Gets the object or array being deleted.
//    */
//   Expr getExpr() {
//     // If there is a destructor call, the object being deleted is the qualifier
//     // otherwise it is the third child.
//     exists(Expr exprWithReuse | exprWithReuse = this.getExprWithReuse() |
//       if not exprWithReuse instanceof ReuseExpr
//       then result = exprWithReuse
//       else result = this.getDestructorCall().getQualifier()
//     )
//   }

//   /**
//    * Gets the object or array being deleted, and gets a `ReuseExpr` when there
//    * is a destructor call and the object is also the qualifier of the call.
//    *
//    * For example, given:
//    * ```
//    * struct HasDestructor { ~HasDestructor(); };
//    * struct PlainOldData { int x, char y; };
//    *
//    * void f(HasDestructor* hasDestructor, PlainOldData* pod) {
//    *   delete hasDestructor;
//    *   delete pod;
//    * }
//    * ```
//    * This predicate yields a `ReuseExpr` for `delete hasDestructor`, as the
//    * the deleted expression has a destructor, and that expression is also
//    * the qualifier of the destructor call. In the case of `delete pod` the
//    * predicate does not yield a `ReuseExpr`, as there is no destructor call.
//    */
//   Expr getExprWithReuse() { result = this.getChild(3) }
// }

// /**
//  * A C++ `delete` (non-array) expression.
//  * ```
//  * delete ptr;
//  * ```
//  */
// class DeleteExpr extends DeleteOrDeleteArrayExpr, @delete_expr {
//   override string toString() { result = "delete" }

//   override string getAPrimaryQlClass() { result = "DeleteExpr" }

//   /**
//    * Gets the compile-time type of the object being deleted.
//    */
//   Type getDeletedObjectType() {
//     result =
//       this.getExpr()
//           .getFullyConverted()
//           .getType()
//           .stripTopLevelSpecifiers()
//           .(PointerType)
//           .getBaseType()
//   }
// }

// /**
//  * A C++ `delete[]` (array) expression.
//  * ```
//  * delete[] arr;
//  * ```
//  */
// class DeleteArrayExpr extends DeleteOrDeleteArrayExpr, @delete_array_expr {
//   override string toString() { result = "delete[]" }

//   override string getAPrimaryQlClass() { result = "DeleteArrayExpr" }

//   /**
//    * Gets the element type of the array being deleted.
//    */
//   Type getDeletedElementType() {
//     result =
//       this.getExpr()
//           .getFullyConverted()
//           .getType()
//           .stripTopLevelSpecifiers()
//           .(PointerType)
//           .getBaseType()
//   }
// }

// /**
//  * A compound statement enclosed in parentheses used as an expression (a GNU extension to C/C++).
//  * In the example below, `b` is the return value from the compound statement.
//  * ```
//  * int a = ({ int b = c + d; b; });
//  * ```
//  */
// class StmtExpr extends Expr, @expr_stmt {
//   override string toString() { result = "(statement expression)" }

//   /**
//    * Gets the statement enclosed by this `StmtExpr`.
//    */
//   Stmt getStmt() { result.getParent() = this }

//   override string getAPrimaryQlClass() { result = "StmtExpr" }

//   /**
//    * Gets the result expression of the enclosed statement. For example,
//    * `a+b` is the result expression in this example:
//    *
//    * ```
//    * x = ({ dosomething(); a+b; });
//    * ```
//    */
//   Expr getResultExpr() { result = getStmtResultExpr(this.getStmt()) }
// }

// /** Get the result expression of a statement. (Helper function for StmtExpr.) */
// private Expr getStmtResultExpr(Stmt stmt) {
//   result = stmt.(ExprStmt).getExpr() or
//   result = getStmtResultExpr(stmt.(BlockStmt).getLastStmt())
// }

// /**
//  * A C++ `this` expression.
//  */
// class ThisExpr extends Expr, @thisaccess {
//   override string toString() { result = "this" }

//   override string getAPrimaryQlClass() { result = "ThisExpr" }

//   override predicate mayBeImpure() { none() }

//   override predicate mayBeGloballyImpure() { none() }
// }

// /**
//  * A code block expression, for example:
//  * ```
//  * ^ int (int x, int y) {return x + y;}
//  * ```
//  * Blocks are a language extension supported by Clang, and by Apple's
//  * branch of GCC.
//  */
// class BlockExpr extends Literal {
//   BlockExpr() { code_block(underlyingElement(this), _) }

//   override string toString() { result = "^ { ... }" }

//   /**
//    * Gets the (anonymous) function associated with this code block expression.
//    */
//   Function getFunction() { code_block(underlyingElement(this), unresolveElement(result)) }
// }

// /**
//  * A C++ `throw` expression.
//  * ```
//  * throw Exc(2);
//  * ```
//  */
// class ThrowExpr extends Expr, @throw_expr {
//   /**
//    * Gets the expression that will be thrown, if any. There is no result if
//    * `this` is a `ReThrowExpr`.
//    */
//   Expr getExpr() { result = this.getChild(0) }

//   override string getAPrimaryQlClass() { result = "ThrowExpr" }

//   override string toString() { result = "throw ..." }

//   override int getPrecedence() { result = 1 }
// }

// /**
//  * A C++ `throw` expression with no argument (which causes the current exception to be re-thrown).
//  * ```
//  * throw;
//  * ```
//  */
// class ReThrowExpr extends ThrowExpr {
//   ReThrowExpr() { this.getType() instanceof VoidType }

//   override string getAPrimaryQlClass() { result = "ReThrowExpr" }

//   override string toString() { result = "re-throw exception " }
// }

// /**
//  * A C++11 `noexcept` expression, returning `true` if its subexpression is guaranteed
//  * not to `throw` exceptions.  For example:
//  * ```
//  * if (noexcept(func_1() + func_2())) { }
//  * ```
//  */
// class NoExceptExpr extends Expr, @noexceptexpr {
//   override string toString() { result = "noexcept(...)" }

//   override string getAPrimaryQlClass() { result = "NoExceptExpr" }

//   /**
//    * Gets the expression inside this noexcept expression.
//    */
//   Expr getExpr() { result = this.getChild(0) }
// }

// /**
//  * A C++17 fold expression. This will only appear in an uninstantiated template; any instantiations
//  * of the template will instead contain the sequence of expressions given by expanding the fold.
//  * ```
//  * template < typename... T >
//  * auto sum ( T... t ) { return ( t + ... + 0 ); }
//  * ```
//  */
// class FoldExpr extends Expr, @foldexpr {
//   override string toString() {
//     exists(string op |
//       op = this.getOperatorString() and
//       if this.isUnaryFold()
//       then
//         if this.isLeftFold()
//         then result = "( ... " + op + " pack )"
//         else result = "( pack " + op + " ... )"
//       else
//         if this.isLeftFold()
//         then result = "( init " + op + " ... " + op + " pack )"
//         else result = "( pack " + op + " ... " + op + " init )"
//     )
//   }

//   override string getAPrimaryQlClass() { result = "FoldExpr" }

//   /** Gets the binary operator used in this fold expression, as a string. */
//   string getOperatorString() { fold(underlyingElement(this), result, _) }

//   /** Holds if this is a left-fold expression. */
//   predicate isLeftFold() { fold(underlyingElement(this), _, true) }

//   /** Holds if this is a right-fold expression. */
//   predicate isRightFold() { fold(underlyingElement(this), _, false) }

//   /** Holds if this is a unary fold expression. */
//   predicate isUnaryFold() { this.getNumChild() = 1 }

//   /** Holds if this is a binary fold expression. */
//   predicate isBinaryFold() { this.getNumChild() = 2 }

//   /**
//    * Gets the child expression containing the unexpanded parameter pack.
//    */
//   Expr getPackExpr() {
//     this.isUnaryFold() and
//     result = this.getChild(0)
//     or
//     this.isBinaryFold() and
//     if this.isRightFold() then result = this.getChild(0) else result = this.getChild(1)
//   }

//   /**
//    * If this is a binary fold, gets the expression representing the initial value.
//    */
//   Expr getInitExpr() {
//     this.isBinaryFold() and
//     if this.isRightFold() then result = this.getChild(1) else result = this.getChild(0)
//   }
// }

// /**
//  * Holds if `child` is the `n`th child of `parent` in an alternative syntax
//  * tree that has `Conversion`s as part of the tree.
//  */
// private predicate convparents(Expr child, int idx, Element parent) {
//   child.getConversion() = parent and
//   idx = 0
//   or
//   exists(Expr astChild |
//     exprparents(unresolveElement(astChild), idx, unresolveElement(parent)) and
//     child = astChild.getFullyConverted()
//   )
// }

// // Pulled out for performance. See
// // https://github.com/github/codeql-coreql-team/issues/1044.
// private predicate hasNoConversions(Expr e) { not e.hasConversion() }

// /**
//  * Holds if `e` is a literal of unknown value in a template, or a cast thereof.
//  * We assume that such literals are constant.
//  */
// private predicate constantTemplateLiteral(Expr e) {
//   // Unknown literals in uninstantiated templates could be enum constant
//   // accesses or pointer-to-member literals.
//   e instanceof Literal and
//   e.isFromUninstantiatedTemplate(_) and
//   not exists(e.getValue())
//   or
//   constantTemplateLiteral(e.(Cast).getExpr())
// }

// /**
//  * A C++ three-way comparison operation, also known as the _spaceship
//  * operation_.  This is specific to C++20 and later.
//  * ```
//  * auto c = (a <=> b);
//  * ```
//  */
// class SpaceshipExpr extends BinaryOperation, @spaceshipexpr {
//   override string getAPrimaryQlClass() { result = "SpaceshipExpr" }

//   override int getPrecedence() { result = 11 }

//   override string getOperator() { result = "<=>" }
// }

// /**
//  * A C/C++ `co_await` expression.
//  * ```
//  * co_await foo();
//  * ```
//  */
// class CoAwaitExpr extends UnaryOperation, @co_await {
//   override string getAPrimaryQlClass() { result = "CoAwaitExpr" }

//   override string getOperator() { result = "co_await" }

//   override int getPrecedence() { result = 16 }

//   /**
//    * Gets the Boolean expression that is used to decide if the enclosing
//    * coroutine should be suspended.
//    */
//   Expr getAwaitReady() { result = this.getChild(1) }

//   /**
//    * Gets the expression that represents the resume point if the enclosing
//    * coroutine was suspended.
//    */
//   Expr getAwaitResume() { result = this.getChild(2) }

//   /**
//    * Gets the expression that is evaluated when the enclosing coroutine is
//    * suspended.
//    */
//   Expr getAwaitSuspend() { result = this.getChild(3) }
// }

// /**
//  * A C/C++ `co_yield` expression.
//  * ```
//  * co_yield 1;
//  * ```
//  */
// class CoYieldExpr extends UnaryOperation, @co_yield {
//   override string getAPrimaryQlClass() { result = "CoYieldExpr" }

//   override string getOperator() { result = "co_yield" }

//   override int getPrecedence() { result = 2 }

//   /**
//    * Gets the Boolean expression that is used to decide if the enclosing
//    * coroutine should be suspended.
//    */
//   Expr getAwaitReady() { result = this.getChild(1) }

//   /**
//    * Gets the expression that represents the resume point if the enclosing
//    * coroutine was suspended.
//    */
//   Expr getAwaitResume() { result = this.getChild(2) }

//   /**
//    * Gets the expression that is evaluated when the enclosing coroutine is
//    * suspended.
//    */
//   Expr getAwaitSuspend() { result = this.getChild(3) }
// }

// /**
//  * An expression representing the re-use of another expression.
//  *
//  * In some specific cases an expression may be referred to outside its
//  * original context. A re-use expression wraps any such reference. A
//  * re-use expression can for example occur as the qualifier of an implicit
//  * destructor called on a temporary object, where the original use of the
//  * expression is in the definition of the temporary.
//  */
// class ReuseExpr extends Expr, @reuseexpr {
//   override string getAPrimaryQlClass() { result = "ReuseExpr" }

//   override string toString() { result = "reuse of " + this.getReusedExpr().toString() }

//   /**
//    * Gets the expression that is being re-used.
//    */
//   Expr getReusedExpr() { expr_reuse(underlyingElement(this), unresolveElement(result), _) }

//   override Type getType() { result = this.getReusedExpr().getType() }

//   override predicate isLValueCategory() { expr_reuse(underlyingElement(this), _, 3) }

//   override predicate isXValueCategory() { expr_reuse(underlyingElement(this), _, 2) }

//   override predicate isPRValueCategory() { expr_reuse(underlyingElement(this), _, 1) }
// }
