#ifndef TILER_UTILS_H
#define TILER_UTILS_H

#include <string>
#include <stdexcept>
#include <cassert>
#include <iostream>
#include <ostream>
#include <sstream>
#include <unordered_set>
#include <set>
#include <vector>
#include <map>
#include <algorithm>

namespace tiler {
class tiler_exception : public std::runtime_error
{
public:
  tiler_exception(const char* what) : runtime_error(what) {}
  tiler_exception(const std::string what) : runtime_error(what.c_str()) {}
};
}

// everntually remove EXTERNAL_VERSION
// should be NDEBUG == EXTERNAL_VERSION??
// #ifndef NDEBUG
#ifdef EXTERNAL_VERSION
#define triggered_at ""
#else
#define triggered_at " (triggered at " <<  __FILE__ << ", " << __LINE__ << ")"
#endif

#define issue_warning( ss )  { std::cerr << ss.str() << "\n";}

#ifndef NDEBUG
#define issue_error( ss )  { std::cerr << ss.str() << "\n"; assert( false );}
#else
#define issue_error( ss )  { throw tiler::tiler_exception( ss.str() ); }
#endif


#define tiler_error( M, S ) { std::stringstream ss;                   \
    ss << "# vajra " << M << " Error - " << S                         \
       << triggered_at << std::endl;                                  \
    issue_error( ss ); }


#define tiler_warning( M, S ) { std::stringstream ss;                   \
    ss << "# vajra " << M << " Warning - " << S                         \
       << std::endl;                                                    \
    issue_warning( ss );  }



#define COMPARE_TAIL( A, B, Tail ) ( A < B || ( A == B && ( Tail ) ) )
#define COMPARE_LAST( A, B )       ( A < B )

#define COMPARE_TUPLE1( A, B, F1 ) COMPARE_LAST( std::get<F1>(A), std::get<F1>(B) )
#define COMPARE_TUPLE2( A, B, F1, F2 ) COMPARE_TAIL( std::get<F1>(A), std::get<F1>(B), \
        COMPARE_TUPLE1( A, B, F2 ) )
#define COMPARE_TUPLE3( A, B, F1, F2, F3 ) COMPARE_TAIL( std::get<F1>(A), std::get<F1>(B), \
        COMPARE_TUPLE2( A, B, F2, F3 ) )
#define COMPARE_TUPLE4( A, B, F1, F2, F3, F4 ) COMPARE_TAIL( std::get<F1>(A), std::get<F1>(B), \
        COMPARE_TUPLE3( A, B, F2, F3, F4 ) )


#define COMPARE_OBJ1( A, B, F ) COMPARE_LAST( A.F, B.F )
#define COMPARE_OBJ2( A, B, F1, F2 ) COMPARE_TAIL( A.F1, B.F1, \
        COMPARE_OBJ1( A, B, F2 ) )
#define COMPARE_OBJ3( A, B, F1, F2, F3 ) COMPARE_TAIL( A.F1, B.F1, \
        COMPARE_OBJ2( A, B, F2, F3 ) )
#define COMPARE_OBJ4( A, B, F1, F2, F3, F4 ) COMPARE_TAIL( A.F1, B.F1, \
        COMPARE_OBJ3( A, B, F2, F3, F4 ) )


template <class Key, class Hash = std::hash<Key>,
          class Pred = std::equal_to<Key>>
std::unordered_set<Key, Hash, Pred>
set_union( const std::unordered_set<Key, Hash, Pred>& set1,
           const std::unordered_set<Key, Hash, Pred>& set2 ) {
  std::unordered_set<Key, Hash, Pred> res = set1;
  res.insert(set2.begin(), set2.end());
  return res;
}

template< class Key, class Hash = std::hash<Key>, class Pred = std::equal_to<Key>>
void set_insert( const std::unordered_set<Key, Hash, Pred>& src,
                 std::unordered_set<Key, Hash, Pred>& dst ) {
  dst.insert( src.begin(), src.end() );
}

template< class Key >
void set_insert( const std::set<Key>& src, std::set<Key>& dst ) {
  dst.insert( src.begin(), src.end() );
}

template< class Key >
bool exists( const std::vector<Key>& v, const Key& k ) {
  return std::find( v.begin(), v.end(), k ) != v.end();
}

template< class Key,  class Val>
bool exists( const std::map<Key,Val>& map1, const Key& k ) {
  return map1.find( k ) !=  map1.end();
}

template< class Key,  class Val, class Comp>
bool exists( const std::map<Key,Val,Comp>& map1, const Key& k ) {
  return map1.find( k ) !=  map1.end();
}

template< class Key >
bool exists( std::vector<Key>& v, Key& k ) {
  return std::find( v.begin(), v.end(), k ) != v.end();
}

template< class Key >
bool exists( const std::set<Key>& set1, const Key& k ) {
  return set1.find( k ) !=  set1.end();
}

template< class Key,class cmp >
bool exists( const std::set<Key,cmp>& set1, const Key& k ) {
  return set1.find( k ) !=  set1.end();
}

#endif // TILER_UTILS_H
