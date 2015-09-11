/*****************************************************************************/
/* salloc.c : Soarer's special(?) memory allocation routines                 */
/*****************************************************************************/

#include <avr/io.h>
#include <avr/pgmspace.h>
#include <avr/interrupt.h>
#include <util/atomic.h>
#include "hwdefs.h"
#include "salloc.h"

// gleaned from avr-libc's stdlib_private.h
#define STACK_POINTER()  ((char *)AVR_STACK_POINTER_REG)
#define HEAP_MARGIN 32

/*****************************************************************************/
/* Global data                                                               */
/*****************************************************************************/

// provided by avr-gcc
extern char __heap_start;
extern char __heap_end;

uint16_t data_0x0113 = 0x7fff;      // 0x0113 UNUSED?
char *__malloc_heap_end = &__heap_end; // 0x0115
char *__brkval = &__heap_start;  // 0x0117

/*****************************************************************************/
/* memfree : returns amount of free memory                                   */
/*****************************************************************************/
// A_164a
int16_t memfree(void)
{
char *memend = __malloc_heap_end;
if (memend == 0)
  memend = STACK_POINTER() - HEAP_MARGIN;
return memend - __brkval; // &A_03ab
}

/*****************************************************************************/
/* memalloc : allocate a chunk of memory on the heap                         */
/*****************************************************************************/
// A_1670
char *memalloc(int16_t nelem)
{
char *memend = __malloc_heap_end;
char *retaddr;

if (!memend)
  memend = STACK_POINTER() - HEAP_MARGIN;
if (memend - __brkval < nelem)
  return 0;

retaddr = __brkval;
__brkval += nelem;
return retaddr;
}

/*****************************************************************************/
/* memreset : reset memory allocation                                        */
/*****************************************************************************/
// A_16b2
char *memreset(void)
{
__brkval = &__heap_start;  // 0x0117  = 0x03ab;
return __brkval;
}

