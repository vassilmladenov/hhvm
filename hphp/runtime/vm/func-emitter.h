/*
   +----------------------------------------------------------------------+
   | HipHop for PHP                                                       |
   +----------------------------------------------------------------------+
   | Copyright (c) 2010-present Facebook, Inc. (http://www.facebook.com)  |
   +----------------------------------------------------------------------+
   | This source file is subject to version 3.01 of the PHP license,      |
   | that is bundled with this package in the file LICENSE, and is        |
   | available through the world-wide-web at the following url:           |
   | http://www.php.net/license/3_01.txt                                  |
   | If you did not receive a copy of the PHP license and are unable to   |
   | obtain it through the world-wide-web, please send a note to          |
   | license@php.net so we can mail you a copy immediately.               |
   +----------------------------------------------------------------------+
*/

#pragma once

#include "hphp/runtime/vm/repo-helpers.h"
#include "hphp/runtime/base/attr.h"
#include "hphp/runtime/base/datatype.h"
#include "hphp/runtime/base/type-string.h"
#include "hphp/runtime/base/typed-value.h"
#include "hphp/runtime/base/user-attributes.h"

#include "hphp/runtime/vm/func.h"
#include "hphp/runtime/vm/repo-helpers.h"
#include "hphp/runtime/vm/type-constraint.h"
#include "hphp/runtime/vm/unit.h"
#include "hphp/runtime/vm/unit-emitter.h"

#include <utility>
#include <vector>

namespace HPHP {
///////////////////////////////////////////////////////////////////////////////

struct PreClass;
struct StringData;

struct PreClassEmitter;
struct UnitEmitter;

namespace Native {
struct NativeFunctionInfo;
}

///////////////////////////////////////////////////////////////////////////////

/*
 * Bag of Func's fields used to emit Funcs.
 */
struct FuncEmitter {
  friend struct FuncRepoProxy;

  /////////////////////////////////////////////////////////////////////////////
  // Types.

  using UpperBoundVec = CompactVector<TypeConstraint>;
  using UpperBoundMap =
    std::unordered_map<const StringData*, CompactVector<TypeConstraint>>;
  struct ParamInfo : public Func::ParamInfo {
    ParamInfo() {}

    template<class SerDe>
    void serde(SerDe& sd) {
      Func::ParamInfo* parent = this;
      parent->serde(sd);
      sd(upperBounds);
    }

    UpperBoundVec upperBounds;
  };

  typedef std::vector<ParamInfo> ParamInfoVec;
  typedef std::vector<EHEnt> EHEntVec;

  using CoeffectRuleVec = std::vector<CoeffectRule>;
  using StaticCoeffectsVec = std::vector<LowStringPtr>;

  /////////////////////////////////////////////////////////////////////////////
  // Initialization and execution.

  FuncEmitter(UnitEmitter& ue, int sn, Id id, const StringData* n);
  FuncEmitter(UnitEmitter& ue, int sn, const StringData* n,
              PreClassEmitter* pce);
  ~FuncEmitter();

  /*
   * Just set some fields when we start and stop emitting.
   */
  void init(int l1, int l2, Offset base_, Attr attrs_,
            const StringData* docComment_);
  void finish(Offset past);

  /*
   * Commit this function to a repo.
   */
  void commit(RepoTxn& txn); // throws(RepoExc)

  /*
   * Instantiate a runtime Func*.
   */
  Func* create(Unit& unit, PreClass* preClass = nullptr, bool saveLineTable = false) const;

  template<class SerDe> void serdeMetaData(SerDe&);

  template<class SerDe> void serde(SerDe&);

  /////////////////////////////////////////////////////////////////////////////
  // Metadata.

  /*
   * Get the associated Unit and PreClass emitters.
   */
  UnitEmitter& ue() const;
  PreClassEmitter* pce() const;

  /*
   * XXX: What are these for?
   */
  int sn() const;
  Id id() const;

  /*
   * XXX: Set the whatever these things are.
   */
  void setIds(int sn, Id id);

  bool useGlobalIds() const;
  /////////////////////////////////////////////////////////////////////////////
  // Locals, iterators, and parameters.

  /*
   * Count things.
   */
  Id numLocals() const;
  Id numNamedLocals() const;
  Id numIterators() const;
  Id numLiveIterators() const;

  /*
   * Set things.
   */
  void setNumIterators(Id numIterators);
  void setNumLiveIterators(Id id);

  /*
   * Check existence of, look up, and allocate named locals.
   */
  bool hasVar(const StringData* name) const;
  Id lookupVarId(const StringData* name) const;
  void allocVarId(const StringData* name, bool slotless = false);

  /*
   * Allocate unnamed locals.
   */
  Id allocUnnamedLocal();

  /*
   * Allocate and free iterators.
   */
  Id allocIterator();
  void freeIterator(Id id);

  /*
   * Add a parameter and corresponding named local.
   */
  void appendParam(const StringData* name, const ParamInfo& info);

  /*
   * Get the local variable name -> id map.
   */
  const Func::NamedLocalsMap::Builder& localNameMap() const;


  /////////////////////////////////////////////////////////////////////////////
  // Unit tables.

  /*
   * Add entries to the EH table, and return them by reference.
   */
  EHEnt& addEHEnt();

private:
  /*
   * Private table sort routines; called at finish()-time.
   */
  void sortEHTab();

public:
  /*
   * Declare that the EH table was created in sort-order and doesn't need to be
   * resorted at finish() time.
   */
  void setEHTabIsSorted();

  /////////////////////////////////////////////////////////////////////////////
  // Helper accessors.                                                  [const]

  /*
   * Is the function a method, variadic (i.e., takes a `...'
   * parameter), or an HNI function with a native implementation?
   */
  bool isMethod() const;
  bool isVariadic() const;

  /*
   * @returns: std::make_pair(line1, line2)
   */
  std::pair<int,int> getLocation() const;

  Native::NativeFunctionInfo getNativeInfo() const;
  String nativeFullname() const;

  /////////////////////////////////////////////////////////////////////////////
  // Complex setters.
  //

  /*
   * Shorthand for setting `line1' and `line2' because typing is hard.
   */
  void setLocation(int l1, int l2);

  /*
   * Pulls native and system attributes out of the user attributes map.
   *
   * System attributes are returned by reference through `attrs_', and native
   * attributes are returned as an integer.
   */
  int parseNativeAttributes(Attr& attrs_) const;

  /*
   * Fix some attributes based on the current runtime options that may
   * have been stored incorrectly in the repo.
   */
  Attr fix_attrs(Attr a) const;

  /////////////////////////////////////////////////////////////////////////////
  // Bytecode.

  Offset offsetOf(const unsigned char* pc) const;

  /////////////////////////////////////////////////////////////////////////////
  // Source locations.

  /*
   * Return a copy of the SrcLocTable for the Func, if it has one; otherwise,
   * return an empty table.
   */
  SourceLocTable createSourceLocTable() const;

  /*
   * Does this Func contain full source location information?
   *
   * Generally, FuncEmitters loaded from a production repo will have a
   * LineTable only instead of a full SourceLocTable.
   */
  bool hasSourceLocInfo() const;

  /*
   * Const reference to the Func's LineTable.
   */
  const LineTable& lineTable() const;

  /*
   * Record source location information for the last chunk of bytecode added to
   * this FuncEmitter.
   *
   * Adjacent regions associated with the same source line will be collapsed as
   * this is created.
   */
  void recordSourceLocation(const Location::Range& sLoc, Offset start);

  /////////////////////////////////////////////////////////////////////////////
  // Data members.

private:
  /*
   * Metadata.
   */
  UnitEmitter& m_ue;
  PreClassEmitter* m_pce;

  int m_sn;
  Id m_id;

public:
  /*
   * Func fields.
   */
  Offset base;
  Offset past;
  int line1;
  int line2;
  LowStringPtr name;
  Attr attrs;

  ParamInfoVec params;
  int16_t maxStackCells{0};

  MaybeDataType hniReturnType;
  TypeConstraint retTypeConstraint;
  LowStringPtr retUserType;
  UpperBoundVec retUpperBounds;
  StaticCoeffectsVec staticCoeffects;
  CoeffectRuleVec coeffectRules;

  EHEntVec ehtab;

  union {
    uint16_t m_repoBoolBitset{0};
    struct {
      bool isMemoizeWrapper    : 1;
      bool isMemoizeWrapperLSB : 1;
      bool isClosureBody       : 1;
      bool isAsync             : 1;
      bool containsCalls       : 1;
      bool isNative            : 1;
      bool isGenerator         : 1;
      bool isPairGenerator     : 1;
      bool isRxDisabled        : 1;
      bool hasParamsWithMultiUBs : 1;
      bool hasReturnWithMultiUBs : 1;
    };
  };

  LowStringPtr docComment;
  LowStringPtr originalFilename;

  UserAttributeMap userAttributes;

  StringData* memoizePropName;
  StringData* memoizeGuardPropName;
  int memoizeSharedPropIndex;
  RepoAuthType repoReturnType;
  RepoAuthType repoAwaitedReturnType;

private:
  /*
   * FuncEmitter-managed state.
   */
  Func::NamedLocalsMap::Builder m_localNames;
  Id m_numLocals;
  int m_numUnnamedLocals;
  Id m_numIterators;
  Id m_nextFreeIterator;
  bool m_ehTabSorted;

  /*
   * Source location tables.
   *
   * Each entry encodes an open-closed range of bytecode offsets.
   *
   * The m_sourceLocTab is keyed by the start of each half-open range.  This is
   * to allow appending new bytecode offsets that are part of the same range to
   * coalesce.
   *
   * The m_lineTable is keyed by the past-the-end offset.  This is the
   * format we'll want it in when we go to create a Unit.
   */
  std::vector<std::pair<Offset,SourceLoc>> m_sourceLocTab;
  LineTable m_lineTable;
};

///////////////////////////////////////////////////////////////////////////////

/*
 * Proxy for converting in-repo function representations into FuncEmitters.
 */
struct FuncRepoProxy : public RepoProxy {
  friend struct Func;
  friend struct FuncEmitter;

  explicit FuncRepoProxy(Repo& repo);
  ~FuncRepoProxy();
  void createSchema(int repoId, RepoTxn& txn); // throws(RepoExc)

  struct InsertFuncStmt : public RepoProxy::Stmt {
    InsertFuncStmt(Repo& repo, int repoId) : Stmt(repo, repoId) {}
    void insert(const FuncEmitter& fe,
                RepoTxn& txn, int64_t unitSn, int funcSn, Id preClassId,
                const StringData* name); // throws(RepoExc)
  };

  struct GetFuncsStmt : public RepoProxy::Stmt {
    GetFuncsStmt(Repo& repo, int repoId) : Stmt(repo, repoId) {}
    void get(UnitEmitter& ue); // throws(RepoExc)
  };

  struct GetFuncLineTableStmt : public RepoProxy::Stmt {
    GetFuncLineTableStmt(Repo& repo, int repoId) : Stmt(repo, repoId) {}
    void get(int64_t unitSn, int64_t funcSn, LineTable& lineTable);
  };

  struct InsertFuncSourceLocStmt : public RepoProxy::Stmt {
    InsertFuncSourceLocStmt(Repo& repo, int repoId) : Stmt(repo, repoId) {}
    void insert(RepoTxn& txn, int64_t unitSn, int64_t funcSn, Offset pastOffset, int line0,
                int char0, int line1, int char1); // throws(RepoExc)
  };
  struct GetSourceLocTabStmt : public RepoProxy::Stmt {
    GetSourceLocTabStmt(Repo& repo, int repoId) : Stmt(repo, repoId) {}
    RepoStatus get(int64_t unitSn, int64_t funcSn, SourceLocTable& sourceLocTab);
  };

  InsertFuncStmt insertFunc[RepoIdCount];
  GetFuncsStmt getFuncs[RepoIdCount];
  GetFuncLineTableStmt getFuncLineTable[RepoIdCount];
  InsertFuncSourceLocStmt insertFuncSourceLoc[RepoIdCount];
  GetSourceLocTabStmt getSourceLocTab[RepoIdCount];
};

///////////////////////////////////////////////////////////////////////////////
}

#define incl_HPHP_VM_FUNC_EMITTER_INL_H_
#include "hphp/runtime/vm/func-emitter-inl.h"
#undef incl_HPHP_VM_FUNC_EMITTER_INL_H_

