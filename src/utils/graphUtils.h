#ifndef GRAPHUTILS_H
#define GRAPHUTILS_H

#include <iterator>

//TODO: should throw error if cycles detected
template <class T, class n_iter> void
topological_sort( T h,
                  std::function<n_iter(T)> succ_begin,
                  std::function<n_iter(T)> succ_end,
                  std::vector< T >& ord_vec,
                  std::map< T, unsigned >& o_map ) {
  ord_vec.clear();
  o_map.clear();
  std::vector< std::tuple< T, unsigned, n_iter, n_iter > > stack;
  stack.push_back( std::make_tuple( h, 0, succ_begin(h), succ_end(h) ) );

  while( !stack.empty() ) {
    auto& tup     = stack.back();
    T& n          = std::get<0>(tup);
    unsigned& max = std::get<1>(tup);
    n_iter& it    = std::get<2>(tup);
    n_iter& end   = std::get<3>(tup);
    assert( !exists( o_map, n ) );
    while( 1 ) {
      if( it != end ) {
        const T& np     = *it;
        auto o_it = o_map.find( np );
        if( o_it != o_map.end() ) {
          unsigned m_new = o_it->second;
          if( m_new > max ) max = m_new;
          ++it;
        }else{
          stack.push_back(std::make_tuple(np,0,succ_begin(np),succ_end(np)));
          break;
        }
      }else{
        o_map[n] = max + 1;
        ord_vec.push_back(n);
        stack.pop_back();
        break;
      }
    }
  }

  std::sort( ord_vec.begin(), ord_vec.end(),
             [&](const T& x, const T& y) {return o_map.at(x) > o_map.at(y);});
}

#endif
