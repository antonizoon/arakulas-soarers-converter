/*****************************************************************************/
/* salloc.h : Soarer's special(?) memory allocation routines                 */
/*****************************************************************************/

#ifndef _salloc_h__
#define _salloc_h__

#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

int16_t memfree(void);  // A_164a
char *memalloc(int16_t nelem);  // A_1670
char *memreset(void);  // A_16b2


#ifdef __cplusplus
}
#endif

#endif // defined(_salloc_h__)
